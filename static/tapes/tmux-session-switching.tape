Output static/tapes/tmux-session-switching.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd ~/devtainer' Enter
Type 'tmux new-session -d -s dotfiles' Enter
Type 'tmux new-session -d -s project1 -c ~/devtainer/vhs/sandbox/project-1' Enter
Type 'tmux new-session -d -s work -c ~/devtainer/vhs/sandbox/work' Enter
Type 'tmux attach -t dotfiles' Enter
Type 'clear' Sleep 500ms Enter
Show

Type "echo 'Current session: dotfiles'" Enter
Sleep 1s

Sleep 500ms
Type "tmux switch-client -t project1" Sleep 500ms Enter
Sleep 2s

Type "echo 'Now in project1 session'" Enter
Sleep 1s
Type "pwd" Enter
Sleep 1s

Sleep 500ms
Type "tmux switch-client -t work" Sleep 500ms Enter
Sleep 2s

Type "echo 'Now in work session'" Enter
Sleep 1s
Type "ls" Enter
Sleep 1s
