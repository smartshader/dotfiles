if [[ ! -x /opt/homebrew/bin/brew && ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  info "Homebrew already installed"
fi

if [[ "$OS" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

info "Installing brew packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
