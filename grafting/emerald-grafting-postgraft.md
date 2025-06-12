# Emerald Post-Graft Template (Implementation Changes)

This template is for the second phase of grafting in Emerald projects - cherry-picking implementation changes after emeraldLibsVersion has been updated.

## Post-Graft Steps for 1.78.x

1. Checkout the pre-grafted branch:
```bash
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5
git checkout port/met/1.78.x/EMD-XXXXX
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
git push origin port/met/1.78.x/EMD-XXXXX
```

## Post-Graft Steps for 1.75.x

1. Checkout the pre-grafted branch:
```bash
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5
git checkout port/met/1.75.x/EMD-XXXXX
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
git push origin port/met/1.75.x/EMD-XXXXX
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
git checkout port/met/1.78.x/EMD-XXXXX
git rm grafting-note.md
git commit -m "EMD-XXXXX: Remove grafting note"
git push origin port/met/1.78.x/EMD-XXXXX

# For 1.75.x
git checkout port/met/1.75.x/EMD-XXXXX
git rm grafting-note.md
git commit -m "EMD-XXXXX: Remove grafting note"
git push origin port/met/1.75.x/EMD-XXXXX
```

## Verify PRs

1. Verify the 1.78.x PR:
https://github.com/matillion/emerald/compare/dev/1.78.x...port/met/1.78.x/EMD-XXXXX?expand=1

2. Verify the 1.75.x PR:
https://github.com/matillion/emerald/compare/dev/1.75.x...port/met/1.75.x/EMD-XXXXX?expand=1

**Note:** Ensure that both PRs contain only the necessary implementation changes and the emeraldLibsVersion update. The grafting note should not be included in the PRs.
