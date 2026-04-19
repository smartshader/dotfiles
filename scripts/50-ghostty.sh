[[ "$DISTRO" != "fedora" ]] && return 0

if ! command -v ghostty &>/dev/null; then
  info "Installing ghostty via scottames/ghostty COPR..."
  sudo dnf install -y dnf-plugins-core
  sudo dnf copr enable -y scottames/ghostty
  sudo dnf install -y ghostty
else
  info "ghostty already installed"
fi

info "Setting ghostty as default terminal..."
xdg-mime default com.mitchellh.ghostty.desktop x-scheme-handler/terminal
gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
