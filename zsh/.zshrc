# auto-update dotfiles
DOTFILES_DIR="$HOME/Projects/personal/dotfiles"
if [[ -d "$DOTFILES_DIR/.git" ]]; then
  (
    cd "$DOTFILES_DIR"
    git fetch origin main --quiet 2>/dev/null
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/main 2>/dev/null)
    if [[ "$LOCAL" != "$REMOTE" ]]; then
      echo "\033[1;34m==>\033[0m Dotfiles update available, syncing..."
      git pull --ff-only --quiet origin main && bash "$DOTFILES_DIR/bootstrap.sh"
    fi
  )
fi

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
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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
export PATH="$HOME/.cargo/bin:$PATH"

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

# tmux
alias ts="tmux list-sessions"
alias ta="tmux attach -t"

# aws
function iot-endpoint() {
    aws iot describe-endpoint --endpoint-type iot:Data-ATS --query endpointAddress --output text 2>/dev/null || {
        echo "Error: AWS CLI not authenticated. Run 'aws sso login' or configure credentials first."
        return 1
    }
}

function ecr-login() {
    local account_id region
    account_id=$(aws sts get-caller-identity --query Account --output text 2>/dev/null) || {
        echo "Error: AWS CLI not authenticated. Run 'aws sso login' or configure credentials first."
        return 1
    }
    region=$(aws configure get region 2>/dev/null)
    region=${region:-us-east-1}
    echo "Logging into ECR: $account_id.dkr.ecr.$region.amazonaws.com"
    aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$account_id.dkr.ecr.$region.amazonaws.com"
}

# neovim
alias vim="nvim"
alias vi="nvim"
export EDITOR="nvim"

# os indicator for starship prompt
if [[ "$(uname -s)" == "Darwin" ]]; then
  export STARSHIP_OSX="(osx)"
else
  export STARSHIP_UBUNTU="($(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo linux))"
fi

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

# zoxide (smarter cd)
# has to be the last in zshrc
eval "$(zoxide init zsh --cmd cd)"

