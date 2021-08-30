From python:3.8-slim
MAINTAINER "Waylon S. Walker"
LABEL version="1.0"
SHELL ["/bin/bash", "-c"] 
ENV \
    UID="1000" \
    GID="1000" \
    UNAME="root" \
    GNAME="root"
ENV \
    HOME="/${UNAME}" \
    SHELL="/bin/zsh" \
    EDITOR="nvim"\
    # WORKSPACE=$HOME \
    # GIT_VERSION=2.28.0 \
    # BAT_VERSION=0.15.4 \
    # VIFM_VERSION=0.10.1 \
    # GITUI_VERSION=0.10.1 \
    GIT_VERSION=LATEST \
    BAT_VERSION=LATEST \
    VIFM_VERSION=LATEST \
    GITUI_VERSION=LATEST \
    NEOVIM_VERSION=LATEST \
    NVIM_CONFIG="${HOME}/.config/nvim" \
    NVIM_PCK="${HOME}/.local/share/nvim/site/pack" \
    ENV_DIR="${HOME}/.local/share/vendorvenv" \
    NVIM_PROVIDER_PYLIB="python3_neovim_provider" \
    NODE_VERSION=12.x \
    NPM_CONFIG_LOGLEVEL=warn
    # ZSH="${HOME}/.oh-my-zsh" \
ARG DEBIAN_FRONTEND='noninteractive'

RUN apt-get update; \
    apt-get upgrade; \
    apt-get install --no-install-recommends -y \
    # start system install
    build-essential \
    cmake \
    command-not-found \
    curl \
    figlet \
    fuse \
    fzy \
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
    libncurses5-dev \
    libssl-dev \
    m4 \
    m4-doc \
    make \
    pandoc \
    perl \
    python-neovim \
    python3-apt \
    python3-distutils \
    python3-neovim \
    python3-venv \
    ripgrep \
    silversearcher-ag \
    software-properties-common \
    stow \
    tmux \
    tzdata \
    universal-ctags \
    unzip \
    wget \
    zsh; \
    rm -rf /var/lib/apt/lists/*; \
    echo done

WORKDIR /downloads



RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir\
        # start pip installs
        awscli \
        black \
        flake8 \
        interrogate \
        ipython \
        mypy \
        pre-commit \
        pynvim \
        rich \
        visidata && \
        rm -rf /root/.cache/pip;

# start manual installs
# git
#RUN export GIT_VERSION=$(curl --silent https://github.com/git/git/releases/ | grep git/git/releases/tag | grep -v rc | head -n 1 | sed 's/^.*tag\///' | sed 's/".*//'); \
#    #" \
#    wget https://github.com/git/git/archive/${GIT_VERSION}.tar.gz -q -O- - | tar xz && \
#    cd git-* && \
#    make prefix=/usr/local all && \
#    make prefix=/usr/local install

