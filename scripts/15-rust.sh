if command -v rustup &>/dev/null; then
  if ! rustup toolchain list | grep -q stable; then
    info "Installing Rust stable toolchain..."
    rustup toolchain install stable
  else
    info "Rust stable toolchain already installed"
  fi
  # ensure cargo shims exist in ~/.cargo/bin (skipped when rustup is installed via brew)
  if [[ ! -d "$HOME/.cargo/bin" ]]; then
    info "Setting up cargo shims..."
    rustup default stable
  fi
fi
