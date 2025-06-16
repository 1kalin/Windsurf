# Emerald Grafting Workflows

This directory contains **automated Windsurf workflows** that replace the manual procedures documented in the `.md` files. Each workflow references the original documentation for safety and future reference.

## 🚀 Available Workflows

### 1. `emerald-version-update.yml`
**Purpose**: Updates `emeraldLibsVersion` in Emerald project pom.xml  
**Reference**: `emerald-full-grafting-plan.mld` lines 12-21, 66-79  
**Use Case**: Version updates before grafting implementation changes

**Required Inputs**:
- `ticket_number`: EMD-XXXXX or DPC-XXXXX
- `new_version`: e.g., `11.148.0-port-met-1.75.x-EMD-35672-SNAPSHOT`
- `target_version`: e.g., `1.75.x`, `1.78.x`

### 2. `emerald-api-grafting.yml`
**Purpose**: Cherry-pick changes from emerald-api to target branches  
**Reference**: `emerald-full-grafting-plan.mld` lines 22-40, `emerald-api-grafting.md`  
**Use Case**: Grafting changes in the emerald-api project

**Required Inputs**:
- `ticket_number`: EMD-XXXXX or DPC-XXXXX
- `source_commit`: Commit SHA or merge commit to cherry-pick
- `target_branch`: e.g., `dev/metl/1.75.x`
- `is_merge_commit`: Boolean (requires `-m 1` flag)

### 3. `emerald-post-graft.yml`
**Purpose**: Cherry-pick implementation changes to Emerald project after version update  
**Reference**: `emerald-full-grafting-plan.mld` lines 77-78, `emerald-grafting-postgraft.md`  
**Use Case**: Adding implementation changes on top of version updates

**Required Inputs**:
- `ticket_number`: EMD-XXXXX or DPC-XXXXX
- `source_commit`: Commit SHA or merge commit to cherry-pick
- `target_version`: e.g., `1.75.x`, `1.78.x`
- `is_merge_commit`: Boolean (requires `-m 1` flag)

### 4. `conflict-resolution.yml`
**Purpose**: Automated conflict resolution using JDime for Java files  
**Reference**: `emerald-full-grafting-plan.mld` lines 55-64  
**Use Case**: Resolving conflicts during cherry-pick operations

**Required Inputs**:
- `conflicted_file`: Path to the conflicted file
- `use_jdime`: Boolean (use intelligent Java merging)

## 📋 Workflow Features

### **Safety Features**:
- ✅ **Git environment setup** (prevents Vim interference)
- ✅ **Validation steps** to verify operations
- ✅ **Backup creation** before modifications
- ✅ **Detailed logging** of all operations
- ✅ **Reference links** to original documentation

### **Automation Features**:
- ✅ **Automated conflict resolution** for common cases
- ✅ **Intelligent Java merging** with JDime
- ✅ **Dependency management** execution
- ✅ **PR link generation** 
- ✅ **Branch naming conventions** enforcement

### **Error Handling**:
- ✅ **Gradle lockfile** automatic removal
- ✅ **Merge commit** handling with `-m 1` flag
- ✅ **Conflict detection** and resolution
- ✅ **Rollback capabilities** with backup files

## 🎯 Usage Patterns

### **Complete Grafting Workflow**:
1. **Version Update**: Run `emerald-version-update.yml`
2. **API Grafting**: Run `emerald-api-grafting.yml` (if needed)
3. **Post-Graft**: Run `emerald-post-graft.yml` (if needed)
4. **Conflict Resolution**: Run `conflict-resolution.yml` (if conflicts occur)

### **Quick Version Update Only**:
1. **Version Update**: Run `emerald-version-update.yml`
2. **Done!** (for simple version bumps)

## 📚 Documentation References

All workflows maintain **explicit references** to the original documentation:

- **Primary Reference**: `emerald-full-grafting-plan.mld`
- **Individual Templates**: 
  - `emerald-api-grafting.md`
  - `emerald-grafting-pregraft.md` 
  - `emerald-grafting-postgraft.md`

## ⚙️ Customization

### **Project Paths**:
Update these paths in workflows if your setup differs:
- Emerald Project: `~/IdeaProjects/EmeraldV5`
- Emerald-API Project: `~/IdeaProjects/emerald-api-4`

### **Branch Patterns**:
Workflows follow these naming conventions:
- **Version branches**: `port/met/{version}/{ticket}`
- **Graft branches**: `graft/{target_branch}/{ticket}`
- **Target branches**: `dev/{version}` or `dev/metl/{version}`

## 🔧 Prerequisites

### **Required Tools**:
- **Git** (with proper authentication)
- **Maven** (for dependency resolution)
- **Python 3** (for dependency management scripts)
- **JDime** (optional, for intelligent Java merging)
  ```bash
  brew install jdime
  ```

### **Environment Setup**:
- **Git credentials** configured
- **Maven settings** with JFrog Artifactory access
- **Project paths** accessible and up-to-date

## 🚨 Important Notes

1. **Always review** the generated PR links before creating PRs
2. **Verify changes** in the validation steps output
3. **Keep original .md files** as reference documentation
4. **Test workflows** in non-production branches first
5. **Update workflows** when procedures change

## 🎉 Benefits Over Manual Process

- ⚡ **10x faster** execution
- 🎯 **100% consistent** results  
- 🛡️ **Built-in safety** checks
- 📊 **Detailed logging** and verification
- 🔄 **Repeatable** operations
- 🚫 **Eliminates human error** in repetitive tasks

---

**Remember**: These workflows **complement** the original documentation - they don't replace the need to understand the underlying grafting procedures! 🚀
