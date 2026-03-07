info "Stowing dotfiles..."

STOW_PACKAGES=(zsh starship nvim tmux git)

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
