# follow symlinks
set -o physical

# set history
HISTFILESIZE=1000000000
HISTSIZE=1000000000
HISTFILE=~/.zsh_history
SAVEHIST=1000000000
setopt appendhistory
setopt share_history
# setopt extendedhistory
# setopt histignoredups
# setopt incappendhistorytime


unsetopt BEEP

[ -f ~/.forgit/forgit.plugin.zsh ] && source ~/.forgit/forgit.plugin.zsh
export PATH="$HOME/.npm/node_modules/bin/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"
eval "$(dircolors -b ~/.dircolors.256dark)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
export DIRENV_WARN_TIMEOUT=100s
export DIRENV_LOG_FORMAT=

export QMK_HOME='~/git/qmk_firmware'

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
### 
# C-R was not loading running contents of .fzf.zsh here seems to resolve the issue
# Start ~/.fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
###


autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward

__conda_setup="$('/home/walkews/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/walkews/miniconda3/etc/profile.d/conda.sh" ]; then
# . "/home/walkews/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
# export PATH="/home/walkews/miniconda3/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# _not_inside_tmux() { [[ -z "$TMUX" ]] }

~/.local/bin/ta

# ensure_tmux_is_running() {
#   if _not_inside_tmux; then
#   fi
# }

# ensure_tmux_is_running

rm -rf ~/projects/
mkdir ~/projects/
ln -sf ~/work/* ~/projects/
ln -sf ~/git/* ~/projects/


export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_1:

eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/u_walkews/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/u_walkews/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/u_walkews/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/u_walkews/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

