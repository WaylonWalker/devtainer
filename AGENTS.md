# Development Environment Instructions for AI Agents

## Project Overview

This is `devtainer` - a personal development Docker container environment providing pre-configured development tools, editors, and configurations. This is a **containerization project**, not a Python application.

**Identify this project by:** `justfile`, `version` file, `docker/` directory, `mise/.config/mise/config.toml`

## Build/Test Commands

**Always use `just` - this is the primary task runner:**

```bash
# Build commands
just build                    # Build all Docker variants
just build-latest            # Build main Ubuntu image
just build-alpine            # Build Alpine variant
just build-slim              # Build minimal variant
just build-arch              # Build Arch Linux variant

# Test commands
just testnvim                # Test Neovim config in isolated environment

# Deployment (requires authentication)
just deploy                  # Deploy all variants
just latest                  # Build + deploy latest
just alpine                  # Build + deploy Alpine
just slim                    # Build + deploy slim

# Release management
just create-tag             # Create Git tag from version file
just delete-tag             # Delete Git tag
just create-release          # Create GitHub release with notes
just delete-release          # Delete GitHub release
just preview-release         # Preview release notes

# Utilities
just update-installers       # Regenerate tool installer scripts
just distrobox-assemble      # Create distrobox from config
just login                   # Authenticate to Docker registry

# Keybinding documentation
just extract-keymaps        # Extract keybindings from all environments
just gen-keybinding-pages  # Generate markdown pages from keybindings
just update-keybindings    # Full refresh: extract and generate pages

# VHS recording
just list-tapes            # List all available VHS tapes
just record-tape TAPE      # Record a specific tape (e.g., just record-tape lf-intro)
just record-tapes          # Record all VHS tapes in static/tapes/

# List all commands
just --choose               # Interactive command selector
```

**Python scripts use `uv` with inline dependencies:**
```bash
./scripts/get_release_notes.py VERSION    # Generate release notes
./scripts/repostat --help                  # Repository statistics
```

## Environment Management

- **Container runtime:** `podman` (default, set in justfile)
- **Registry:** `ghcr.io/waylonwalker/devtainer` (Docker Hub mirrors remain optional)
- **Version:** Stored in `version` file (semantic versioning)
- **Tool management:** `mise` - install via `mise install`

## Code Style Guidelines

### Python Scripts (Limited Use)
- Use `uv run --script` format with inline dependencies
- Shebang: `#!/usr/bin/env -S uv run --quiet --script`
- Target Python 3.10+, use `collections.abc` type hints
- Error handling: write to `sys.stderr`, exit with proper codes

```python
#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["typer", "rich"]
# ///

from __future__ import annotations
import sys

def main():
    if len(sys.argv) != 2:
        print("Usage: script.py ARG", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
```

### Dockerfiles
- **Base images:** Ubuntu 24.04 (main), Alpine (minimal)
- **Package management:** Use `apt-get` with `--no-install-recommends`
- **Cleanup:** Always run `rm -rf /var/lib/apt/lists/* && apt-get clean`
- **Layer optimization:** Group related operations in single RUN commands
- **Environment:** Set PATH variables for tool locations

### Shell Scripts
- **Shebang:** `#!/usr/bin/env bash`
- **Error handling:** `set -euxo pipefail` at start
- **Quoting:** Always quote variables: `"${VAR}"`
- **Command substitution:** Use `$()` not backticks

### Justfile Recipes
- Use `#!/usr/bin/env bash` with `set -euxo pipefail`
- Access variables via `{{ variable }}` syntax
- Export variables at top of justfile for global access

## Project Structure

```
devtainer/
├── justfile                    # Primary task runner (REQUIRED)
├── version                     # Semantic version
├── docker/                     # Dockerfile variants
│   ├── Dockerfile             # Main Ubuntu image
│   ├── Dockerfile.alpine      # Alpine variant
│   ├── Dockerfile.slim        # Minimal variant
│   ├── Dockerfile.arch-*      # Arch Linux variants
│   └── *.containerfile        # Additional container definitions
├── pages/                      # Documentation and blog posts
│   ├── tools/                  # Tool-specific documentation
│   ├── guides/                 # How-to guides
│   └── vhs/                    # Video demonstrations
├── scripts/                    # Utility Python scripts (uv-based)
├── mise/.config/mise/          # Development tool configuration
├── installer/                  # Generated tool installers (auto-generated)
├── nvim/.config/nvim/          # Neovim configuration
├── distrobox/                  # Distrobox configuration
└── .github/workflows/          # CI/CD (builds slim variant)
```

