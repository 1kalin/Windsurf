#!/bin/bash
# Intelligent Conflict Resolution Script
# Reference: emerald-full-grafting-plan.mld lines 55-64

set -e  # Exit on any error

# Function to prompt for input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    read -p "$prompt: " $var_name
}

# Function to prompt for yes/no
prompt_yn() {
    local prompt="$1"
    local var_name="$2"
    while true; do
        read -p "$prompt (y/n): " yn
        case $yn in
            [Yy]* ) eval $var_name=true; break;;
            [Nn]* ) eval $var_name=false; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

echo "🚀 INTELLIGENT CONFLICT RESOLUTION SCRIPT"
echo "========================================="

# Get inputs
prompt_input "Conflicted file (path to .java or gradle.lockfile)" CONFLICTED_FILE
prompt_yn "Use JDime for Java merging?" USE_JDIME

# Setup Git Environment
echo "⚡ Setting up Git environment..."
export GIT_EDITOR=true

# Analyze Conflict
echo "⚡ Analyzing conflict in $CONFLICTED_FILE ..."
if [[ "$CONFLICTED_FILE" == *.java ]]; then
    echo "File type: Java (eligible for JDime)"
elif [[ "$CONFLICTED_FILE" == *gradle.lockfile ]]; then
    echo "File type: Gradle lockfile (should be removed)"
else
    echo "File type: Other (standard resolution)"
fi

grep -n "<<<<<<< \|======= \|>>>>>>> " "$CONFLICTED_FILE" || echo "No standard conflict markers found"

# Resolve Gradle Lockfile Conflicts
if [[ "$CONFLICTED_FILE" == *gradle.lockfile ]]; then
    echo "Removing gradle.lockfile conflict: $CONFLICTED_FILE"
    git rm "$CONFLICTED_FILE"
    echo "✅ Gradle lockfile removed"
    exit 0
fi

# Intelligent Java Merge with JDime
if [[ "$CONFLICTED_FILE" == *.java ]] && $USE_JDIME; then
    if command -v jdime &> /dev/null; then
        echo "Using JDime for intelligent Java merging..."
        BASE_FILE="$CONFLICTED_FILE.base"
        LEFT_FILE="$CONFLICTED_FILE.left"
        RIGHT_FILE="$CONFLICTED_FILE.right"
        MERGED_FILE="$CONFLICTED_FILE.merged"
        git show :1:"$CONFLICTED_FILE" > "$BASE_FILE" 2>/dev/null || echo "No base version"
        git show :2:"$CONFLICTED_FILE" > "$LEFT_FILE" 2>/dev/null || echo "No left version"
        git show :3:"$CONFLICTED_FILE" > "$RIGHT_FILE" 2>/dev/null || echo "No right version"
        if jdime --mode structured --output "$MERGED_FILE" "$LEFT_FILE" "$BASE_FILE" "$RIGHT_FILE"; then
            echo "✅ JDime merge successful"
            cp "$MERGED_FILE" "$CONFLICTED_FILE"
            rm -f "$BASE_FILE" "$LEFT_FILE" "$RIGHT_FILE" "$MERGED_FILE"
            git add "$CONFLICTED_FILE"
            echo "✅ Java file resolved with JDime"
            exit 0
        else
            echo "❌ JDime merge failed, falling back to manual resolution"
            rm -f "$BASE_FILE" "$LEFT_FILE" "$RIGHT_FILE" "$MERGED_FILE"
        fi
    else
        echo "❌ JDime not found. Install with: brew install jdime"
    fi
fi

# Standard Conflict Resolution
if git status --porcelain | grep -q "^UU.*$CONFLICTED_FILE"; then
    echo "Resolving by keeping current branch version (--ours)"
    git checkout --ours "$CONFLICTED_FILE"
    git add "$CONFLICTED_FILE"
    echo "✅ Resolved using current branch version"
else
    echo "✅ File already resolved or not in conflict"
fi

# Verify Resolution
echo "================================"
echo "RESOLUTION VERIFICATION:"
echo "================================"
if grep -q "<<<<<<< \|======= \|>>>>>>> " "$CONFLICTED_FILE"; then
    echo "❌ Conflict markers still present in file"
    grep -n "<<<<<<< \|======= \|>>>>>>> " "$CONFLICTED_FILE"
    exit 1
else
    echo "✅ No conflict markers found"
fi

git status --porcelain | grep "$CONFLICTED_FILE" || echo "File not in Git status (may be resolved)"
echo "================================"
echo "CONFLICT RESOLUTION COMPLETED"
echo "================================"
