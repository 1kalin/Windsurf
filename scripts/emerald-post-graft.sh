#!/bin/bash
# Emerald Post-Graft Script
# Reference: emerald-full-grafting-plan.mld lines 77-78, emerald-grafting-postgraft.md

# Configuration - Update this for your local environment
USERNAME=${USERNAME:-"charlottewilkins"}
EMERALD_PATH="/Users/$USERNAME/IdeaProjects/emerald"

set -e  # Exit on any error

# Function to prompt for input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    read -p "$prompt: " $var_name
}

# Function to prompt for yes/no
prompt_yn() {
    local prompt="$1"
    local var_name="$2"
    while true; do
        read -p "$prompt (y/n): " yn
        case $yn in
            [Yy]* ) eval $var_name=true; break;;
            [Nn]* ) eval $var_name=false; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

echo " EMERALD POST-GRAFT SCRIPT"
echo "============================="

# Function to detect if a commit is a merge commit
is_merge_commit() {
    local commit_sha="$1"
    # Count number of parents - merge commits have more than one parent
    local parent_count=$(git show --format=%P "$commit_sha" | head -1 | wc -w)
    
    if [ "$parent_count" -gt 1 ]; then
        return 0 # true in bash
    else
        return 1 # false in bash
    fi
}

# Get inputs
prompt_input "Ticket Number (EMD-XXXXX or DPC-XXXXX)" TICKET_NUMBER
prompt_input "Source Commit SHA" SOURCE_COMMIT
prompt_input "Target Version (e.g., 1.75.x, 1.78.x)" TARGET_VERSION

# Navigate to Emerald Project temporarily to check commit type
cd "$EMERALD_PATH" > /dev/null 2>&1
git fetch --all --tags > /dev/null 2>&1
# Auto-detect if commit is a merge commit
if is_merge_commit "$SOURCE_COMMIT"; then
    AUTO_DETECTED_MERGE=true
    MERGE_DETECTION_MSG="(Auto-detected as MERGE commit)"
else
    AUTO_DETECTED_MERGE=false
    MERGE_DETECTION_MSG="(Auto-detected as REGULAR commit)"
fi
cd - > /dev/null 2>&1

prompt_yn "Is this a merge commit? $MERGE_DETECTION_MSG" IS_MERGE_COMMIT

# Setup Git Environment
echo " Setting up Git environment..."
export GIT_EDITOR=true

echo " Commit details:"
echo "- Ticket: $TICKET_NUMBER"
echo "- Source commit: $SOURCE_COMMIT"
echo "- Target version: $TARGET_VERSION"
echo "- Is merge commit: $IS_MERGE_COMMIT"

# Navigate to Emerald Project
echo " Navigating to Emerald project..."
cd "$EMERALD_PATH"
echo "Current directory: $(pwd)"

# Fetch Latest Changes
echo " Fetching latest changes..."
git fetch --all --tags

# Checkout or Create Branch
BRANCH_NAME="port/met/$TARGET_VERSION/$TICKET_NUMBER"
echo " Checking out or creating branch: $BRANCH_NAME"

# Try to checkout existing branch, create it if it doesn't exist
if git checkout "$BRANCH_NAME" 2>/dev/null; then
    echo "Branch exists, pulling latest changes..."
    git pull origin "$BRANCH_NAME" || echo "Branch may not exist on remote yet"
else
    echo "Branch doesn't exist, creating from dev/$TARGET_VERSION..."
    git checkout -b "$BRANCH_NAME" "dev/$TARGET_VERSION"
fi

# Show Source Commit Info
echo " Source commit information:"
echo "================================"
git show --stat $SOURCE_COMMIT
echo "================================"

# Cherry-pick Implementation Changes
echo " Cherry-picking implementation changes..."
echo "Note: Skipping emeraldLibsVersion, dependencies pom, and checksums as per line 78"

if [ "$IS_MERGE_COMMIT" = true ]; then
    echo "Cherry-picking merge commit with -m 1 flag..."
    echo "This will apply changes from the first parent of the merge commit"
    echo "(equivalent to: git cherry-pick -m 1 $SOURCE_COMMIT)"
    git cherry-pick -m 1 $SOURCE_COMMIT
else
    echo "Cherry-picking regular commit..."
    git cherry-pick $SOURCE_COMMIT
fi

# Handle Conflicts (automated)
if git status --porcelain | grep -q "^UU\|^AA\|^DD"; then
    echo " Conflicts detected, applying automated resolution..."
    
    # Handle gradle.lockfile conflicts
    for lockfile in $(git status --porcelain | grep "gradle.lockfile" | awk '{print $2}'); do
        echo "Removing conflicted gradle.lockfile: $lockfile"
        git rm "$lockfile"
    done
    
    # Skip version-related conflicts (ref: line 78)
    for file in $(git status --porcelain | grep -E "^UU|^AA" | awk '{print $2}'); do
        if [[ "$file" =~ pom\.xml ]] && git diff --name-only --diff-filter=U | grep -q pom.xml; then
            echo "Skipping pom.xml emeraldLibsVersion conflicts as per line 78"
            git checkout --ours "$file"
            git add "$file"
        elif [[ ! "$file" =~ gradle\.lockfile ]]; then
            echo "Resolving conflict in $file by keeping current branch version"
            git checkout --ours "$file"
            git add "$file"
        fi
    done
    
    # Continue cherry-pick
    git cherry-pick --continue
else
    echo "No conflicts detected"
fi

# Run Dependency Management
echo " Running dependency management..."
mvn dependency:resolve -U
python3 ./dependency-management/src/regenerate_dependencies.py

# Commit Additional Changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo " Additional changes detected, committing..."
    git add .
    COMMIT_MSG="$TICKET_NUMBER: Post-graft dependency updates"
    git commit -m "$COMMIT_MSG" || echo "No additional changes to commit"
else
    echo "No additional changes to commit"
fi

# Verify Changes
echo " Recent commits:"
git log --oneline -5

echo " Branch status:"
git status

# Push Updated Branch
echo " Pushing updated branch..."
git push origin "$BRANCH_NAME" --force

# Generate PR Link
PR_LINK="https://github.com/matillion/emerald/compare/dev/$TARGET_VERSION...$BRANCH_NAME?expand=1"

echo ""
echo "================================"
echo " EMERALD POST-GRAFT COMPLETED!"
echo "================================"
echo "Source commit: $SOURCE_COMMIT"
echo "Branch: $BRANCH_NAME"
echo "Ticket: $TICKET_NUMBER"
echo "Target version: $TARGET_VERSION"
echo ""
echo "Update existing PR or create new one here:"
echo "$PR_LINK"
echo "================================"
