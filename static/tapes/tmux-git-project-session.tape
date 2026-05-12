Output static/tapes/tmux-git-project-session.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd ~/devtainer/vhs/sandbox/git/repo1' Enter
Type 'clear' Sleep 500ms Enter
Show

Type "echo 'In a git repo directory'" Enter
Sleep 1s
Type "git status" Enter
Sleep 1s

Sleep 500ms
Type "tmux new-session -d -s repo1 -c ~/devtainer/vhs/sandbox/git/repo1" Sleep 500ms Enter
Type "tmux switch-client -t repo1" Sleep 500ms Enter
Sleep 2s

Type "echo 'New session created for repo1'" Enter
Sleep 1s
Type "tmux list-sessions" Enter
Sleep 2s

Sleep 500ms
Type "nvim README.md" Sleep 1s Enter
Sleep 2s
Type ":q" Sleep 500ms Enter
Sleep 1s
