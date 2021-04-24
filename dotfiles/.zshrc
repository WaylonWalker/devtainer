# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# export TERM="screen-256"

[ -f ~/.forgit/forgit.plugin.zsh ] && source ~/.forgit/forgit.plugin.zsh
export PATH="$HOME/.local/bin:$PATH"
export PATH="/squashfs-root/usr/bin:$PATH"
autoload -U bashcompinit
bashcompinit
eval "$(dircolors -b ~/.dircolors.256dark)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
export DIRENV_WARN_TIMEOUT=100s
export DIRENV_LOG_FORMAT=

plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.alias
source ~/.alias.local


# Setup fzf
# ---------
if [[ ! "$PATH" == */root/.local/share/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/root/.local/share/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/root/.local/share/nvim/plugged/fzf/shell/completion.zsh" 2> /dev/null

source ~/.keymap.sh

### 
# C-R was not loading running contents of .fzf.zsh here seems to resolve the issue
# Start ~/.fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
###
