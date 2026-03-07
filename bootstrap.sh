#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf "\033[1;34m==>\033[1;37m %s\033[0m\n" "$*"; }
warn() { printf "\033[1;33mWarning:\033[0m %s\n" "$*" >&2; }
error() { printf "\033[1;31mError:\033[0m %s\n" "$*" >&2; exit 1; }

# ── Detect OS and package manager ──────────────────────────────────
OS="$(uname -s)"
DISTRO=""

if [[ "$OS" == "Linux" ]]; then
  if command -v apt-get &>/dev/null; then
    DISTRO="debian"
  elif command -v dnf &>/dev/null; then
    DISTRO="fedora"
  fi
elif [[ "$OS" == "Darwin" ]]; then
  DISTRO="macos"
fi

info "Detected: $OS ($DISTRO)"

# ── Install system prerequisites ───────────────────────────────────
info "Installing system prerequisites..."

case "$DISTRO" in
  debian)
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential curl git zsh ncurses-term apt-transport-https gnupg
    if ! command -v gcloud &>/dev/null; then
      curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
      echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
      sudo apt-get update -qq && sudo apt-get install -y -qq google-cloud-cli
    fi
    ;;
  fedora)
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y curl git zsh
    ;;
  macos)
    # Xcode CLI tools (provides git, etc.)
    if ! xcode-select -p &>/dev/null; then
      info "Installing Xcode Command Line Tools..."
      xcode-select --install
      echo "Press enter after Xcode CLI tools finish installing..."
      read -r
    fi
    ;;
  *)
    warn "Unknown distro, skipping system prerequisites"
    ;;
esac

# ── Set default shell to zsh ───────────────────────────────────────
CURRENT_SHELL="$(dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}' || getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != */zsh ]]; then
  info "Current shell is $CURRENT_SHELL, changing to zsh..."
  sudo chsh -s "$(command -v zsh)" "$USER"
else
  info "Shell is already zsh"
fi

# ── Install Homebrew ───────────────────────────────────────────────
if [[ ! -x /opt/homebrew/bin/brew && ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to current session
  if [[ "$OS" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
else
  info "Homebrew already installed"
  if [[ "$OS" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# ── Install brew packages ─────────────────────────────────────────
info "Installing brew packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ── Install Rust stable toolchain ─────────────────────────────────
if command -v rustup &>/dev/null; then
  if ! rustup toolchain list | grep -q stable; then
    info "Installing Rust stable toolchain..."
    rustup toolchain install stable
  else
    info "Rust stable toolchain already installed"
  fi
fi

# ── Stow dotfiles ─────────────────────────────────────────────────
info "Stowing dotfiles..."

STOW_PACKAGES=(zsh starship nvim tmux git)

# ghostty only on native macOS (not in VMs)
if [[ "$OS" == "Darwin" ]]; then
  STOW_PACKAGES+=(ghostty)
fi

cd "$DOTFILES_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    info "  Stowing $pkg..."
    stow -R --target="$HOME" "$pkg"
  else
    warn "  Package $pkg not found, skipping"
  fi
done

# ── zsh plugins ────────────────────────────────────────────────────
ZSH_DIR="$HOME/.zsh"
if [[ ! -d "$ZSH_DIR/zsh-syntax-highlighting" ]]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_DIR/zsh-syntax-highlighting"
fi
if [[ ! -d "$ZSH_DIR/zsh-autosuggestions" ]]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_DIR/zsh-autosuggestions"
fi

# ── tmux plugin manager ────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  info "Installing tmux plugin manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# ── Claude Code ───────────────────────────────────────────────────
if ! command -v claude &>/dev/null; then
  info "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  info "Claude Code already installed"
fi

# ── git global gitignore ───────────────────────────────────────────
info "Configuring global gitignore..."
git config --global core.excludesFile ~/.gitignore-global

info "Done! Restart your shell or run: source ~/.zshrc"
info "Run 'tmux' then press prefix + I to install tmux plugins"