## Development Workflow

1. **Make changes** to Dockerfile or configuration
2. **Test locally:** `just build-latest`
3. **Verify container:** `docker run --rm ghcr.io/waylonwalker/devtainer:latest`
4. **Update version** in `version` file if releasing
5. **Create tag:** `just create-tag`
6. **Build and deploy:** `just latest`
7. **Create release:** `just create-release`

**When adding new tools:**
1. Update `mise/.config/mise/config.toml` for mise-managed tools
2. Update `justfile` `update-installers` recipe for installer-based tools
3. Run `just update-installers` to regenerate scripts
4. Test with `just build-latest`

## Agent Guidelines

1. **Always use `just` commands** - never bare docker/podman
2. **Never run deployment commands** unless explicitly asked
3. **Check version file** before any release operations
4. **Use mise for tools** - don't install development tools globally
5. **Follow Dockerfile best practices** - optimize layers, clean up
6. **Maintain installer scripts** when adding tools
7. **Test containers locally** before suggesting deployment

## Troubleshooting

- **`just` not found:** Install via `cargo install just` or mise
- **Build fails:** Check base image availability, package names
- **Permission denied:** Verify Docker/Podman permissions and `just login`

## Verification Commands

```bash
just --choose               # List all available commands
cat version                 # Check current version
just testnvim               # Test Neovim configuration
mise list                   # Check installed tools
```

## Documentation Style Guidelines

### Writing Technical Documentation

**Structure:**
1. **Frontmatter** (for markdown files):
    - `date: 'YYYY-MM-DD'` (use single quotes)
    - `description: "Brief summary of the content"`
    - `title: "Clear Descriptive Title"`
    - `published: true` (required for posts to be included in site)
    - `tags: ['slash']` (for slash pages like /about, /uses, etc.)

2. **Content Format:**
    - **NO H1 tags** - The title frontmatter generates the h1 automatically
    - Start with introductory paragraph, not a heading
    - Use h2/h3 for sections
    - Keep paragraphs focused (3-5 sentences max)
    - Use bullet points for lists
    - Include code examples for configuration

3. **Code Examples:**
   - Use fenced code blocks with language tags
   - Keep examples minimal and focused
   - Test commands before documenting

**Markdown Formatting:**

```bash
mdfmt() {
  uvx \
    --with "mdformat-ruff" \
    --with "mdformat-beautysh" \
    --with "mdformat-web" \
    --with "mdformat-config" \
    --with "mdformat-gfm" \
    --with "mdformat-front-matters" \
    mdformat \
    --wrap 80 \
    --end-of-line lf \
    --codeformatters python \
    --codeformatters bash \
    "$@"
}
mdfmt path/to/file.md
```

### Wikilinks and Embeds

The site uses markata-go which supports wikilink-style links and embeds:

**Internal Links (Preferred):**
```markdown
[[pagename]]
```

**Internal Links with Custom Text:**
```markdown
[[pagename|Display Text]]
```

*Use custom text sparingly - the page title from frontmatter is already displayed automatically and updated when the title changes.*

**Embeds (for See Also sections):**
```markdown
![[ pagename ]]
```

**External Link Embeds:**
```markdown
![embed](https://example.com/)
```

**Example See Also section:**
```markdown
## See Also

![[ tmux ]]

![[ zsh ]]

![embed](https://zellij.dev/documentation/)
```

**Note:** Always use wikilinks `[[page]]` for internal links, not traditional markdown links `[page](page.md)`.

### Documentation Types

**README:**
- Project overview and quick start
- Installation instructions
- Key features and usage
- **Example:** Main project README

**CHANGELOG:**
- Version history with dates
- Bullet points of changes
- Breaking changes clearly marked
- **Example:** CHANGELOG.md in root

