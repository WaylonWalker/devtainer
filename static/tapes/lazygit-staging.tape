Output static/tapes/lazygit-staging.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd ~/devtainer/vhs/sandbox/git/repo1' Enter
Type 'echo "# Updated README" >> README.md' Enter
Type 'echo "new file" > new-feature.py' Enter
Type 'clear' Sleep 500ms Enter
Show

Type "lazygit" Sleep 1s Enter
Sleep 2s

Type "j" Sleep 200ms
Type "j" Sleep 500ms
Type "Space" Sleep 1s
Type "c" Sleep 1s
Type "Add new feature" Sleep 1s
Type "Enter" Sleep 1s
Type "p" Sleep 2s
Type "q" Sleep 500ms

Sleep 1s
