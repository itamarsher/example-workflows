# Seal Security CLI Skill for Claude Code

This Claude Code skill helps you integrate [Seal Security's CLI](https://github.com/seal-community/cli) into your CI pipelines to automatically fix vulnerable dependencies.

## Installation

### Option 1: One-liner install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/seal-community/cli/main/.claude/skills/seal-security/install.sh | bash
```

### Option 2: Manual installation

Clone or download the skill to your personal skills directory:

```bash
mkdir -p ~/.claude/skills/seal-security
curl -fsSL https://raw.githubusercontent.com/seal-community/cli/main/.claude/skills/seal-security/SKILL.md -o ~/.claude/skills/seal-security/SKILL.md
```

### Option 3: Project-level installation

Add to a specific project by copying to `.claude/skills/`:

```bash
mkdir -p .claude/skills/seal-security
curl -fsSL https://raw.githubusercontent.com/seal-community/cli/main/.claude/skills/seal-security/SKILL.md -o .claude/skills/seal-security/SKILL.md
```

## Usage

1. Open Claude Code in your project
2. Type `/seal-security`
3. Provide your Seal Security token when prompted
4. Claude will automatically detect your CI platform and add the integration

## Supported CI Platforms

| Platform | Detection |
|----------|-----------|
| GitHub Actions | `.github/workflows/*.yml` |
| GitLab CI | `.gitlab-ci.yml` |
| Docker | `Dockerfile` |
| Other | Manual configuration |

## What it does

1. **Asks for your Seal token** - Required to authenticate with Seal's artifact server
2. **Generates a project ID** - Creates a unique identifier for your repository
3. **Detects your CI platform** - Scans for workflow files
4. **Adds Seal CLI integration** - Inserts the appropriate configuration

## Fix Modes

- `fix_mode: all` - Apply all available fixes (default)
- `fix_mode: local` - Use local `.seal.yaml` configuration
- `fix_mode: remote` - Use Seal Security dashboard configuration

## Requirements

- Claude Code CLI
- A Seal Security account and token

## Links

- [Seal Security](https://seal.security)
- [Seal CLI GitHub](https://github.com/seal-community/cli)
- [Seal CLI Action](https://github.com/seal-community/cli-action)
