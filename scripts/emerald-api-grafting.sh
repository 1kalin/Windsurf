#!/bin/bash
# Emerald API Grafting Script
# Reference: emerald-full-grafting-plan.mld lines 22-40, emerald-api-grafting.md

# Configuration - Update this for your local environment
USERNAME=${USERNAME:-"charlottewilkins"}
EMERALD_API_PATH="/Users/$USERNAME/IdeaProjects/emerald-api"

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

echo " EMERALD API GRAFTING SCRIPT"
echo "==============================="

# Get inputs
prompt_input "Ticket Number (EMD-XXXXX or DPC-XXXXX)" TICKET_NUMBER
prompt_input "Source Commit SHA" SOURCE_COMMIT
prompt_input "Target Branch (e.g., dev/metl/1.75.x)" TARGET_BRANCH
prompt_yn "Is this a merge commit?" IS_MERGE_COMMIT

# Setup Git Environment
echo " Setting up Git environment..."
export GIT_EDITOR=true

# Navigate to Emerald API Project
echo " Navigating to emerald-api project..."
cd "$EMERALD_API_PATH"
echo "Current directory: $(pwd)"

# Fetch Latest Changes
echo " Fetching latest changes..."
git fetch --all --tags

# Create Graft Branch
echo " Creating graft branch..."
git checkout $TARGET_BRANCH
git pull origin $TARGET_BRANCH

GRAFT_BRANCH="graft/$TARGET_BRANCH/$TICKET_NUMBER"
echo "Creating graft branch: $GRAFT_BRANCH"

# Delete local branch if exists
git branch -D "$GRAFT_BRANCH" 2>/dev/null || true

# Create new branch
git checkout -b "$GRAFT_BRANCH"

# Show Source Commit Info
echo " Source commit information:"
echo "================================"
git show --stat $SOURCE_COMMIT
echo "================================"

# Cherry-pick Changes
echo " Cherry-picking changes..."
if [ "$IS_MERGE_COMMIT" = true ]; then
    echo "Cherry-picking merge commit with -m 1 flag..."
    git cherry-pick -m 1 $SOURCE_COMMIT
else
    echo "Cherry-picking regular commit..."
    git cherry-pick $SOURCE_COMMIT
fi

# Handle Conflicts (automated)
if git status --porcelain | grep -q "^UU|^AA|^DD"; then
    echo " Conflicts detected, applying automated resolution..."
    
    # Handle gradle.lockfile conflicts
    for lockfile in $(git status --porcelain | grep "gradle.lockfile" | awk '{print $2}'); do
        echo "Removing conflicted gradle.lockfile: $lockfile"
        git rm "$lockfile"
    done
    
    # For other conflicts, keep current branch version
    for file in $(git status --porcelain | grep -E "^UU|^AA" | awk '{print $2}'); do
        if [[ ! "$file" =~ gradle\.lockfile ]]; then
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

# Verify Changes
echo " Recent commits:"
git log --oneline -5

echo " Branch status:"
git status

# Push Graft Branch
echo " Pushing graft branch..."
git push origin "$GRAFT_BRANCH" --force

# Generate PR Link
VERSION=$(echo "$TARGET_BRANCH" | sed 's/.*\///')
PR_LINK="https://github.com/matillion/emerald-api/compare/$TARGET_BRANCH...$GRAFT_BRANCH?expand=1"

echo ""
echo "================================"
echo " EMERALD-API GRAFTING COMPLETED!"
echo "================================"
echo "Source commit: $SOURCE_COMMIT"
echo "Target branch: $TARGET_BRANCH"
echo "Graft branch: $GRAFT_BRANCH"
echo "Ticket: $TICKET_NUMBER"
echo ""
echo "Create PR here:"
echo "$PR_LINK"
echo "================================"
