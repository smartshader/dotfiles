info "Installing system prerequisites..."

case "$DISTRO" in
  debian)
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential curl git git-lfs zsh ncurses-term apt-transport-https gnupg unzip net-tools lsof
    ;;
  fedora)
    sudo dnf group install -y development-tools
    sudo dnf install -y curl git git-lfs zsh unzip net-tools lsof procps-ng pipx dwarves podman-docker vim-common
    sudo dnf install -y webkit2gtk4.1-devel openssl-devel wget file libappindicator-gtk3-devel librsvg2-devel
    sudo touch /etc/containers/nodocker
    systemctl --user enable --now podman.socket
    mkdir -p ~/.docker/cli-plugins
    curl -fsSL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
      -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    ;;
  macos)
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
