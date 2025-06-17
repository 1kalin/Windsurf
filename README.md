# Zero-Gravity Repository

<img width="619" alt="image" src="https://github.com/user-attachments/assets/117d21d9-1029-4943-8954-fbe478026039" />


## 🚀 Developer Quick Start

```bash
# Clone this repository
git clone https://github.com/1kalin/zero-gravity.git

# Set up Git editor to avoid Vim prompts
export GIT_EDITOR=true

# Common grafting scenarios:

# 1. Emerald-API grafting
# Follow instructions in:
cat /grafting/emerald-api-grafting.md

# 2. Emerald version update (pre-graft)
# Follow instructions in:
cat /grafting/emerald-grafting-pregraft.md

# 3. Emerald implementation changes (post-graft)
# Follow instructions in:
cat /grafting/emerald-grafting-postgraft.md
```

## 🛠️ Automated Solutions

This repository offers **two automation approaches** for grafting operations:

### 1. Shell Scripts (`/scripts`)

#### Available Scripts

##### `emerald-version-update.sh`
**Purpose**: Updates `emeraldLibsVersion` in Emerald project pom.xml  
**Usage**: `./scripts/emerald-version-update.sh`  
**Interactive**: Prompts for ticket number, version, and target version

**What it does**:
- Creates proper branch naming
- Updates pom.xml version
- Runs dependency management
- Commits and pushes changes
- Generates PR link

##### `emerald-post-graft.sh`
**Purpose**: Cherry-picks implementation changes for postgrafting  
**Usage**: `./scripts/emerald-post-graft.sh`  
**Interactive**: Prompts for ticket number, source commit, target version, and merge commit status

##### `emerald-api-grafting.sh`
**Purpose**: Sets up grafting branches for emerald-api  
**Usage**: `./scripts/emerald-api-grafting.sh`  
**Interactive**: Prompts for ticket number and target versions

#### How to Use

**Run Version Update Script**:
```bash
# From project root
./scripts/emerald-version-update.sh
```

**You'll be prompted for**:
- Ticket Number: `EMD-35672`
- New Version: `11.148.0-port-metl-1.75.x-EMD-35672-SNAPSHOT`
- Target Version: `1.75.x`

#### Non-Interactive Execution

All scripts support non-interactive execution using echo with pipes:

```bash
# For emerald-version-update.sh
echo -e "TICKET_NUMBER\nNEW_VERSION\nTARGET_VERSION\n" | ./scripts/emerald-version-update.sh

# For emerald-post-graft.sh
echo -e "TICKET_NUMBER\nSOURCE_COMMIT\nTARGET_VERSION\nIS_MERGE_COMMIT\n" | ./scripts/emerald-post-graft.sh

# For emerald-api-grafting.sh
echo -e "TICKET_NUMBER\nTARGET_VERSION\n" | ./scripts/emerald-api-grafting.sh
```

### 2. Zero-Gravity Workflows (`/emerald-grafting/workflows`)
GUIded workflows that integrate with zero-gravity:
```bash
# Access workflows via zero-gravity interface or directly from:
~/IdeaProjects/zero-gravity/emerald-grafting/workflows/
```
See `/emerald-grafting/workflows/README.md` for available workflows and their usage.

> **Note:** The workflows exist in two locations for specific purposes:
> - `/emerald-grafting/workflows/` - **User-facing directory** with documentation and reference materials. This is where humans should look for workflow information, examples, and guidance.
> - `/.windsurf/workflows/` - **System integration directory** that zero-gravity application reads from directly. Contains the same YML files but positioned where the system expects to find them.
>
> This dual structure separates user documentation from system configuration while maintaining the same underlying workflow definitions.

**Common Issues & Solutions:**
- **Merge conflicts in Java files?** Use JDime for intelligent merging
- **Cherry-picking merge commits?** Use `git cherry-pick -m 1 <commit-hash>`
- **Vim opened during Git operations?** Set `export GIT_EDITOR=true` beforehand
- **Need automation?** Use `/scripts` directory for bash scripts or `/emerald-grafting/workflows` for GUI workflows

