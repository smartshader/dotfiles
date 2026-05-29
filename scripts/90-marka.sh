[[ "$DISTRO" != "fedora" ]] && return 0

info "Checking marka..."

GH_BIN="/home/linuxbrew/.linuxbrew/bin/gh"
[[ ! -x "$GH_BIN" ]] && GH_BIN=$(command -v gh 2>/dev/null || true)
if [[ -z "$GH_BIN" ]]; then
    warn "gh CLI not found, skipping marka install"
    return 0
fi

latest_tag=$("$GH_BIN" release view --repo mattenarle10/markamd --json tagName -q '.tagName' 2>/dev/null)
if [[ -z "$latest_tag" ]]; then
    warn "Could not fetch marka release info, skipping"
    return 0
fi

latest_version="${latest_tag#v}"
installed_version=$(rpm -q --queryformat '%{VERSION}' marka-md 2>/dev/null || rpm -q --queryformat '%{VERSION}' marka 2>/dev/null || true)

if [[ -n "$installed_version" && "$installed_version" == "$latest_version" ]]; then
    info "marka $installed_version is already up to date"
    return 0
fi

info "Installing marka $latest_version..."

tmp_dir=$(mktemp -d)
"$GH_BIN" release download --repo mattenarle10/markamd --pattern "*.rpm" --clobber --dir "$tmp_dir"

rpm_file=$(ls "$tmp_dir"/*.rpm 2>/dev/null | head -1)
if [[ -z "$rpm_file" ]]; then
    warn "No RPM found in download, skipping"
    rm -rf "$tmp_dir"
    return 0
fi

sudo dnf install -y "$rpm_file"
rm -rf "$tmp_dir"
