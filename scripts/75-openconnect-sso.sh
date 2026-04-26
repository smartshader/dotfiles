[[ "$DISTRO" != "fedora" ]] && return 0

deps=(openconnect python3.12)
missing=()
for pkg in "${deps[@]}"; do
  rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
done
if [[ ${#missing[@]} -gt 0 ]]; then
  info "Installing openconnect-sso deps (${missing[*]})..."
  sudo dnf install -y "${missing[@]}"
fi

if [[ -x "$HOME/.local/bin/openconnect-sso" ]]; then
  info "openconnect-sso already installed"
  return 0
fi

info "Installing openconnect-sso via pipx (Python 3.12 — lxml 4.x has no prebuilt wheels for 3.13+)..."
pipx install --python python3.12 openconnect-sso
pipx inject openconnect-sso 'setuptools<81'
