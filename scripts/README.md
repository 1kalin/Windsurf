# Emerald Grafting Scripts

**Executable bash scripts** converted from Windsurf workflows for **immediate use**.

## 🚀 Available Scripts

### 1. `emerald-version-update.sh`
**Purpose**: Updates `emeraldLibsVersion` in Emerald project pom.xml  
**Usage**: `./scripts/emerald-version-update.sh`  
**Interactive**: Prompts for ticket number, version, and target version

**What it does**:
- Creates proper branch naming
- Updates pom.xml version
- Runs dependency management
- Commits and pushes changes
- Generates PR link

## 🎯 How to Use

### **Run Version Update Script**:
```bash
# From project root
./scripts/emerald-version-update.sh
```

**You'll be prompted for**:
- Ticket Number: `EMD-35672`
- New Version: `11.148.0-port-met-1.75.x-EMD-35672-SNAPSHOT`
- Target Version: `1.75.x`

### **Quick Example**:
```bash
cd /Users/kalinsmolichki/IdeaProjects/Windsurf
./scripts/emerald-version-update.sh

# Follow the prompts:
# Ticket Number: EMD-35672
# New Version: 11.148.0-port-met-1.75.x-EMD-35672-SNAPSHOT
# Target Version: 1.75.x
```

## 🔄 Auto-Populating Script Values

You can **auto-populate script values** to avoid interactive prompts using `echo` with pipes:

```bash
# Auto-populate for emerald-post-graft.sh
echo -e "EMD-35440\n785705b50f78cd789c8bc108ee5e99193d16aa2c\n1.78.x\nn\n" | ./emerald-post-graft.sh
```

**Format explanation**:
- Each value is separated by `\n` (newline)
- The final `\n` ensures the last prompt is answered
- For yes/no prompts, use `y` or `n` (lowercase)

**Recommended values order for each script**:

### emerald-post-graft.sh:
```
<TICKET_NUMBER>\n<SOURCE_COMMIT>\n<TARGET_VERSION>\n<IS_MERGE_COMMIT y/n>\n
```

### emerald-version-update.sh:
```
<TICKET_NUMBER>\n<NEW_VERSION>\n<TARGET_VERSION>\n
```

## ✅ Benefits Over Workflows

- **✅ Works immediately** - no Windsurf version dependencies
- **✅ Interactive prompts** - guides you through inputs 
- **✅ Error handling** - stops on any failure
- **✅ Full automation** - same features as workflows
- **✅ Easy to modify** - plain bash you can customize
- **✅ Auto-population** - supports non-interactive execution

## 🔧 Prerequisites

- **Git** configured with proper authentication
- **Maven** installed and configured
- **Python 3** available
- **Access** to both Emerald projects

---

**Note**: These scripts provide the **same automation** as the Windsurf workflows but run as **standard bash scripts** you can execute from terminal! 🚀
