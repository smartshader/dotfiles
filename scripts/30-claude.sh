if [[ ! -x "$HOME/.local/bin/claude" && ! -x "$HOME/.claude/local/claude" ]]; then
  info "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  info "Claude Code already installed"
fi
