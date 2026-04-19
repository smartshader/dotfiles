[[ "$DISTRO" != "fedora" ]] && return 0

if flatpak info com.discordapp.Discord &>/dev/null; then
  info "discord already installed"
  return 0
fi

info "Installing discord via flathub..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub com.discordapp.Discord
