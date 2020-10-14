#!/bin/bash
# work in progress

install_apt () {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        command-not-found \
        curl \
        figlet \
        fuse \
        g++ \
        gettext \
        git  \
        htop \
        jq \
        less \
        libcurl4-gnutls-dev \
        libevent-dev \
        libexpat1-dev \
        libfuse2 \
        libghc-zlib-dev \
        libncurses5-dev \
        libssl-dev \
        m4 \
        m4-doc \
        make \
        pandoc \
        perl \
        python3-apt \
        python3-distutils \
        python3-venv \
        ripgrep \
        silversearcher-ag \
        software-properties-common \
        tmux \
        tzdata \
        universal-ctags \
        unzip \
        vifm \
        wget \
        fd-find \
        zsh
}

mkif () {
    if [ ! -d $1 ]; then
        mkdir -p $1;
    fi
}


install_python () {
    mkif ~/downloads
    cd ~/downloads

    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm -rf ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
    ~/miniconda3/bin/conda init zsh
    source ~/.bashrc

    python -m pip install --upgrade pip && \
    # start pip installs
    python -m pip install \
        awscli \
        black \
        flake8 \
        interrogate \
        ipython \
        mypy \
        pre-commit \
        pynvim \
        visidata
        # end pip install
}

install_git () {
    mkif ~/downloads
    cd ~/downloads
    export GIT_VERSION=$(curl --silent https://github.com/git/git/releases/ | grep git/git/releases/tag | grep -v rc | head -n 1 | sed 's/^.*tag\///' | sed 's/".*//')
    wget https://github.com/git/git/archive/${GIT_VERSION}.tar.gz -q -O- - | tar xz && \
        cd git-* && \
        sudo make prefix=/usr/local all && \
        sudo make prefix=/usr/local install
}

install_bat () {
    mkif ~/downloads
    cd ~/downloads
    BAT_VERSION=$(curl --silent https://github.com/sharkdp/bat/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
    wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz -q
    tar -zxf bat-v0.16.0-x86_64-unknown-linux-gnu.tar.gz
    cp bat-v0.16.0-x86_64-unknown-linux-gnu.tar.gz/bat ~/usr/local/bin/
}


install_fzf () {
    mkif ~/downloads
    cd ~/downloads
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
        ~/.fzf/install --all
}

install_zoxide () {
    # curl --silent --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sed 's/sudo//g' | sh
    curl --silent --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sh
}

install_starship () {
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y
    cat ~/.bashrc | grep -q 'eval "$(starship init bash)"' || echo 'eval "$(starship init bash)"' >> ~/.bashrc
    cat ~/.zshrc | grep -q 'eval "$(starship init zsh)"' || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
}

install_forgit () {
    rm -rf ~/.forgit
    git clone https://github.com/wfxr/forgit ~/.forgit
    cat ~/.bashrc | grep -q 'source ~/.forgit/forgit.plugin.sh' || echo 'source ~/.forgit/forgit.plugin.zsh' >> ~/.bashrc
    cat ~/.zshrc | grep -q 'source ~/.forgit/forgit.plugin.zsh' || echo 'source ~/.forgit/forgit.plugin.zsh' >> ~/.zshrc
}


install_glow () {
    local DIR=$(pwd)
    mkif ~/downloads
    cd ~/downloads
    rm -rf glow
    GLOW_VERSION=$(curl --silent https://github.com/charmbracelet/glow/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
    wget https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_x86_64.tar.gz -q && \
        mkdir ~/downloads/glow && \
        tar -zxf glow_${GLOW_VERSION}_linux_x86_64.tar.gz --directory ~/downloads/glow && \
        sudo mv ~/downloads/glow/glow /usr/bin/
    cd $DIR
}

install_oh_my_zsh () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null
}

install_gitui () {
    GITUI_VERSION=$(curl --silent https://github.com/extrawurst/gitui/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
    wget https://github.com/extrawurst/gitui/releases/download/v${GITUI_VERSION}/gitui-linux-musl.tar.gz -O- -q | sudo tar -zxf - -C /usr/bin/
}


install_node () {
    mkif ~/downloads
    cd ~/downloads
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
    sudo apt-get install nodejs
    npm i -g diff-so-fancy
    npm i -g markserv
    npm i -g neovim
}

configure () {
    sudo chsh -s /usr/bin/zsh
    git clone https://github.com/WaylonWalker/devtainer.git ~/downloads/devtainer
    cp -r ~/downloads/devtainer/dotfiles/*(D) ~/ # include dotfiles
}

install_neovim () {
    mkif ~/downloads
    cd ~/downloads

    NEOVIM_VERSION=$(curl --silent https://github.com/neovim/neovim/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
    curl --silent -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim.appimage
    sudo chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract > nvim-extract.log 2>&1
    mkdir ~/.local/share/neovim -p
    mv ~/downloads/squashfs-root/* ~/.local/share/neovim
    # rm /usr/bin/nvim
    sudo ln -s ~/.local/share/neovim/AppRun /usr/bin/nvim
    sudo ln -s ~/.local/share/neovim/AppRun /usr/bin/vim

    python -m venv ~/.local/share/nvim/black
    ~/.local/share/nvim/black/bin/pip install -U -q --no-cache-dir --disable-pip-version-check black;

    cp ~/downloads/devtainer/dotfiles/ $HOME

    # install vim in order to run PlugInstall, neovim cannot run PlugInstall unattended
    sudo apt-get install -y --no-install-recommends vim
    cp ~/.config/nvim/init.vim ~/.vimrc
    curl --silent -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    /usr/bin/vim +PlugInstall +qall +enter +silent
    rm ~/.vimrc
    rm -rf ~/.vim
    apt-get remove vim -y

    chmod 0750 ~/.local/share/nvim/
    mkdir ~/.local/share/nvim/backup/
    mkdir ~/.local/share/nvim/swap/
    mkdir ~/.local/share/nvim/undo/
}