**Configuration Docs:**
- Tool-specific setup instructions
- Default values and options
- Example configurations
- **Example:** Tool configuration guides

**How-To Guides:**
- Step-by-step instructions
- Prerequisites listed upfront
- Expected outcomes
- **Example:** Adding new tools to devtainer

**Inline Comments:**
- Explain complex configuration
- Document workarounds
- Reference external resources
- **Example:** Comments in justfile recipes

### Creating VHS Recordings

Use [VHS](https://github.com/charmbracelet/vhs) to create terminal videos for documentation. Prefer video formats (mp4/webm) over GIF for play/pause controls and scrubbing.

**Tape file structure:**
```tape
Output vhs/demo.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1920
Set Height 1080

Hide
Type '. ~/.zshrc' Sleep 500ms Enter
Type 'clear' Sleep 500ms Enter
Show

Type "echo 'Welcome to devtainer'" Enter
Sleep 1s
Type "lazydocker" Enter
Sleep 2s
```

**Recording workflow:**
1. Create `.tape` file in `vhs/` directory
2. Run `vhs < vhs/demo.tape` to generate video
3. Reference in markdown: `![description](vhs/demo.mp4)`
   - markata-go converts image syntax with .mp4 to video elements automatically

**Best practices:**
- Use `.mp4` or `.webm` for play/pause scrubber controls
- Keep recordings under 30 seconds when possible
- Use `Hide`/`Show` to skip setup commands
- Set consistent dimensions (1920x1080 or 1200x800)
- Use `Sleep` commands to let viewers follow along
- Store source `.tape` files alongside outputs for reproducibility
- Use `Set TypingSpeed` to control pacing without excessive Sleep commands

**Recording Categories:**

1. **Tool Introductions (10-15s)** - Quick demos showing one tool's killer feature
2. **Workflow Demos (20-30s)** - Multi-tool workflows showing how things connect
3. **Setup Guides (30-45s)** - Step-by-step setup/recovery processes
4. **Configuration Highlights (15-20s)** - Custom config features in action
5. **Comparisons** - Before/after, IDE vs terminal workflows

**Organization:**
```
vhs/
├── tools/          # Individual tool demos
├── workflows/      # Multi-tool workflows
├── guides/         # Setup and tutorial videos
└── assets/         # Reusable snippets (logos, prompts)
```

**Sandbox Environment (Safety First):**

When recording demos of file managers (lf, yazi), git operations, or any tool that modifies files, use an isolated sandbox to prevent accidental changes to real dotfiles or important data.

**Option 1: Dedicated Demo Directory (Recommended)**

Create a throwaway directory structure:
```bash
# Create sandbox
mkdir -p vhs/sandbox/project-{1,2,3}/{src,docs}
cd vhs/sandbox

# In your tape file:
Type "cd ~/devtainer/vhs/sandbox" Enter
Type "lf" Enter
```

**Option 2: /tmp Directory (Auto-cleanup)**
```bash
# In your tape file - everything vanishes on reboot
Type "cd $(mktemp -d)" Enter
Type "mkdir -p project/{src,docs,tests}" Enter
Type "touch project/README.md project/src/main.py" Enter
Type "lf" Enter
```

**Option 3: Podman Container (Complete Isolation)**
```bash
# For demos that might really mess things up
podman run --rm -it -v $(pwd)/vhs/sandbox:/demo:z alpine:latest /bin/sh

# In tape - work in /demo which is mounted from host
Type "cd /demo" Enter
Type "lf" Enter
```

**Best Practices for Safe Recording:**
- Always start demos in the sandbox directory
- Create sample files/directories in the tape setup
- Use `Hide` to setup the sandbox without showing it
- Never record in ~, ~/git, ~/work, or important directories
- Clean up sandbox after recording: `rm -rf vhs/sandbox/*`

**Example Safe Tape:**
```tape
Output static/tapes/lf-intro.mp4

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd $(mktemp -d)' Enter
Type 'mkdir -p project/{src,docs} && touch project/README.md project/src/main.py' Enter
Type 'clear' Sleep 500ms Enter
Show

Type "lf" Sleep 1s Enter
# ... demo navigation ...
Type "q" Enter
```
