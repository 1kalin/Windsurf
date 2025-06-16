# Emerald Pre-Graft Template (emeraldLibsVersion Update)

This template is for the first phase of grafting in Emerald projects - updating the emeraldLibsVersion in pom.xml.

## ⭐ Automated Script Method (Recommended)

The easiest and recommended way to perform the pre-graft emeraldLibsVersion update is using the provided script:

```bash
# Navigate to the scripts directory
cd ~/IdeaProjects/zero-gravity/scripts

# Run the script interactively
./emerald-version-update.sh
```

**Non-interactive execution** is also possible by piping input values:

```bash
echo -e "TICKET_NUMBER\nNEW_VERSION\nTARGET_VERSION\n" | ./emerald-version-update.sh
```

Example:
```bash
echo -e "DPC-27474\n11.147.3-port-metl-1.75.x-DPC-27474-SNAPSHOT\n1.75.x\n" | ./emerald-version-update.sh
```

The script will handle all the following steps automatically:
- Setting up the Git environment
- Navigating to the Emerald project
- Creating the version update branch
- Updating the emeraldLibsVersion in pom.xml
- Committing and pushing changes
- Providing PR creation links

## Manual Process (Alternative)

## Target Versions
- **1.78.x** - Currently uses version pattern: `13.XX.X-port-metl-1.78.x-TICKET-SNAPSHOT`
- **1.75.x** - Currently uses version pattern: `11.XX.X-port-metl-1.75.x-TICKET-SNAPSHOT`

## Pre-Graft Steps (for both 1.78.x and 1.75.x)

### 1. Find the Appropriate SNAPSHOT Version

#### CRITICAL PREREQUISITE: Checkout the Target Branch in Emerald API
Before running any dependency commands, you MUST checkout the relevant port branch in emerald-api to find the correct SNAPSHOT version:

```bash
# Navigate to emerald-api directory
cd ~/IdeaProjects/emerald-api-4/emerald-api

# Fetch all branches and checkout the target port branch
git fetch --all

# For 1.78.x
git checkout port/metl/1.78.x/TICKET-NUMBER  # Replace with your actual ticket

# OR for 1.75.x
git checkout port/metl/1.75.x/TICKET-NUMBER  # Replace with your actual ticket
```

#### Using `gradlew dependencies` with `grep` (Recommended)
After checking out the correct branch, use the following command to find the latest SNAPSHOT version:

**Prerequisites:**
- You have checked out the relevant port branch in emerald-api
- You are in the `emerald-api/libs` directory of the `emerald-api-4` project

**Command (Split into two steps for reliability):**
```bash
# Step 1: Run gradle and pipe output to file
./gradlew --console=plain dependencies --no-configuration-cache | grep "SNAPSHOT" > snapshot_versions.txt

# Step 2: Display the contents of the file and delete it
cat snapshot_versions.txt && rm snapshot_versions.txt
```

**Example Output:**
```
# For 1.78.x
com.matillion.emerald|13.13.7-port-metl-1.78.x-DPC-27474-SNAPSHOT

# For 1.75.x
com.matillion.emerald|11.147.3-port-metl-1.75.x-DPC-27474-SNAPSHOT
```

You'll need the version string for updating emeraldLibsVersion in the next step.

### 2. Create a Branch and Update emeraldLibsVersion

```bash
# Set variables for your target version
TARGET_VERSION="1.78.x"  # Change to 1.75.x if needed
TICKET="DPC-XXXXX"       # Replace with your actual ticket

# Navigate to emerald project and setup environment
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5

# Create the branch
git fetch --all
git checkout dev/$TARGET_VERSION
git pull
git checkout -b port/metl/$TARGET_VERSION/$TICKET

# Update the emeraldLibsVersion in pom.xml
VERSION="YOUR-SNAPSHOT-VERSION-HERE"  # From step 1 above
sed -i.bak 's/<emeraldLibsVersion>[^<]*<\/emeraldLibsVersion>/<emeraldLibsVersion>'"$VERSION"'<\/emeraldLibsVersion>/' pom.xml

# Commit and push
git add pom.xml
git commit -m "$TICKET: Update emeraldLibsVersion to $VERSION"
git push -u origin port/metl/$TARGET_VERSION/$TICKET

# Create placeholder commit note
echo "# Grafting of $TICKET - Description" > grafting-note.md
git add grafting-note.md
git commit -m "$TICKET: Graft $TICKET - Description"
git push origin port/metl/$TARGET_VERSION/$TICKET
```

