# terminal colors (install ncurses-term)
export TERM=xterm-256color

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups hist_ignore_space

# completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# setup brew
if [[ -d /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# setup binaries
export PATH="$HOME/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# setup claude
alias claude-mem='/home/imad/.bun/bin/bun "/home/imad/.claude/plugins/cache/thedotmack/claude-mem/10.5.2/scripts/worker-service.cjs"'

# setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm 2>/dev/null)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

# neovim
alias vim="nvim"
alias vi="nvim"
export EDITOR="nvim"

# setup starship
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"
