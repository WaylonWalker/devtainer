# follow symlinks
set -o physical

[ -f ~/.profile ] && source ~/.profile
[ -f ~/.alias ] && source ~/.alias
[ -f ~/.alias.local ] && source ~/.alias.local

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
export PATH="$HOME/.local/.npm-global/bin/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
# eval "$(dircolors -b ~/.dircolors.256dark)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
export DIRENV_WARN_TIMEOUT=100s
export DIRENV_LOG_FORMAT=

if [ -d "$HOME/.pyenv" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

export QMK_HOME='~/git/qmk_firmware'


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

[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
[ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward


~/.local/bin/ta

[ -d ~/projects ] && rm -rf ~/projects/ && mkdir ~/projects/ || mkdir ~/projects
[ -d ~/work ] && [ `ls ~/work | wc -l` -gt 0 ] && ln -sf ~/work/* ~/projects/
[ -d ~/git ] && [ `ls ~/git | wc -l` -gt 0 ] && ln -sf ~/git/* ~/projects/

if [[ `command -v pipx` ]] then;
    eval "$(register-python-argcomplete pipx)"
fi
# eval `dircolors ~/.config/.dracula.dircolors`

export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_1:

if [[ `command -v starship` ]] then;
    eval "$(starship init zsh)"
fi


autoload -U edit-command-line

zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^e' edit-command-line

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [[ `command -v mcfly` ]] then;
    eval "$(mcfly init zsh)"
fi

function expand-alias() {
    zle _expand_alias
    zle self-insert
}
function cwfetch() {
    clear
    wfetch
}
zle -N expand-alias
bindkey -M main '^n' expand-alias
bindkey -s '^k' 'cwfetch\n'

# dedupe path at the very end
eval "typeset -U path"

[ -f ~/.zsh/plugins/zlong_alert/zlong_alert.zsh ] && source ~/.zsh/plugins/zlong_alert/zlong_alert.zsh
zlong_duration=30
zlong_ignore_cmds="vim ssh"
allcommands(){compgen -c | fzf}
bindkey -s '^p' 'allcommands\n'

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

cwfetch
