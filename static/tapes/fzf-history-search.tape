Output static/tapes/fzf-history-search.mp4

Require echo

Set Shell zsh
Set FontSize 24
Set Width 1200
Set Height 800

Hide
Type 'cd ~' Enter
Type 'echo "previous command 1"' Enter
Type 'echo "previous command 2"' Enter
Type 'echo "git status test"' Enter
Type 'clear' Sleep 500ms Enter
Show

Sleep 500ms
Type "atuin search --interactive" Sleep 1s Enter
Sleep 2s

Type "git" Sleep 500ms
Sleep 1s
Type "Down" Sleep 500ms
Type "Enter" Sleep 1s

Sleep 1s
