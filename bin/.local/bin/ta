#!/bin/bash
#
# Attach or create tmux session named the same as current directory.
#
# # Attach
#
# If called with --start or without a directory name ta will create a plain
# single window layout
# 
# ╭──────────────────────────────────────────────────────────╮
# │ my_project on  main [!?] via 🐍 v3.8.8 via ©conda-env   │
# │ ❯                                                        │
# │                                                          │  
# │                                                          │  
# │                                                          │  
# │                                                          │                 
# │                                                          │  
# │                                                          │  
# │                                                          │  
# │                                                          │  
# │                                                          │  
# │                                                          │  
# ╰──────────────────────────────────────────────────────────╯
# 
# # Split Layout
# 
# When called to a specific directory ta will first ask which project to open
# then attach or create anew session split with neovim on top.
# 
# ╭──────────────────────────────────────────────────────────╮
# │                                                          │  
# │                                                          │                 
# │                          nvim                            │  
# │                                                          │  
# │                                                          │  
# ├──────────────────────────────────────────────────────────┤
# │ my_project on  main [!?] via 🐍 v3.8.8 via ©conda-env   │
# │ ❯                                                        │
# │                                                          │  
# │                                                          │  
# │                                                          │  
# │                                                          │  
# ╰──────────────────────────────────────────────────────────╯

 not_in_tmux() {
   [ -z "$TMUX" ]
 }

DIR=$1

# If no arguments are passed in try to immediately attach or start without further input
echo $DIR
if [ -z "$DIR" ]; then
   if not_in_tmux; then
     tmux attach && exit 1 || DIR="--start"
   else
       exit 1
   fi
fi

# If --start was passed in immediately start a new session based on the current directory
if [ "$DIR" == "--start" ]; then
    echo "starting"
    path_name="$(basename "$PWD" | tr . -)"
    session_name=${path_name//./_}
else
    # ask the user which directory to start in
    _session_name=$(cd $DIR && ls -d */ | sed  "s|/||g" | fzf --reverse --header="Select project from $(basename $DIR) >")
    session_name=${_session_name//./_}
    path_name=$DIR/$_session_name
fi

echo session name is \"$session_name\"
echo path name is $path_name

if [ -z "$session_name" ]; then
    # operation cancelled by user
    exit 1
fi

session_exists() {
    # checks if the $session_name exists
    tmux has-session -t "=$session_name"
}
 
create_detached_session() {
if [ "$DIR" == "--start" ]; then
    (TMUX='' 
    tmux new-session -Ad -s "$session_name" -c $path_name
    )
else
    (TMUX='' 
    tmux new-session -Ad -s "$session_name" -c $path_name;
    tmux split-window -vb -t "$session_name" -c $path_name -p 70;
    tmux send-keys -t "$session_name" "nvim '+Telescope find_files'" Enter;
    )
fi
 }
 
create_if_needed_and_attach() {
    if not_in_tmux; then
        tmux new-session -As "$session_name" -c $path_name
    else
        if ! session_exists; then
        create_detached_session
        fi
        tmux switch-client -t "$session_name"
    fi
}

 attatch_to_first_session() {
     tmux attach -t $(tmux list-sessions -F "${session_name}" | head -n 1)
     tmux choose-tree -Za
}
 
create_if_needed_and_attach || attatch_to_first_session
