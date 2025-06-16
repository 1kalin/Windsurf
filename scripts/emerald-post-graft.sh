#!/bin/bash
# Emerald Post-Graft Script
# Reference: emerald-full-grafting-plan.mld lines 77-78, emerald-grafting-postgraft.md

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

echo "🚀 EMERALD POST-GRAFT SCRIPT"
echo "============================="

# Get inputs
prompt_input "Ticket Number (EMD-XXXXX or DPC-XXXXX)" TICKET_NUMBER
prompt_input "Source Commit SHA" SOURCE_COMMIT
prompt_input "Target Version (e.g., 1.75.x, 1.78.x)" TARGET_VERSION
prompt_yn "Is this a merge commit?" IS_MERGE_COMMIT

# Setup Git Environment
echo "⚡ Setting up Git environment..."
export GIT_EDITOR=true

# Navigate to Emerald Project
echo "⚡ Navigating to Emerald project..."
cd ~/IdeaProjects/EmeraldV5
echo "Current directory: $(pwd)"

# Fetch Latest Changes
echo "⚡ Fetching latest changes..."
git fetch --all --tags

# Checkout Existing Version Branch
BRANCH_NAME="port/met/$TARGET_VERSION/$TICKET_NUMBER"
echo "⚡ Checking out existing branch: $BRANCH_NAME"
git checkout "$BRANCH_NAME"
git pull origin "$BRANCH_NAME" || echo "Branch may not exist on remote yet"

# Show Source Commit Info
echo "⚡ Source commit information:"
echo "================================"
git show --stat $SOURCE_COMMIT
echo "================================"

# Cherry-pick Implementation Changes
echo "⚡ Cherry-picking implementation changes..."
echo "Note: Skipping emeraldLibsVersion, dependencies pom, and checksums as per line 78"

if [ "$IS_MERGE_COMMIT" = true ]; then
    echo "Cherry-picking merge commit with -m 1 flag..."
    git cherry-pick -m 1 $SOURCE_COMMIT
else
    echo "Cherry-picking regular commit..."
    git cherry-pick $SOURCE_COMMIT
fi

# Handle Conflicts (automated)
if git status --porcelain | grep -q "^UU\|^AA\|^DD"; then
    echo "⚡ Conflicts detected, applying automated resolution..."
    
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
echo "⚡ Running dependency management..."
mvn dependency:resolve -U
python3 ./dependency-management/src/regenerate_dependencies.py

# Commit Additional Changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "⚡ Additional changes detected, committing..."
    git add .
    COMMIT_MSG="$TICKET_NUMBER: Post-graft dependency updates"
    git commit -m "$COMMIT_MSG" || echo "No additional changes to commit"
else
    echo "No additional changes to commit"
fi

# Verify Changes
echo "⚡ Recent commits:"
git log --oneline -5

echo "⚡ Branch status:"
git status

# Push Updated Branch
echo "⚡ Pushing updated branch..."
git push origin "$BRANCH_NAME" --force

# Generate PR Link
PR_LINK="https://github.com/matillion/emerald/compare/dev/$TARGET_VERSION...$BRANCH_NAME?expand=1"

echo ""
echo "================================"
echo "✅ EMERALD POST-GRAFT COMPLETED!"
echo "================================"
echo "Source commit: $SOURCE_COMMIT"
echo "Branch: $BRANCH_NAME"
echo "Ticket: $TICKET_NUMBER"
echo "Target version: $TARGET_VERSION"
echo ""
echo "Update existing PR or create new one here:"
echo "$PR_LINK"
echo "================================"
