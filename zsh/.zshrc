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

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# rust
if command -v rustup &>/dev/null; then
  export PATH="$(rustup which rustc 2>/dev/null | sed 's|/rustc$||'):$PATH"
fi

# llvm
export PATH="$(brew --prefix llvm 2>/dev/null)/bin:$PATH"
export LDFLAGS="-L$(brew --prefix llvm 2>/dev/null)/lib"
export CPPFLAGS="-I$(brew --prefix llvm 2>/dev/null)/include"

# coreutils
export PATH="$(brew --prefix coreutils 2>/dev/null)/libexec/gnubin:$PATH"

# claude-mem
alias claude-mem='bun "$HOME/.claude/plugins/cache/thedotmack/claude-mem/$(ls -1 "$HOME/.claude/plugins/cache/thedotmack/claude-mem/" 2>/dev/null | sort -V | tail -1)/scripts/worker-service.cjs"'

# setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm 2>/dev/null)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

# git
alias gs="git status"
alias ga="git add ."
alias gf="git fetch --all"
alias gd="git diff"
alias gm="git merge origin/main"

function gc() {
    git commit -m "$*"
}

function gl() {
    local branch=$(git branch --show-current)
    echo "Pulling from origin/$branch..."
    git pull origin "$branch"
}

function gp() {
    local branch=$(git branch --show-current)
    echo "Pushing to origin/$branch..."
    git push -u origin "$branch" "$@"
}

# neovim
alias vim="nvim"
alias vi="nvim"
export EDITOR="nvim"

# tools
alias ls="eza --icons=always"
alias k=kubectl
alias d=docker
alias p=podman
alias o=orb

# setup starship
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"

# direnv (per-directory environment variables)
eval "$(direnv hook zsh)"

# local secrets (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
