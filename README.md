# Windsurf Repository

## 🚀 Developer Quick Start

```bash
# Clone this repository
git clone https://github.com/1kalin/Windsurf.git

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

**Common Issues & Solutions:**
- **Merge conflicts in Java files?** Use JDime for intelligent merging
- **Cherry-picking merge commits?** Use `git cherry-pick -m 1 <commit-hash>`
- **Vim opened during Git operations?** Set `export GIT_EDITOR=true` beforehand

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

- **Emerald Project Root**: `/Users/kalinsmolichki/IdeaProjects/EmeraldV5`
- **Emerald-API Project Root**: `/Users/kalinsmolichki/IdeaProjects/emerald-api-4`
- **Grafting Instructions**: `/Users/kalinsmolichki/IdeaProjects/Windsurf/grafting`

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
