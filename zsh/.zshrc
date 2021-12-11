# follow symlinks
set -o physical

source ~/.profile

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
#

export VIRTUAL_ENV_DISABLE_PROMPT=true

unsetopt BEEP

[ -f ~/.forgit/forgit.plugin.zsh ] && source ~/.forgit/forgit.plugin.zsh
export PATH="$HOME/.npm/node_modules/bin/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# eval "$(dircolors -b ~/.dircolors.256dark)"
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


# autoload -Uz compinit && compinit
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward


~/.local/bin/ta

rm -rf ~/projects/
mkdir ~/projects/
ln -sf ~/work/* ~/projects/
ln -sf ~/git/* ~/projects/


eval "$(register-python-argcomplete pipx)"
# eval `dircolors ~/.config/.dracula.dircolors`

export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_1:

eval "$(starship init zsh)"


autoload -U edit-command-line

zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^e' edit-command-line

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [[ `command -v mcfly` ]] then;
    eval "$(mcfly init zsh)"
fi
