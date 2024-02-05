i () {
    pushd ~/.local/bin
    echo $i_progs | grep $1 | xargs -I {} curl https://i.wayl.one/{} | bash
    popd
}

i_progs="
sharkdp/bat
neovim/neovim?as=nvim
bootandy/dust
ogham/exa
sharkdp/fd
dalance/procs
chmln/sd
BurntSushi/ripgrep
BurntSushi/ripgrep?as=rg
cjbassi/ytop
dbrgn/tealdeer
imsnif/bandwhich
pemistahl/grex
starship/starship
imsnif/diskonaut
zellij-org/zellij
topgrade-rs/topgrade
ducaale/xh
sirwart/ripsecrets
atuinsh/atuin
ogham/dog
kovidgoyal/kitty
sharkdp/pastel
mgdm/htmlq
go-task/task
sharkdp/fd
containers/podman
cli/cli?as=gh
jesseduffield/lazygit
extrawurst/gitui
amrdeveloper/gql
"

pipx_progs="
glances
httpx
httpie
saws
mycli
pgcli
litecli
copier
cookiecutter
black
ruff
python-lsp-server
jedi-language-server
mypy
flake8
pyflyby
ipython
"

mkdir -p ~/.local/bin
pushd ~/.local/bin

echo "$i_progs" | parallel -j+0 "curl https://i.wayl.one/{} | bash"

popd
