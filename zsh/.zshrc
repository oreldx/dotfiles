export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="half-life"
# Optional alternative: ZSH_THEME="morelkai"

plugins=(
    git
    z
    zsh-autosuggestions
)

source "$ZSH/oh-my-zsh.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
