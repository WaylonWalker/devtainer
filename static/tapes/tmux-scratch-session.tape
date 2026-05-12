Output static/tapes/tmux-scratch-session.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd ~/devtainer/vhs/sandbox' Enter
Type 'clear' Sleep 500ms Enter
Show

Type "echo 'Working on project...'" Enter
Sleep 1s

Sleep 500ms
Type "tmux new-session -A -s scratch" Sleep 500ms Enter
Sleep 2s

Type "echo 'This is a scratch pad'" Enter
Sleep 1s
Type "pwd" Enter
Sleep 1s
Type "ls -la" Enter
Sleep 1s

Type "exit" Sleep 500ms Enter
Sleep 1s

Type "echo 'Back to main work'" Enter
Sleep 1s
