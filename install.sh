#!/bin/bash
# a work in progress

# helpers

mkif () {
    if [ ! -d $1 ]; then
        mkdir -p $1;
    fi
}

touchif() { mkdir -p "$(dirname "$1")" && touch "$1" ; }

mkln() {
    if [[ ! -e $1 || ! -e $2 ]];
    then
        mkif $1
        rmif $2
        ln -s $1 $2
    fi
}

sourceif() {
    if [[ -e $1 ]]
    then
        source $1
    fi
}

logme(){
    if [[ "$*" == *"--main"* ]]; 
    then
        message=$(echo $* | sed 's/--main//g')
        echo "$PURPLE$message$RESTORE";
        echo $TAB$LBLACK$0$RESTORE;
        echo $TAB$LBLACK$(TZ=":America/Chicago" date +"%b %d %Y %I:%M %p America/Chicago") $RESTORE;

    else
        echo "$LCYAN$*$RESTORE";
    fi
}

# https://gist.github.com/elucify/c7ccfee9f13b42f11f81

RESTORE=$(echo -en '\033[0m')
BLACK=$(echo -en '\033[00;30m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
LYELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
MAGENTA=$(echo -en '\033[00;35m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')
LGRAY=$(echo -en '\033[00;37m')
LRED=$(echo -en '\033[01;31m')
LGREEN=$(echo -en '\033[01;32m')
YELLOW=$(echo -en '\033[01;33m')
LBLUE=$(echo -en '\033[01;34m')
LMAGENTA=$(echo -en '\033[01;35m')
LPURPLE=$(echo -en '\033[01;35m')
LCYAN=$(echo -en '\033[01;36m')
WHITE=$(echo -en '\033[01;37m')
LBLACK=$(echo -en '\033[00;90m')

runner(){
    logfile="${HOME}/install_logs/$(basename $1).log"
    touchif $logfile
    echo -e "$PURPLE Starting $1 $RESTORE \n $TAB $LBLACK$(TZ=":America/Chicago" date +"%b %d %Y %I:%M %p America/Chicago")$RESTORE"
    echo -e "$PURPLE Starting $1 $RESTORE \n $TAB $LBLACK$(TZ=":America/Chicago" date +"%b %d %Y %I:%M %p America/Chicago")$RESTORE" >> $logfile
    passmsg="$TAB $GREEN ✅   success on $(basename $1) $RESTORE"
    failmsg="$TAB $RED ❌   Failed to run $(basename $1) $BLUE \n$TAB see log $YELLOW $logfile $RESTORE"
    local dir=$(pwd)
    $1 >> $logfile 2>&1 && $(stat=$passmsg && cd $dir) || $(stat=$failmsg && cd $dir)
    echo $stat
    echo $stat >> $logfile
    # if [[ "$stat" == *"Failed"* ]]; then
    #     exit 
    # fi
}


# install

install_apt () {
    _install_apt () {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        command-not-found \
        curl \
        fd-find \
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
        sudo \
        tmux \
        tzdata \
        universal-ctags \
        unzip \
        vifm \
        wget \
        zsh
    }
    runner _install_apt
}

install_python () {
    _install_python () {
        mkif ~/miniconda3
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
        bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

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
    runner _install_python
}

install_git () {
    _install_git () {
        mkif ~/downloads
        cd ~/downloads
        export GIT_VERSION=$(curl --silent https://github.com/git/git/releases/ | grep git/git/releases/tag | grep -v rc | head -n 1 | sed 's/^.*tag\///' | sed 's/".*//')
        wget https://github.com/git/git/archive/${GIT_VERSION}.tar.gz -q -O- - | tar xz && \
            cd git-* && \
            sudo make prefix=/usr/local all && \
            sudo make prefix=/usr/local install
    }
    runner _install_git
}

install_bat () {
    _install_bat () {
        mkif ~/downloads
        cd ~/downloads
        BAT_VERSION=$(curl --silent https://github.com/sharkdp/bat/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
        wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz -q
        tar -zxf bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz
        sudo cp bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu/bat /usr/local/bin/
    }
    runner _install_bat
}


install_fzf () {
    _install_fzf () {
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
            ~/.fzf/install --all
    }
    runner _install_fzf
}

install_zoxide () {
    _install_zoxide () {
        curl --silent --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sh
    }
    runner _install_zoxide
}

install_starship () {
    _install_starship () {
        curl -fsSL https://starship.rs/install.sh | bash -s -- -y
        cat ~/.bashrc | grep -q 'eval "$(starship init bash)"' || echo 'eval "$(starship init bash)"' >> ~/.bashrc
        cat ~/.zshrc | grep -q 'eval "$(starship init zsh)"' || echo 'eval "$(starship init zsh)"' >> ~/.zshrc
    }
    runner _install_starship
}

install_forgit () {
    _install_forgit () {
        rm -rf ~/.forgit
        git clone https://github.com/wfxr/forgit ~/.forgit
        cat ~/.bashrc | grep -q 'source ~/.forgit/forgit.plugin.sh' || echo 'source ~/.forgit/forgit.plugin.zsh' >> ~/.bashrc
        cat ~/.zshrc | grep -q 'source ~/.forgit/forgit.plugin.zsh' || echo 'source ~/.forgit/forgit.plugin.zsh' >> ~/.zshrc
    }
    runner _install_forgit
}

install_glow () {
    _install_glow () {
        mkif ~/downloads
        cd ~/downloads
        rm -rf glow
        GLOW_VERSION=$(curl --silent https://github.com/charmbracelet/glow/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
        wget https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_x86_64.tar.gz -q && \
            mkdir ~/downloads/glow && \
            tar -zxf glow_${GLOW_VERSION}_linux_x86_64.tar.gz --directory ~/downloads/glow && \
            sudo mv ~/downloads/glow/glow /usr/bin/
    }
    runner _install_glow
}

install_oh_my_zsh () {
    _install_oh_my_zsh () {
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null
    }
    runner _install_oh_my_zsh
}

install_gitui () {
    _install_gitui () {
        GITUI_VERSION=$(curl --silent https://github.com/extrawurst/gitui/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//')
        wget https://github.com/extrawurst/gitui/releases/download/v${GITUI_VERSION}/gitui-linux-musl.tar.gz -O- -q | sudo tar -zxf - -C /usr/bin/
    }
    runner _install_gitui
}


install_node () {
    _install_node () {
        curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
        sudo apt-get install nodejs -y
        npm i -g diff-so-fancy
        npm i -g markserv
        npm i -g neovim
    }
    runner _install_node
}

install_configure () {
    _install_configure () {
        sudo chsh -s /usr/bin/zsh
        git clone https://github.com/WaylonWalker/devtainer.git ~/downloads/devtainer
        cp -r ~/downloads/devtainer/dotfiles/*(D) ~/ # include dotfiles
    }
    runner _install_configure
}

install_neovim () {
    _install_neovim () {
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
    runner _install_neovim
}

install_docker() {
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt update
    apt-cache policy docker-ce
    sudo apt install docker-ce -y
    sudo systemctl status docker
}

install_main () {
    install_apt
    install_configure
    install_git

    install_python
    install_node

    install_bat
    install_gitui
    install_forgit
    install_fzf
    install_glow
    install_zoxide
    install_oh_my_zsh

    install_neovim
}

setup_droplet () {
    install_docker
    install_main
}
