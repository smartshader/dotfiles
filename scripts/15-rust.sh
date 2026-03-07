if command -v rustup &>/dev/null; then
  if ! rustup toolchain list | grep -q stable; then
    info "Installing Rust stable toolchain..."
    rustup toolchain install stable
  else
    info "Rust stable toolchain already installed"
  fi
fi
