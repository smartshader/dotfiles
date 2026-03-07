CURRENT_SHELL="$(dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}' || getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != */zsh ]]; then
  info "Current shell is $CURRENT_SHELL, changing to zsh..."
  sudo chsh -s "$(command -v zsh)" "$USER"
else
  info "Shell is already zsh"
fi

ZSH_DIR="$HOME/.zsh"
if [[ ! -d "$ZSH_DIR/zsh-syntax-highlighting" ]]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_DIR/zsh-syntax-highlighting"
fi
if [[ ! -d "$ZSH_DIR/zsh-autosuggestions" ]]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_DIR/zsh-autosuggestions"
fi
