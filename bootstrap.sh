#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf "\033[1;34m==>\033[1;37m %s\033[0m\n" "$*"; }
warn() { printf "\033[1;33mWarning:\033[0m %s\n" "$*" >&2; }
error() { printf "\033[1;31mError:\033[0m %s\n" "$*" >&2; exit 1; }

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

for script in "$DOTFILES_DIR"/scripts/[0-9]*.sh; do
  source "$script"
done

info "Done! Restart your shell or run: source ~/.zshrc"
info "Run 'tmux' then press prefix + I to install tmux plugins"
