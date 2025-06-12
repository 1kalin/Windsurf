# Emerald Pre-Graft Template (emeraldLibsVersion Update)

This template is for the first phase of grafting in Emerald projects - updating the emeraldLibsVersion in pom.xml.

## Pre-Graft Steps for 1.78.x

1. Create a branch for the 1.78.x graft:
```bash
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5
git fetch --all
git checkout dev/1.78.x
git pull
git checkout -b port/met/1.78.x/EMD-XXXXX
```

2. Update the emeraldLibsVersion in pom.xml:
```bash
sed -i.bak 's/<emeraldLibsVersion>[^<]*<\/emeraldLibsVersion>/<emeraldLibsVersion>NEW-VERSION-HERE<\/emeraldLibsVersion>/' pom.xml
```
Replace `NEW-VERSION-HERE` with the appropriate snapshot version (e.g., `13.14.0-port-met-1.78.x-EMD-XXXXX-SNAPSHOT`)

3. Commit and push the emeraldLibsVersion update:
```bash
git add pom.xml
git commit -m "EMD-XXXXX: Update emeraldLibsVersion to NEW-VERSION-HERE"
git push -u origin port/met/1.78.x/EMD-XXXXX
```

4. Create a placeholder commit note:
```bash
echo "# Grafting of EMD-XXXXX - Description" > grafting-note.md
git add grafting-note.md
git commit -m "EMD-XXXXX: Graft EMD-XXXXX - Description"
git push origin port/met/1.78.x/EMD-XXXXX
```

## Pre-Graft Steps for 1.75.x

1. Create a branch for the 1.75.x graft:
```bash
export GIT_EDITOR=true
cd ~/IdeaProjects/EmeraldV5
git fetch --all
git checkout dev/1.75.x
git pull
git checkout -b port/met/1.75.x/EMD-XXXXX
```

2. Update the emeraldLibsVersion in pom.xml:
```bash
sed -i.bak 's/<emeraldLibsVersion>[^<]*<\/emeraldLibsVersion>/<emeraldLibsVersion>NEW-VERSION-HERE<\/emeraldLibsVersion>/' pom.xml
```
Replace `NEW-VERSION-HERE` with the appropriate snapshot version (e.g., `11.148.0-port-met-1.75.x-EMD-XXXXX-SNAPSHOT`)

3. Commit and push the emeraldLibsVersion update:
```bash
git add pom.xml
git commit -m "EMD-XXXXX: Update emeraldLibsVersion to NEW-VERSION-HERE"
git push -u origin port/met/1.75.x/EMD-XXXXX
```

4. Create a placeholder commit note:
```bash
echo "# Grafting of EMD-XXXXX - Description" > grafting-note.md
git add grafting-note.md
git commit -m "EMD-XXXXX: Graft EMD-XXXXX - Description"
git push origin port/met/1.75.x/EMD-XXXXX
```

## Create PRs

1. Create PR for 1.78.x branch:
https://github.com/matillion/emerald/compare/dev/1.78.x...port/met/1.78.x/EMD-XXXXX?expand=1

2. Create PR for 1.75.x branch:
https://github.com/matillion/emerald/compare/dev/1.75.x...port/met/1.75.x/EMD-XXXXX?expand=1

**Note:** After completing these pre-graft steps, proceed to the post-graft steps in `emerald-grafting-nocp-postgraft.md` if implementation changes need to be cherry-picked.