# bat
RUN BAT_VERSION=$(curl --silent https://github.com/sharkdp/bat/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//'); \
    #" \
    wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb -q && \
        dpkg -i bat_${BAT_VERSION}_amd64.deb && \
        rm bat_${BAT_VERSION}_amd64.deb

# vifm
RUN VIFM_VERSION=$(curl --silent https://github.com/vifm/vifm/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//'); \
    #" \
    wget https://github.com/vifm/vifm/releases/download/v${VIFM_VERSION}/vifm-${VIFM_VERSION}.tar.bz2 -q -O- | \
        tar xjf - && \
        cd vifm-${VIFM_VERSION} && \
            ./configure --sysconfdir=/etc --silent && \
            make --silent && \
            make --silent install || echo "make install vifm failed" && \
        cd ..

# neovim
RUN curl --silent -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage; \
        chmod u+x nvim.appimage; \
        ./nvim.appimage --appimage-extract; \
        mkdir ~/.local/share/neovim -p; \
        mv /downloads/squashfs-root/* ~/.local/share/neovim; \
        rm /usr/bin/nvim; \
        ln -s ~/.local/share/neovim/AppRun /usr/bin/nvim; \
        ln -s ~/.local/share/neovim/AppRun /usr/bin/vim; \
        rm -rf /downloads;

# fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
        ~/.fzf/install --all

# zoxide
RUN curl --silent --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sed 's/sudo//g' | sh

# starship
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

# forgit
RUN git clone https://github.com/wfxr/forgit ~/.forgit

# vim plugged
RUN curl --silent -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# glow
RUN GLOW_VERSION=$(curl --silent https://github.com/charmbracelet/glow/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//'); \
    #" \
    wget https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_x86_64.tar.gz -q && \
        mkdir /downloads/glow && \
        tar -zxf glow_${GLOW_VERSION}_linux_x86_64.tar.gz --directory /downloads/glow && \
        mv /downloads/glow/glow /usr/bin/; \
        rm -rf /downloads;

# oh-my=zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null

# gitui
RUN GITUI_VERSION=$(curl --silent https://github.com/extrawurst/gitui/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//'); \
    # "\
    wget https://github.com/extrawurst/gitui/releases/download/v${GITUI_VERSION}/gitui-linux-musl.tar.gz -O- -q | tar -zxf - -C /usr/bin/

# fd-find
RUN FD_FIND_VERSION=$(curl --silent https://github.com/sharkdp/fd/releases/latest | tr -d '"' | sed 's/^.*tag\///g' | sed 's/>.*$//g' | sed 's/^v//'); \
    # "\
    wget https://github.com/sharkdp/fd/releases/download/v${FD_FIND_VERSION}/fd-v${FD_FIND_VERSION}-x86_64-unknown-linux-musl.tar.gz -O- -q | tar -zxf - -C /usr/bin/


# end manual installs

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install nodejs && \
    rm -rf /var/lib/apt/lists/*; \

RUN npm i -g diff-so-fancy && \
    npm i -g markserv; \
    npm i -g neovim; \
    npm i -g tree-sitter-cli; \
    rm -rf /root/.npm/_cacache;

RUN 

RUN chsh -s /usr/bin/zsh

# /usr/lib/ghc is a large directory,
# everything appears to work without it
# I dont fully understand what is in there,
# but it appears to be needed at build time.
# 

RUN python -m venv ~/.local/share/nvim/black; \
    ~/.local/share/nvim/black/bin/pip install -U -q --no-cache-dir --disable-pip-version-check black; \
    rm -rf /root/.cache/pip;


RUN wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.19.4/tree-sitter-linux-x64.gz; \
    gzip -d tree-sitter-linux-x64.gz; \
    chmod +x tree-sitter-linux-x64; \
    mv tree-sitter-linux-x64 /usr/bin/tree-sitter

RUN echo install lsp; \
    npm install -global bash-language-server@latest; \
    npm install --global vscode-css-languageserver-bin; \
    npm install --global dockerfile-language-server-nodejs@latest; \
    npm install --global vscode-html-languageserver-bin; \



RUN stow bin; \
    stow nvim; \
    stow zsh; \
    stow git; \
    stow ipython; \
    stow tmux; \


# install vim in order to run PlugInstall, neovim cannot run PlugInstall unattended
RUN echo "starting pluginstall step"; \
    # apt-get update; \
    # apt-get install -y --no-install-recommends vim; \
    # rm -rf /var/lib/apt/lists/*; \
    # cp ~/.config/nvim/plugins.vim ~/.vimrc; \
    npm i -g tree-sitter-cli; \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
    echo "running pluginstall"; \
    /usr/bin/nvim -u ~/.config/nvim/plugins.vim +PlugInstall +qall +enter +silent;\
    echo "running TSInstall "; \
    /usr/bin/nvim +TSUpdate "+TSInstall all" +Sleep +qall +enter +silent; \
    # rm ~/.vimrc; \
    # rm -rf ~/.vim; \
    # apt-get remove vim -y;

    # rm -rf /downloads; \
    # rm -rf /root/.cache/pip; \
    # rm -rf /usr/lib/ghc */; \
    echo "done with pluginstalls"


RUN chmod 0750 ~/.local/share/nvim/; \
    mkdir ~/.local/share/nvim/backup/; \
    mkdir ~/.local/share/nvim/swap/; \
    mkdir ~/.local/share/nvim/undo/;

WORKDIR /src

CMD ["tmux"]