**Need the full reference?** See `/grafting/emerald-full-grafting-plan.mld`

---

This repository contains comprehensive documentation, templates, and instructions for grafting DPC/EMD tickets across multiple version branches in Matillion's emerald-api and emerald repositories.

## Repository Structure

### Comprehensive Reference
- `/grafting/emerald-full-grafting-plan.mld` - **Main reference document** containing detailed information on:
  - Git operations and best practices
  - Emerald libraries version updates
  - Grafting procedures for both emerald and emerald-api projects
  - Conflict resolution strategies
  - Project paths and file locations
  - Detailed step-by-step instructions for pre-graft and post-graft operations

### Grafting Templates
- `/grafting/emerald-api-grafting.md` - Instructions for grafting to emerald-api repository (1.78.x and 1.75.x)
- `/grafting/emerald-grafting-pregraft.md` - Pre-graft phase instructions for emerald repository (version updates)
- `/grafting/emerald-grafting-postgraft.md` - Post-graft phase instructions for emerald repository (implementation changes)

### Global Rules
- `/global_rules.md` - Contains general coding guidelines, project references, and points to the comprehensive grafting reference

## Project Paths

> ⚠️ **IMPORTANT: YOU MUST UPDATE THESE PATHS** to match your local environment!

- **Emerald Project Root**: `/Users/kalinsmolichki/IdeaProjects/EmeraldV5` ← **CHANGE THIS**
- **Emerald-API Project Root**: `/Users/kalinsmolichki/IdeaProjects/emerald-api-4` ← **CHANGE THIS**
- **Grafting Instructions**: `/Users/kalinsmolichki/IdeaProjects/zero-gravity/grafting` ← **CHANGE THIS**

### Customizing Your Setup

1. **Update Project Paths**:
   - Edit the paths above in this README
   - Edit the same paths in `/global_rules.md` under the "Project Paths" section
   - Edit the paths in `/grafting/emerald-full-grafting-plan.mld`

2. **Configure Global Rules for Zero-Gravity/Codeium**:
   - Copy the contents of `/global_rules.md` to your Zero-Gravity memory
   - In Zero-Gravity: Click the "⚙️" (Settings) icon in the bottom left corner
   - Select "Memories" from the menu
   - Click "Create new memory"
   - Title it "user_global"
   - Paste the contents of `/global_rules.md`
   - Click "Create"
   - **IMPORTANT**: Make sure to update all project paths in the pasted content to match your environment

## Getting Started

1. **Setup Environment**:
   - Ensure Git is properly configured
   - Set `export GIT_EDITOR=true` to prevent Vim from opening during Git operations

2. **Choose the Appropriate Template**:
   - For emerald-api grafting: Use `/grafting/emerald-api-grafting.md`
   - For emerald grafting: 
     - Pre-graft phase (version updates): Use `/grafting/emerald-grafting-pregraft.md`
     - Post-graft phase (implementation changes): Use `/grafting/emerald-grafting-postgraft.md`

3. **Follow the Comprehensive Reference**:
   - Refer to `/grafting/emerald-full-grafting-plan.mld` for detailed step-by-step instructions

## Important Notes

- **Never push grafting notes** to PR branches to maintain clean PRs
- When cherry-picking merge commits, use `git cherry-pick -m 1 <commit-hash>`
- For conflict resolution in Java files, consider using JDime for intelligent merging
- When resolving conflicts, ignore `gradle.lockfile` as they are auto-generated
- Always create separate branches for each supported version (e.g., 1.75.x, 1.78.x)

## PR Creation

After completing the grafting process, create PRs using the following format:
```
https://github.com/matillion/emerald/compare/dev/1.75.x...port/met/1.75.x/EMD-XXXXX?expand=1
```

Replace `1.75.x` with the appropriate version branch and `EMD-XXXXX` with your ticket number.
