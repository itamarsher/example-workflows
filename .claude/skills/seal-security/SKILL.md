---
name: seal-security
description: Install Seal Security CLI in CI pipelines. Use when the user wants to add Seal Security, integrate security scanning, or fix vulnerable dependencies in GitHub Actions, GitLab CI, Docker, or other CI platforms.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
user-invocable: true
---

# Seal Security CLI Installation

This skill helps users integrate Seal Security's CLI into their CI pipelines to automatically fix vulnerable dependencies.

## Workflow

### Step 1: Gather Required Information

First, ask the user for their Seal Security token using the AskUserQuestion tool:

**Question to ask:**
- "What is your Seal Security token?" (This is required to authenticate with the Seal artifact server)

### Step 2: Generate Project ID

Generate a unique project ID automatically using this format:
```
<repository-name>-<random-8-chars>
```

Use the repository name from the current directory (extract from git remote or folder name) and append 8 random alphanumeric characters. You can generate this with:
```bash
basename $(git rev-parse --show-toplevel 2>/dev/null || pwd)-$(head -c 4 /dev/urandom | xxd -p)
```

### Step 3: Detect CI Platform

Search the repository for CI configuration files to determine which platform(s) are in use:

| Platform | Files to look for |
|----------|-------------------|
| GitHub Actions | `.github/workflows/*.yml`, `.github/workflows/*.yaml` |
| GitLab CI | `.gitlab-ci.yml` |
| Docker | `Dockerfile`, `*.dockerfile`, `docker/Dockerfile` |
| Other | If none found, ask the user which platform they use |

### Step 4: Install Seal Security CLI

Based on the detected platform, add the Seal CLI integration:

#### GitHub Actions

Add this step **immediately after** any package installation steps (like `npm install`, `pip install`, `go mod download`, etc.) and **before** build/test steps:

```yaml
      - name: 'Seal Security CLI'
        uses: 'seal-community/cli-action@latest'
        with:
          mode: fix
          fix_mode: all
          token: <TOKEN>
          project: <PROJECT_ID>
```

#### GitLab CI

Add to the `before_script` section or as a dedicated stage after dependency installation:

```yaml
seal-security:
  stage: .pre
  before_script:
    - curl -fsSL https://github.com/seal-community/cli/releases/download/${SEAL_CLI_VERSION}/seal-linux-amd64-${SEAL_CLI_VERSION}.zip -o seal.zip
    - unzip seal.zip
    - ./seal fix --mode all
  variables:
    SEAL_CLI_VERSION: latest
    SEAL_TOKEN: <TOKEN>
    SEAL_PROJECT: <PROJECT_ID>
```

Or add these lines to existing jobs after package installation:

```yaml
  before_script:
    - curl -fsSL https://github.com/seal-community/cli/releases/download/${SEAL_CLI_VERSION}/seal-linux-amd64-${SEAL_CLI_VERSION}.zip -o seal.zip
    - unzip seal.zip
    - ./seal fix --mode all
  variables:
    SEAL_CLI_VERSION: latest
    SEAL_TOKEN: <TOKEN>
    SEAL_PROJECT: <PROJECT_ID>
```

#### Docker

Add these lines **after** any `RUN npm install`, `RUN pip install`, or similar package installation commands:

```dockerfile
# Seal Security - Fix vulnerable dependencies
ENV SEAL_TOKEN=<TOKEN>
ENV SEAL_PROJECT=<PROJECT_ID>
ENV SEAL_CLI_VERSION=latest
RUN curl -fsSL https://github.com/seal-community/cli/releases/download/${SEAL_CLI_VERSION}/seal-linux-amd64-${SEAL_CLI_VERSION}.zip -o /tmp/seal.zip && \
    unzip /tmp/seal.zip -d /usr/local/bin && \
    seal fix --mode all && \
    rm -f /tmp/seal.zip /usr/local/bin/seal
```

#### Other CI Platforms

Provide a generic shell script approach:

```bash
export SEAL_TOKEN=<TOKEN>
export SEAL_PROJECT=<PROJECT_ID>
export SEAL_CLI_VERSION=latest
curl -fsSL https://github.com/seal-community/cli/releases/download/${SEAL_CLI_VERSION}/seal-linux-amd64-${SEAL_CLI_VERSION}.zip -o seal.zip
unzip seal.zip
./seal fix --mode all
```

### Step 5: Confirm Changes

After making the changes:
1. Show the user what files were modified
2. Explain where the Seal CLI step was added
3. Remind them that `fix_mode: all` applies all available fixes automatically

### Fix Mode Options

If the user asks about other options, explain:

- `fix_mode: all` - Apply every possible fix automatically (default, recommended)
- `fix_mode: local` - Use local `.seal.yaml` configuration to select specific packages
- `fix_mode: remote` - Use remote configuration from Seal Security dashboard

## Important Notes

- The Seal CLI must run **after** dependencies are installed but **before** any build or test steps
- The token authenticates with Seal's artifact server to download patched packages
- The project ID helps organize and track fixes across repositories
