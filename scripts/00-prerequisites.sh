info "Installing system prerequisites..."

case "$DISTRO" in
  debian)
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential curl git zsh ncurses-term apt-transport-https gnupg unzip net-tools lsof
    ;;
  fedora)
    sudo dnf group install -y development-tools
    sudo dnf install -y curl git zsh unzip net-tools lsof procps-ng
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
