[[ "$DISTRO" != "fedora" ]] && return 0

if command -v ghostty &>/dev/null; then
  info "ghostty already installed"
  return 0
fi

info "Installing ghostty via scottames/ghostty COPR..."
sudo dnf install -y dnf-plugins-core
sudo dnf copr enable -y scottames/ghostty
sudo dnf install -y ghostty
