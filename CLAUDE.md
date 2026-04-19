# Dotfiles

Cross-platform dotfiles for macOS, Fedora workstation, and Linux (OrbStack Ubuntu VMs). Managed with GNU Stow, installed via Homebrew (both platforms).

## Architecture

```
dotfiles/
├── bootstrap.sh              # orchestrator: detects OS, sources scripts/* in order
├── Brewfile                   # shared brew packages, casks gated with `if OS.mac?`
├── scripts/                   # numbered install steps (increments of 5 for easy insertion)
│   ├── 00-prerequisites.sh    # system packages (apt/dnf/xcode)
│   ├── 05-shell.sh            # set zsh as default, install zsh plugins
│   ├── 10-homebrew.sh         # install/configure brew, run brew bundle
│   ├── 15-rust.sh             # rust stable toolchain via rustup
│   ├── 20-stow.sh             # symlink dotfile packages to $HOME
│   ├── 25-tmux.sh             # tmux plugin manager (TPM)
│   ├── 30-claude.sh           # claude code CLI
│   ├── 35-git.sh              # global gitignore
│   ├── 40-macos-defaults.sh   # macOS-only system defaults
│   ├── 45-gcloud.sh           # gcloud CLI on Linux (mac uses brew cask)
│   ├── 50-ghostty.sh          # ghostty on Fedora via COPR (mac uses brew cask, skipped on debian)
│   └── 55-slack.sh            # slack on Fedora via flathub
├── ghostty/                   # macOS only (terminal emulator)
├── git/                       # .gitignore-global
├── nvim/                      # neovim config (init.lua)
├── starship/                  # prompt config
├── tmux/                      # tmux config
└── zsh/                       # .zshrc
```

## Key Conventions

### Bootstrap Scripts (`scripts/`)
- Each script is sourced (not executed) by `bootstrap.sh` — they share `$OS`, `$DISTRO`, `$DOTFILES_DIR`, and helper functions (`info`, `warn`, `error`)
- Numbered in increments of 5 (00, 05, 10...) so new scripts can be inserted without renaming
- Every install step must be idempotent — check before installing (e.g. `if [[ ! -x ... ]]`)
- `$OS` is `Darwin` or `Linux`; `$DISTRO` is `macos`, `debian`, or `fedora`
- Use `NONINTERACTIVE=1` for Homebrew installs (OrbStack VMs have no sudo password)
- Check binary paths directly instead of `command -v` when the binary may not be in PATH during bootstrap (e.g. brew, claude)

### Stow Packages
- Each top-level directory (zsh/, starship/, nvim/, etc.) is a stow package
- Internal structure mirrors `$HOME` (e.g. `starship/.config/starship.toml` → `~/.config/starship.toml`)
- Platform-gated packages (ghostty: macOS + Fedora only) are conditionally appended in `20-stow.sh`
- Adding a new dotfile: create `<name>/<path-relative-to-home>` and add `<name>` to the `STOW_PACKAGES` array in `20-stow.sh`

### Brewfile
- `brew "name"` for cross-platform formulae
- `cask "name" if OS.mac?` for macOS-only casks
- Packages not available via Linuxbrew go in the relevant `scripts/` file with apt/dnf fallback (e.g. gcloud in `00-prerequisites.sh`)

### Starship Prompt
- OS indicator uses env vars set in `.zshrc`: `STARSHIP_OSX` (bold red) or `STARSHIP_LINUX` (bold purple, value is the distro ID from `/etc/os-release`: `ubuntu`, `fedora`, etc.)
- Uses `$env_var` module, not the built-in `$os` module (which doesn't work reliably)

### Auto-Update
- `.zshrc` fetches origin/main on shell startup and runs `bootstrap.sh` if behind
- Uses `git pull --ff-only` to avoid merge conflicts during auto-update

### Platform Differences
- macOS: brew at `/opt/homebrew`, ghostty + gcloud via brew cask
- Fedora workstation: brew at `/home/linuxbrew/.linuxbrew`, ghostty via `scottames/ghostty` COPR (`scripts/50-ghostty.sh`), gcloud via dnf repo (`scripts/45-gcloud.sh`)
- Debian/Ubuntu (OrbStack VMs): brew at `/home/linuxbrew/.linuxbrew`, gcloud via apt repo, **no ghostty** (headless VM)
- Homebrew casks are macOS-only — any macOS-only GUI/binary must use `cask "..." if OS.mac?`, and Linux needs a separate install path (system package manager or script)
- Machine-local secrets go in `~/.zshrc.local` (not tracked)

## Secrets Management

Secrets never go in tracked files. Two mechanisms handle this:

### `~/.zshrc.local`
- Sourced at the end of `.zshrc`: `[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local`
- Machine-specific overrides, API keys, tokens, and anything that shouldn't be shared
- Globally gitignored via `.gitignore-global`
- Each machine (macOS, OrbStack VM) has its own independent `.zshrc.local`

### direnv (`.envrc`)
- Per-project environment variables loaded automatically when entering a directory
- Configured in `.zshrc` via `eval "$(direnv hook zsh)"`
- Create a `.envrc` in any project directory with `export VAR=value`, then run `direnv allow`
- `.envrc` is globally gitignored — secrets stay local to each machine
- Use for project-specific AWS profiles, database URLs, API keys, etc.

### Globally Ignored Files (`.gitignore-global`)
These files are ignored across all git repos on the machine:
- `.envrc`, `.env`, `.env.local`, `.zshrc.local` — secrets
- `.idea/`, `.DS_Store`, `node_modules/`, etc. — IDE/OS/dependency artifacts
- `CLAUDE.md` — AI agent instructions

## Adding New Tools

1. **Brew-available on both platforms**: add to `Brewfile`
2. **Brew-available on macOS only**: add `cask "name" if OS.mac?` to `Brewfile`
3. **Requires custom install logic**: create `scripts/NN-name.sh` (pick a number between existing scripts)
4. **Needs dotfile config**: create a stow package directory and add to `STOW_PACKAGES` in `20-stow.sh`
