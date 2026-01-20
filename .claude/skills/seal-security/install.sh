#!/bin/bash
# Seal Security CLI Skill Installer for Claude Code
# Usage: curl -fsSL https://raw.githubusercontent.com/seal-community/cli/main/.claude/skills/seal-security/install.sh | bash

set -e

SKILL_NAME="seal-security"
SKILL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"
REPO_URL="https://raw.githubusercontent.com/seal-community/cli/main/.claude/skills/seal-security"

echo "Installing Seal Security skill for Claude Code..."

# Create skills directory if it doesn't exist
mkdir -p "${HOME}/.claude/skills"

# Create skill directory
mkdir -p "${SKILL_DIR}"

# Download SKILL.md
echo "Downloading skill files..."
curl -fsSL "${REPO_URL}/SKILL.md" -o "${SKILL_DIR}/SKILL.md"

echo ""
echo "Seal Security skill installed successfully!"
echo ""
echo "Location: ${SKILL_DIR}"
echo ""
echo "Usage: Type /seal-security in Claude Code to install Seal CLI in your CI pipelines."
echo ""
