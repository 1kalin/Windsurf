# Emerald Post-Graft Template (Implementation Changes)

This template is for the second phase of grafting in Emerald projects - cherry-picking implementation changes after emeraldLibsVersion has been updated.

## ⭐ Automated Script Method (Recommended)

The easiest and recommended way to perform the post-graft implementation changes is using the provided script:

```bash
# Navigate to the scripts directory
cd ~/IdeaProjects/Windsurf/scripts

# Run the script interactively
./emerald-post-graft.sh
```

You'll be prompted for:
- Ticket Number (EMD-XXXXX or DPC-XXXXX)
- Source Commit SHA
- Target Version (e.g. 1.75.x)
- Is Merge Commit? (y/n)

The script will handle all the following steps automatically:
- Setting up the Git environment
- Checking out the pre-grafted branch
- Cherry-picking the implementation changes (with `-m 1` for merge commits)
- Initial conflict resolution
- Committing and pushing changes

## Manual Process (Alternative)

## Post-Graft Steps for 1.78.x

1. Checkout the pre-grafted branch:
```bash
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5
git checkout port/metl/1.78.x/EMD-XXXXX
```

2. Find the merge commit for the implementation changes:
```bash
# For regular EMD tickets
git log --merges | grep -i "pull request.*EMD-XXXXX"

# For DPC tickets
git log --merges | grep -i "pull request.*DPC-XXXXX"
```

3. Cherry-pick the merge commit with the `-m 1` option:
```bash
git cherry-pick -m 1 <merge-commit-sha>
```

4. Resolve conflicts if they occur:
```bash
# For pom.xml and dependency files, keep our version
git checkout --ours pom.xml dependency-management/pom.xml dependency-management/checksums.txt
git add pom.xml dependency-management/pom.xml dependency-management/checksums.txt

# For Java files with method-level conflicts, use JDime
jdime --mode structured --output merged.java left.java base.java right.java
git add merged.java

# Continue the cherry-pick
git cherry-pick --continue
```

5. Push the changes:
```bash
git push origin port/metl/1.78.x/EMD-XXXXX
```

## Post-Graft Steps for 1.75.x

1. Checkout the pre-grafted branch:
```bash
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5
git checkout port/metl/1.75.x/EMD-XXXXX
```

2. Find the merge commit for the implementation changes:
```bash
# For regular EMD tickets
git log --merges | grep -i "pull request.*EMD-XXXXX"

# For DPC tickets
git log --merges | grep -i "pull request.*DPC-XXXXX"
```

3. Cherry-pick the merge commit with the `-m 1` option:
```bash
git cherry-pick -m 1 <merge-commit-sha>
```

4. Resolve conflicts if they occur:
```bash
# For pom.xml and dependency files, keep our version
git checkout --ours pom.xml dependency-management/pom.xml dependency-management/checksums.txt
git add pom.xml dependency-management/pom.xml dependency-management/checksums.txt

# For Java files with method-level conflicts, use JDime
jdime --mode structured --output merged.java left.java base.java right.java
git add merged.java

# Continue the cherry-pick
git cherry-pick --continue
```

5. Push the changes:
```bash
git push origin port/metl/1.75.x/EMD-XXXXX
```

## Advanced Merge Commit Handling

### Detecting Merge Commits
```bash
# Count parents - if more than 1, it's a merge commit
git show --format=%P <commit-sha> | wc -w
```

### Cherry-picking Merge Commits
Always use `-m 1` flag when cherry-picking merge commits to select changes from the first parent (the branch we merged into):
```bash
git cherry-pick -m 1 <commit-sha>
```

## Advanced Conflict Resolution

### For Gradle Files
```bash
git rm <path/to/gradle.lockfile>
git cherry-pick --continue
```

### For Java Files with Method-level Conflicts
Use JDime which understands Java syntax for intelligent merging:
```bash
# Install JDime if needed

# For specific files:
jdime --mode structured --output merged.java left.java base.java right.java

# Then add the merged file:
git add merged.java
git cherry-pick --continue
```

### For Other Files
```bash
# Keep our version:
git checkout --ours <path/to/conflicting-file>
# Keep their version:
git checkout --theirs <path/to/conflicting-file>

git add <path/to/conflicting-file>
git cherry-pick --continue
```

## Creating Post-Graft PRs

### Using GitHub CLI (Recommended)
```bash
# Authenticate with GitHub CLI
gh auth login

# Create PR with detailed information
gh pr create --base dev/1.78.x --head port/metl/1.78.x/TICKET \
  --title "TICKET: Implementation changes (1.78.x)" \
  --body "## Overview\nThis PR adds implementation changes as part of the postgrafting process.\n\n## Cherry-pick Information\n- Original PR: #XXX\n- Original commit: SHA\n- This is a cherry-picked merge commit using \`-m 1\` flag\n- Conflicts: Yes/No\n\n## Implementation Details\n- Added file X\n- Modified implementation of Y\n\n## Testing\n- Tests pass in 1.78.x environment"
```

## Final Cleanup

1. Create a comprehensive grafting note for documentation (not to be pushed):
```bash
# Create or update grafting-note.md with details about the grafting process
# Include information about the merge commit, files modified, conflicts resolved, etc.
```

2. Remove the grafting note from both branches before finalizing PRs:
```bash
# For 1.78.x
git checkout port/metl/1.78.x/EMD-XXXXX
git rm grafting-note.md
git commit -m "EMD-XXXXX: Remove grafting note"
git push origin port/metl/1.78.x/EMD-XXXXX

# For 1.75.x
git checkout port/metl/1.75.x/EMD-XXXXX
git rm grafting-note.md
git commit -m "EMD-XXXXX: Remove grafting note"
git push origin port/metl/1.75.x/EMD-XXXXX
```

## Verify PRs

1. Verify the 1.78.x PR:

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

2. Example PR URLs for verification:
   - 1.78.x PR: https://github.com/matillion/emerald/compare/dev/1.78.x...port/metl/1.78.x/EMD-XXXXX?expand=1
   - 1.75.x PR: https://github.com/matillion/emerald/compare/dev/1.75.x...port/metl/1.75.x/EMD-XXXXX?expand=1

**Note:** Ensure that both PRs contain only the necessary implementation changes and the emeraldLibsVersion update. The grafting note should not be included in the PRs.
