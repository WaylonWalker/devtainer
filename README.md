<p align='center'>
<img src='artwork/devtainer.png' align='center'/>
</p>
<h1 align='center'>devtainer</h1>
My personal development docker container base image

# Motivation


This container comes pre-built with all of my favorite command line tools that
I use most often.  I was getting sick of how much system resources vscode hogs
up by the end of the day when I get many different projects open all at once.
Nothing against VSCode, it's a great product, it just takes a lot of resources.
Editors like VScode are great for editing full projects, but often I just want
to quickly browse through a project with all of my favorite tools handy.  Even
though this container is a bit bulky its startup performance has been superior
to VSCode and even neovim inside of wsl.

---

# Screenshot September 30, 2020

<p align='center'>
<img src='artwork/devtainer_sept_30_2020.png.png' align='center'/>
</p>

---

# Startup Alias

If your on windows like me it is handy to convert wsl paths to windows paths.
If you are not on windows simply use `$pwd` isntead of `$wwd`.

``` bash
# windows working directory
wwd(){pwd | sed 's|/mnt/c|C:|g' | sed "s|/|\\\|g"}
```

Startup with setup shared from parent machine.

``` bash
devtainer () {
 docker run -it --rm \
 -v "$(wwd)":/src \
 -v $HOME/.aws:/root/.aws \
 -v $HOME/.zsh_history:/root/.zsh_history \
 -v $HOME/.git-credentials:/root/.git-credentials \
 -v $HOME/.gitconfig:/root/.gitconfig \
 -v $HOME/.ipython:/root/.ipython \
 waylonwalker/devtainer 
 $@
}
```

Open directly into vim with fzf.vim open.

``` bash
vim () {
 docker run -it --rm \
 -v "$(wwd)":/src \
 -v $HOME/.aws:/root/.aws \
 -v $HOME/.zsh_history:/root/.zsh_history \
 -v $HOME/.git-credentials:/root/.git-credentials \
 -v $HOME/.gitconfig:/root/.gitconfig \
 -v $HOME/.ipython:/root/.ipython \
 waylonwalker/devtainer 
 vim +GFiles
}
```

Open with a specific tmux layout.

``` bash
tmux () {
 docker run -it --rm \
 -v "$(wwd)":/src \
 -v $HOME/.aws:/root/.aws \
 -v $HOME/.zsh_history:/root/.zsh_history \
 -v $HOME/.git-credentials:/root/.git-credentials \
 -v $HOME/.gitconfig:/root/.gitconfig \
 -v $HOME/.ipython:/root/.ipython \
 waylonwalker/devtainer 
 bash -c "tmux new-session -t 'editor' -d;\
    tmux send-keys 'echo hello' Enter;\
    tmux split-window -v 'zsh';
    tmux send-keys nvim Space /src/ Space +GFiles C-m; \
    tmux rotate-window; \
    tmux select-pane -U; \
    tmux -2 attach-session -d
    "
}
```

---

# CLI Tools

* ag
* awscli
* bat
* black
* diff-so-fancy
* flake8
* forgit
* git
* gitui
* glow
* interrogate
* ipython
* make
* markserv
* mypy
* neovim
* nodejs
* oh-my-zsh
* pre-commit
* python
* ripgrep
* tmux
* vifm
* visidata
* zsh

# Vim Plugins

* SirVer/ultisnips
* airblade/vim-gitgutter
* ambv/black
* amix/vim-zenroom2
* easymotion/vim-easymotion
* epilande/vim-es2015-snippets
* epilande/vim-react-snippets
* honza/vim-snippets
* itchyny/lightline.vim
* junegunn/fzf
* junegunn/fzf.vim
* junegunn/goyo.vim
* junegunn/limelight.vim
* justinmk/vim-sneak
* mbbill/undotree
* michaeljsmith/vim-indent-object
* rakr/vim-one
* ryanoasis/vim-devicons
* scrooloose/nerdtree
* scrooloose/syntastic
* terryma/vim-smooth-scroll
* thinca/vim-visualstar
* tpope/vim-commentary
* tpope/vim-fugitive
* tpope/vim-markdown
* tpope/vim-surround
* valloric/matchtagalways
* valloric/youcompleteme
* vim-scripts/AutoComplPop
* w0rp/ale
* wellle/targets.vim
