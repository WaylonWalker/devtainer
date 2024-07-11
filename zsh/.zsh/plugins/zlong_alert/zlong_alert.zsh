# Ignore commands if they start with the follow
zlong_ignore_cmds='vim ssh'

# Define what a long duration is
zlong_duration=.1

# Need to set an initial timestamps otherwise, we'll be comparing an empty
# string with an integer.
zlong_timestamp=`date +%s`

# Define the alerting function, do the text processing here
zlong_alert_func() {
    local cmd=$1
    local secs=$2
    local ftime=$(printf '%dh:%dm:%ds\n' $(($secs / 3600)) $(($secs % 3600 / 60)) $(($secs % 60)))

    if [[ -f `command -v notify-send` ]] then;
        notify-send "Done: $1" "Time: $ftime"
    fi
    if [[ -f $TMUX ]] then;
        tmux display-message "Done: $1 Time: $ftime"
    fi
    echo "\a"
}

zlong_alert_pre() {
    zlong_timestamp=`date +%s`
    zlong_last_cmd=$1
}

zlong_alert_post() {
    local now=`date +%s`
    local duration=$(($now - $zlong_timestamp))
    local lasted_long=$(($duration - $zlong_duration))
    local cmd_head=$(echo $zlong_last_cmd | cut -d ' ' -f 1)
    if [[ $lasted_long -gt 0 && ! -z $zlong_last_cmd && ! $zlong_ignore_cmds =~ $cmd_head ]]; then
        zlong_alert_func $zlong_last_cmd duration
    fi
    zlong_last_cmd=''
}

# if add-zsh-hook is not available, use the preexec and precmd functions
autoload -Uz add-zsh-hook
add-zsh-hook preexec zlong_alert_pre
add-zsh-hook precmd zlong_alert_post
