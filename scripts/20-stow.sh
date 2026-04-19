info "Stowing dotfiles..."

STOW_PACKAGES=(zsh starship nvim tmux git)

# ghostty runs on macOS and Fedora desktop; skip on debian (OrbStack VMs)
if [[ "$DISTRO" == "macos" || "$DISTRO" == "fedora" ]]; then
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
