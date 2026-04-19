[[ "$DISTRO" != "fedora" ]] && return 0

if flatpak info app.zen_browser.zen &>/dev/null; then
  info "zen browser already installed"
  return 0
fi

info "Installing zen browser via flathub..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub app.zen_browser.zen
