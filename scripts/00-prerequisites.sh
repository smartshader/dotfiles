info "Installing system prerequisites..."

case "$DISTRO" in
  debian)
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential curl git zsh ncurses-term apt-transport-https gnupg unzip net-tools lsof
    if ! command -v aws &>/dev/null; then
      info "Installing AWS CLI v2..."
      curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
      unzip -qo /tmp/awscliv2.zip -d /tmp
      sudo /tmp/aws/install
      rm -rf /tmp/awscliv2.zip /tmp/aws
    fi
    if ! command -v gcloud &>/dev/null; then
      curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
      echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
      sudo apt-get update -qq && sudo apt-get install -y -qq google-cloud-cli
    fi
    ;;
  fedora)
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y curl git zsh
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
