#!/bin/bash
# Emerald Version Update Script
# Reference: emerald-full-grafting-plan.mld lines 12-21, 66-79

set -e  # Exit on any error

# Function to prompt for input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    read -p "$prompt: " $var_name
}

echo "🚀 EMERALD VERSION UPDATE SCRIPT"
echo "================================="

# Get inputs
prompt_input "Ticket Number (EMD-XXXXX or DPC-XXXXX)" TICKET_NUMBER
prompt_input "New Version (e.g., 11.148.0-port-met-1.75.x-EMD-35672-SNAPSHOT)" NEW_VERSION
prompt_input "Target Version (e.g., 1.75.x, 1.78.x)" TARGET_VERSION

# Setup Git Environment
echo "⚡ Setting up Git environment..."
export GIT_EDITOR=true

# Navigate to Emerald Project
echo "⚡ Navigating to Emerald project..."
cd ~/IdeaProjects/EmeraldV5
echo "Current directory: $(pwd)"

# Create Version Update Branch
echo "⚡ Creating version update branch..."
git fetch --all
git checkout dev/$TARGET_VERSION
git pull origin dev/$TARGET_VERSION

BRANCH_NAME="port/met/$TARGET_VERSION/$TICKET_NUMBER"
echo "Creating branch: $BRANCH_NAME"

# Delete local branch if exists
git branch -D "$BRANCH_NAME" 2>/dev/null || true

# Create new branch
git checkout -b "$BRANCH_NAME"

# Update emeraldLibsVersion
echo "⚡ Updating emeraldLibsVersion..."
echo "Current version:"
grep -n "emeraldLibsVersion" pom.xml || echo "No current version found"

# Create backup and update version
sed -i.bak "s/<emeraldLibsVersion>[^<]*<\/emeraldLibsVersion>/<emeraldLibsVersion>$NEW_VERSION<\/emeraldLibsVersion>/" pom.xml

echo "Updated version:"
grep -n "emeraldLibsVersion" pom.xml

# Run Dependency Resolution
echo "⚡ Running Maven dependency resolution..."
mvn dependency:resolve -U

# Run Dependency Management Script
echo "⚡ Running dependency management script..."
python3 ./dependency-management/src/regenerate_dependencies.py

# Commit Changes
echo "⚡ Committing changes..."
git add .
COMMIT_MSG="$TICKET_NUMBER: Update emeraldLibsVersion to $NEW_VERSION"
git commit -m "$COMMIT_MSG"

# Push Branch
echo "⚡ Pushing branch..."
git push origin "$BRANCH_NAME" --force

# Generate PR Link
PR_LINK="https://github.com/matillion/emerald/compare/dev/$TARGET_VERSION...$BRANCH_NAME?expand=1"

echo ""
echo "================================"
echo "✅ VERSION UPDATE COMPLETED!"
echo "================================"
echo "Branch: $BRANCH_NAME"
echo "Ticket: $TICKET_NUMBER"
echo "Version: $NEW_VERSION"
echo ""
echo "Create PR here:"
echo "$PR_LINK"
echo "================================"
