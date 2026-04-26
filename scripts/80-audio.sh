[[ "$DISTRO" != "fedora" ]] && return 0

pkgs=(pavucontrol easyeffects rnnoise)
missing=()
for pkg in "${pkgs[@]}"; do
  rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  info "audio tools already installed"
  return 0
fi

info "Installing audio tools (${missing[*]})..."
sudo dnf install -y "${missing[@]}"
