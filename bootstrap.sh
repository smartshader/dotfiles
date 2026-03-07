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
    sudo apt-get install -y -qq build-essential curl git zsh ncurses-term
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
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != */zsh ]]; then
  info "Current shell is $CURRENT_SHELL, changing to zsh..."
  sudo chsh -s "$(command -v zsh)" "$USER"
else
  info "Shell is already zsh"
fi

# ── Install Homebrew ───────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to current session
  if [[ "$OS" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
else
  info "Homebrew already installed"
fi

# ── Install brew packages ─────────────────────────────────────────
info "Installing brew packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ── Stow dotfiles ─────────────────────────────────────────────────
info "Stowing dotfiles..."

STOW_PACKAGES=(zsh starship nvim)

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

info "Done! Restart your shell or run: source ~/.zshrc"