### 3. Create and Share Pull Request

```bash
# Authenticate with GitHub CLI (if not already done)
gh auth login

# Create PR with detailed information - this will return a URL
gh pr create --base dev/1.78.x --head port/metl/1.78.x/TICKET \
  --title "TICKET: Update emeraldLibsVersion to SNAPSHOT version (1.78.x)" \
  --body "## Overview\nThis PR updates the emeraldLibsVersion to use the correct SNAPSHOT version as part of the pregrafting process.\n\n## Implementation Details\n- Updated emeraldLibsVersion to XX.XX.X-port-metl-1.78.x-TICKET-SNAPSHOT\n\n## Testing\n- Verified the pom.xml contains the correct SNAPSHOT version"

# You'll get a response with a PR URL like:
# https://github.com/matillion/emerald/pull/XXXX
# Make sure to copy and share this URL with your team

# Alternatively, you can get the URL of your PR after creation with:
gh pr view --web
```

#### Example PR Creation with Real Values

```bash
# For a real ticket like DPC-27474 on 1.75.x branch
gh pr create --base dev/1.75.x --head port/metl/1.75.x/DPC-27474-v2 \
  --title "DPC-27474: Update emeraldLibsVersion to 11.147.3-port-metl-1.75.x-DPC-27474-SNAPSHOT (1.75.x)" \
  --body "## Overview\nThis PR updates the emeraldLibsVersion to use the correct SNAPSHOT version as part of the pregrafting process.\n\n## Implementation Details\n- Updated emeraldLibsVersion to 11.147.3-port-metl-1.75.x-DPC-27474-SNAPSHOT\n\n## Testing\n- Verified the pom.xml contains the correct SNAPSHOT version"
```

## Saving PR Links for Reference

When your PRs are created, save both links for easy reference in a single script that also **automatically opens the PRs in your browser**:

```bash
# Create a script that both displays AND opens PR links in your browser
cat > ~/pr_links_clickable.sh << 'EOL'
#!/bin/bash
echo "========== EMERALD PRs =========="
echo "1.75.x PR: https://github.com/matillion/emerald/pull/YOUR_175X_PR_NUMBER"
echo "1.78.x PR: https://github.com/matillion/emerald/pull/YOUR_178X_PR_NUMBER"
echo "==============================="

# Ask which PR to open
echo -e "\nWhich PR do you want to open?\n1) 1.75.x PR\n2) 1.78.x PR\n3) Both\n4) None"
read -p "Enter choice [1-4]: " choice

case $choice in
  1) echo "Opening 1.75.x PR..."
     open "https://github.com/matillion/emerald/pull/YOUR_175X_PR_NUMBER" ;;
  2) echo "Opening 1.78.x PR..."
     open "https://github.com/matillion/emerald/pull/YOUR_178X_PR_NUMBER" ;;
  3) echo "Opening both PRs..."
     open "https://github.com/matillion/emerald/pull/YOUR_175X_PR_NUMBER"
     open "https://github.com/matillion/emerald/pull/YOUR_178X_PR_NUMBER" ;;
  *) echo "No PR opened" ;;
esac
EOL

# Make it executable
chmod +x ~/pr_links_clickable.sh

# Test it
~/pr_links_clickable.sh
```

You can then quickly view and open PR links anytime by running `~/pr_links_clickable.sh`

*Remember to adjust the branch names and version details based on your specific target version (1.75.x or 1.78.x).*

### Important Reminders
- **NEVER push grafting notes to PRs.** If you create a grafting-note.md file for documentation, make sure to delete it from both branches before finalizing the PRs.
- After completing these pre-graft steps, proceed to the post-graft steps in `emerald-grafting-postgraft.md` if implementation changes need to be cherry-picked.
