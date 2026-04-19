[[ "$DISTRO" != "fedora" ]] && return 0

pkgs=(speech-dispatcher speech-dispatcher-utils espeak-ng)
missing=()
for pkg in "${pkgs[@]}"; do
  rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  info "speech-dispatcher already installed"
  return 0
fi

info "Installing speech-dispatcher (${missing[*]})..."
sudo dnf install -y "${missing[@]}"
