# follow symlinks
# zmodload zsh/zprof
set -o physical

[ -f ~/.profile ] && source ~/.profile
[ -f ~/.alias ] && source ~/.alias
[ -f ~/.alias.local ] && source ~/.alias.local
[ -f ~/.cargo.env ] && source ~/.cargo.env

[ -d ~/.erg/bin ] && export PATH=$PATH:/home/waylon/.erg/bin
[ -d ~/.erg ] && export ERG_PATH=/home/waylon/.erg
[ -d ~/minio-binaries ] && export PATH=$PATH:~/minio-binaries

# set history
HISTFILESIZE=1000000000
HISTSIZE=1000000000
HISTFILE=~/.zsh_history
SAVEHIST=1000000000
setopt appendhistory
setopt share_history

export PBGOPY_SERVER=http://localhost:9090
export VIRTUAL_ENV_DISABLE_PROMPT=true

# nvim-manager
export NVIM_MANAGER_REPO=https://github.com/WaylonWalker/devtainer
export NVIM_CONFIG_PATH=nvim/.config/nvim
export NVIM_MANAGER_INSTALL_DIR=$HOME/.config
export NVIM_MANAGER_PREFIX="nvim-waylonwalker"
export NVIM_APPNAME=${NVIM_MANAGER_PREFIX}-v0.1.3

# unsetopt BEEP

[ -f ~/.forgit/forgit.plugin.zsh ] && source ~/.forgit/forgit.plugin.zsh
export PATH="$HOME/.npm/node_modules/bin/:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/.npm-global/bin/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$(dirname $(uv python find 3.10)):$PATH"
# eval "$(dircolors -b ~/.dircolors.256dark)"

export FLYCTL_INSTALL="/home/waylon/.fly"
[ -d "$FLYCTL_INSTALL" ] && export PATH="$FLYCTL_INSTALL/bin:$PATH"

if [ -d "$HOME/.pyenv" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    export PATH=$(pyenv root)/shims:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    # eval "$(pyenv virtualenv-init -)"
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

# Setup bob
#
# /home/waylon/.local/share/bob/nvim-bin
if [[ ! "$PATH" == */home/waylon/.local/share/bob/nvim-bin* ]]; then
    export PATH="/home/waylon/.local/share/bob/nvim-bin:${PATH}}"
fi



# autoload -Uz compinit && compinit
# autoload -U +X compinit && compinit
# autoload -U +X bashcompinit && bashcompinit

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


if [[ -f `command -v zellij` ]] then;
    if [[ -z "$ZELLIJ" ]]; then
    fi
else
    ~/.local/bin/ta
fi


[ -d ~/projects ] && rm -rf ~/projects/ && mkdir ~/projects/ || mkdir ~/projects
[ -d ~/work ] && [ `ls ~/work | wc -l` -gt 0 ] && ln -sf ~/work/* ~/projects/
[ -d ~/git ] && [ `ls ~/git | wc -l` -gt 0 ] && ln -sf ~/git/* ~/projects/

if [[ `command -v starship` ]] then;
    eval "$(starship init zsh)"
fi

if [[ `command -v direnv` ]] then;
    eval "$(direnv hook zsh)"
    export DIRENV_WARN_TIMEOUT=100s
    export DIRENV_LOG_FORMAT=
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
bindkey -s '^g' 'gitui\n'

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

fpath+=~/.zfunc
# autoload -Uz compinit && compinit

# autoload -Uz compinit
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#     compinit;
# else
#     compinit -C;
# fi;

# cwfetch
#

fpath=($HOME/.zsh/completions $fpath)

autoload -U compinit
compinit -u

## completion from https://github.com/wincent/wincent/blob/85fc42d9e96d408a/aspects/dotfiles/files/.zshrc

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select
wfetch
# zprof
#

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

if [[ -z "$BROWSER" ]]; then
	DEFAULT_BROWSER_DESKTOP=$(xdg-settings get default-web-browser 2>/dev/null)

	if [[ -n "$DEFAULT_BROWSER_DESKTOP" ]]; then
		# Extract the Exec line from the .desktop file
		if [[ -f "/usr/share/applications/$DEFAULT_BROWSER_DESKTOP" ]]; then
			BROWSER_EXEC=$(grep -m1 '^Exec=' "/usr/share/applications/$DEFAULT_BROWSER_DESKTOP")
		elif [[ -f "$HOME/.local/share/applications/$DEFAULT_BROWSER_DESKTOP" ]]; then
			BROWSER_EXEC=$(grep -m1 '^Exec=' "$HOME/.local/share/applications/$DEFAULT_BROWSER_DESKTOP")
		fi

		# Clean up the Exec command (strip placeholders like %u, %U)
		BROWSER=$(echo "$BROWSER_EXEC" | sed -E 's/^Exec=//' | sed -E 's/ ?%[a-zA-Z]//g')
	fi

	# If we couldn't detect it from .desktop, try common fallbacks
	for candidate in brave chromium google-chrome firefox; do
		if command -v $candidate >/dev/null && [[ -z "$BROWSER" ]]; then
			BROWSER=$candidate
		fi
	done

	# Final fallback
	export BROWSER="${BROWSER:-xdg-open}"
fi

# Create a desktop launcher for a web app
web2app() {
	if [ "$#" -ne 3 ]; then
		echo "Usage: web2app <AppName> <AppURL> <IconURL> (IconURL must be in PNG -- use https://dashboardicons.com)"
		return 1
	fi

	local APP_NAME="$1"
	local APP_URL="$2"
	local ICON_URL="$3"
	local ICON_DIR="$HOME/.local/share/applications/icons"
	local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
	local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

	mkdir -p "$ICON_DIR"

	if ! curl -sL -o "$ICON_PATH" "$ICON_URL"; then
		echo "Error: Failed to download icon."
		return 1
	fi

	cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=$BROWSER --new-window --ozone-platform=wayland --app="$APP_URL" --name="$APP_NAME" --class="$APP_NAME"
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true
EOF

	chmod +x "$DESKTOP_FILE"
}

web2app-remove() {
	if [ "$#" -ne 1 ]; then
		echo "Usage: web2app-remove <AppName>"
		return 1
	fi

	local APP_NAME="$1"
	local ICON_DIR="$HOME/.local/share/applications/icons"
	local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
	local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

	rm "$DESKTOP_FILE"
	rm "$ICON_PATH"
}

# start_tmux
[ -f ~/.local/bin/ta ] && ~/.local/bin/ta
