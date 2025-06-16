# Emerald-API Grafting Instructions (Without Cherry-Pick)

## For IntelliJ Terminal - 1.78.x and 1.75.x Versions Only

### Step 1: Setup and create branch for latest version (1.78.x)
```bash
# DO THIS
cd ~/IdeaProjects/emerald-api-4/emerald-api
git fetch --all
git checkout dev/metl/1.78.x
git pull origin dev/metl/1.78.x
git checkout -b port/metl/1.78.x/EMD-xxxxx
```

### Step 2: Create a placeholder commit (no cherry-pick)
```bash
# DO THIS
# Create a README note or appropriate placeholder file
echo "# Grafting of DPC-xxxxx - Feature Description" > grafting-note.md
git add grafting-note.md
git commit -m "feat(EMD-xxxxx): Graft DPC-xxxxx - Feature Description"
```

### Step 3: Push to remote
```bash
# DO THIS
git push -u origin port/metl/1.78.x/EMD-xxxxx
```

### Step 4: Create branch for oldest supported version (1.75.x)
```bash
# DO THIS
git checkout dev/metl/1.75.x
git pull origin dev/metl/1.75.x
# If branches have diverged, merge changes from remote
git merge origin/dev/metl/1.75.x -m "feat(EMD/DPC-xxxxx): merge main to resolve conflicts"
git checkout -b port/metl/1.75.x/EMD-xxxxx

# DO THIS
# Create a README note or appropriate placeholder file
echo "# Grafting of DPC-xxxxx - Feature Description" > grafting-note.md
git add grafting-note.md
git commit -m "feat(EMD-xxxxx): Graft DPC-xxxxx - Feature Description"
git push -u origin port/metl/1.75.x/EMD-xxxxx
```

### Step 5: Create PRs
Create 2 PRs:
1. port/metl/1.78.x/EMD-xxxxx → dev/metl/1.78.x
2. port/metl/1.75.x/EMD-xxxxx → dev/metl/1.75.x

PR title format: "DPC-xxxxx: Graft Feature Description (1.78.x)"

Use the GitHub CLI to create PRs efficiently:

```bash
# Authenticate with GitHub CLI (if not already done)
gh auth login

# Create PR for 1.78.x
gh pr create --base dev/metl/1.78.x --head port/metl/1.78.x/EMD-xxxxx \
  --title "EMD-xxxxx: Graft Feature Description (1.78.x)" \
  --body "## Overview\nThis PR adds the necessary grafting setup for emerald-api.\n\n## Implementation Details\n- Added placeholder for EMD-xxxxx\n\n## Testing\n- N/A for placeholder PR"

# Create PR for 1.75.x
gh pr create --base dev/metl/1.75.x --head port/metl/1.75.x/EMD-xxxxx \
  --title "EMD-xxxxx: Graft Feature Description (1.75.x)" \
  --body "## Overview\nThis PR adds the necessary grafting setup for emerald-api.\n\n## Implementation Details\n- Added placeholder for EMD-xxxxx\n\n## Testing\n- N/A for placeholder PR"
```

## Saving PR Links for Reference

When your PRs are created, save both links for easy reference in a single script that also **automatically opens the PRs in your browser**:

```bash
# Create a script that both displays AND opens PR links in your browser
cat > ~/emerald_api_pr_links.sh << 'EOL'
#!/bin/bash
echo "========== EMERALD-API PRs =========="
echo "1.75.x PR: https://github.com/matillion/emerald-api/pull/YOUR_175X_PR_NUMBER"
echo "1.78.x PR: https://github.com/matillion/emerald-api/pull/YOUR_178X_PR_NUMBER"
echo "==============================="

# Ask which PR to open
echo -e "\nWhich PR do you want to open?\n1) 1.75.x PR\n2) 1.78.x PR\n3) Both\n4) None"
read -p "Enter choice [1-4]: " choice

case $choice in
  1) echo "Opening 1.75.x PR..."
     open "https://github.com/matillion/emerald-api/pull/YOUR_175X_PR_NUMBER" ;;
  2) echo "Opening 1.78.x PR..."
     open "https://github.com/matillion/emerald-api/pull/YOUR_178X_PR_NUMBER" ;;
  3) echo "Opening both PRs..."
     open "https://github.com/matillion/emerald-api/pull/YOUR_175X_PR_NUMBER"
     open "https://github.com/matillion/emerald-api/pull/YOUR_178X_PR_NUMBER" ;;
  *) echo "No PR opened" ;;
esac
EOL

# Make it executable
chmod +x ~/emerald_api_pr_links.sh

# Test it
~/emerald_api_pr_links.sh
```
