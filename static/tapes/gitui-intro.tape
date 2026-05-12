Output static/tapes/gitui-intro.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd ~/devtainer/vhs/sandbox/git/repo1' Enter
Type 'git init' Enter
Type 'echo "# Test Project" > README.md' Enter
Type 'git add README.md' Enter
Type 'clear' Sleep 500ms Enter
Show

Type "gitui" Sleep 1s Enter
Sleep 2s

Type "c" Sleep 1s
Type "Initial commit" Sleep 1s
Type "Ctrl+s" Sleep 1s
Type "p" Sleep 2s
Type "q" Sleep 500ms

Sleep 1s
