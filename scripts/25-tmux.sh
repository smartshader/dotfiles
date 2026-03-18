TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  info "Installing tmux plugin manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install TPM plugins if not already installed
"$TPM_DIR/bin/install_plugins"

# Reload tmux config if running inside tmux
if [[ -n "${TMUX:-}" ]]; then
  tmux source-file ~/.tmux.conf
fi
