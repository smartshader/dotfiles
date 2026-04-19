[[ "$DISTRO" != "fedora" ]] && return 0

if flatpak info com.slack.Slack &>/dev/null; then
  info "slack already installed"
  return 0
fi

info "Installing slack via flathub..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub com.slack.Slack
