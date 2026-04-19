if command -v gcloud &>/dev/null; then
  info "gcloud already installed"
  return 0
fi

case "$DISTRO" in
  debian)
    info "Installing gcloud via apt..."
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update -qq && sudo apt-get install -y -qq google-cloud-cli
    ;;
  fedora)
    info "Installing gcloud via dnf..."
    sudo tee /etc/yum.repos.d/google-cloud-sdk.repo >/dev/null <<'EOF'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
    sudo dnf install -y google-cloud-cli
    ;;
  macos)
    info "gcloud handled by Homebrew cask on macOS, skipping"
    ;;
esac
