# Emerald Grafting Instructions (Without Cherry-Pick)

## For IntelliJ Terminal - 1.78.x and 1.75.x Versions Only

### Step 1: Setup and create branch for latest version (1.78.x)
```bash
# DO THIS
cd ~/IdeaProjects/emerald
git fetch --all
git checkout dev/metl/1.78.x
git pull origin dev/metl/1.78.x
git checkout -b port/met/1.78.x/EMD-xxxxx
```

### Step 2: Create a placeholder commit (no cherry-pick)
```bash
# DO THIS
# Create a README note or appropriate placeholder file
echo "# Grafting of DPC-xxxxx - Feature Description" > grafting-note.md
git add grafting-note.md
git commit -m "EMD/DPC-xxxxx: Graft DPC-xxxxx - Feature Description"
```

### Step 3: Push to remote
```bash
# DO THIS
git push -u origin port/met/1.78.x/EMD-xxxxx
```

### Step 4: Create branch for oldest supported version (1.75.x)
```bash
# DO THIS
git checkout dev/metl/1.75.x
git pull origin dev/metl/1.75.x
# If branches have diverged, merge changes from remote
git merge origin/dev/metl/1.75.x -m "EMD/DPC-xxxxx: merge main to resolve conflicts"
git checkout -b port/met/1.75.x/EMD-xxxxx

# DO THIS
# Create a README note or appropriate placeholder file
echo "# Grafting of DPC-xxxxx - Feature Description" > grafting-note.md
git add grafting-note.md
git commit -m "EMD/DPC-xxxxx: Graft DPC-xxxxx - Feature Description"
git push -u origin port/met/1.75.x/EMD-xxxxx
```

### Step 5: Create PRs
Create 2 PRs:
1. port/met/1.78.x/EMD-xxxxx → dev/metl/1.78.x
2. port/met/1.75.x/EMD-xxxxx → dev/metl/1.75.x

PR title format: "Port/met/1.78.x/EMD-xxxxx: Graft Feature Description"

Use the GitHub URLs provided in the terminal output to create the PRs easily.
