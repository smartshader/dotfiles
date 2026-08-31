info "Checking herdr service..."

if ! brew services list &>/dev/null; then
  warn "brew services unavailable, skipping herdr service"
  return 0
fi

if [[ "$(brew services list | awk '$1 == "herdr" { print $2 }')" == "started" ]]; then
  info "herdr service already running"
else
  info "Starting herdr service..."
  brew services start herdr
fi
