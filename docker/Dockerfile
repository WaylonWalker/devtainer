From docker.io/python:3.11

ENV DOCKER_BUILD=true
ENV PATH="${PATH}:/root/.local/share/bob/nvim-bin"
ENV PATH="${PATH}:/root/.local/bin"
ENV PATH="${PATH}:/root/.local/share/nvim/mason/bin"
COPY installer /installer
RUN apt-get update && apt-get install -y --no-install-recommends \
    bat \
    cargo \
    curl \
    entr \
    fd-find \
    ffmpeg \
    fzf \
    g++ \
    gcc \
    git \
    golang \
    podman \
    ripgrep \
    sqlite3 \
    stow \
    tmux \
    unzip \
    vlc \
    xclip \
    zsh \
    ca-certificates && \
    mkdir ~/.local/bin -p && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    cd /root/.local/bin

WORKDIR  /usr/local/bin
RUN bash /installer/install.sh
# RUN cargo install fastmod

# installer does not work with the release format of ttyd
RUN curl --fail -# -L https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.x86_64 > /bin/ttyd && \
    chmod +x /bin/ttyd

RUN python -m pip install uv && \
    uv pip install \
        harlequin \
        ipython \
        lolcat \
        visidata \ 
        waylonwalker --system

RUN bob install nightly && \
    bob use nightly

RUN mkdir /root/downloads && \
    cd /root/downloads && \
    wget https://github.com/helix-editor/helix/releases/download/24.07/helix-24.07-x86_64-linux.tar.xz && \
    tar -xf helix-24.07-x86_64-linux.tar.xz && \
    mv helix-24.07-x86_64-linux/hx /usr/local/bin/hx && \
    mkdir -p /usr/local/share/helix/runtime && \
    mv helix-24.07-x86_64-linux/runtime/* /usr/local/share/helix/runtime/ && \
    cd .. && \
    rm -rf /root/downloads

# COPY kickstart.nvim /root/.config/nvim

# RUN git clone https://github.com/waylonwalker/kickstart.nvim ~/.config/nvim
COPY zsh /root/devtainer/zsh
COPY bin /root/devtainer/bin
COPY nvim /root/devtainer/nvim
COPY helix /root/devtainer/helix
WORKDIR /root/devtainer

RUN stow zsh
RUN stow bin -t /usr/local/bin
RUN stow nvim
RUN stow helix
# RUN stow lazyvim
# WORKDIR /root
# RUN curl -L https://bit.ly/n-install | bash -s -- -y lts
WORKDIR /root/util/
# RUN bash /installer/n.sh -y lts
# RUN curl -L https://bit.ly/n-install | bash -s -- -y lts
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs
ENV PATH="${PATH}:/root/n/bin"
RUN npm i -g tailwindcss

RUN nvim --headless "+Lazy! restore" +qa
RUN nvim --headless "+TSInstallSync! c cpp go lua python rust tsx javascript typescript vimdoc vim bash yaml toml vue" +qa
RUN nvim --headless "+MasonInstall lua-language-server rustywind ruff ruff-lsp html-lsp typescript-language-server beautysh fixjson isort markdownlint stylua yamlfmt python-lsp-server" +qa

RUN chsh -s $(which zsh)

RUN apt update && apt install -y chromium
# Expose port
RUN useradd -u 1976 -U -s /bin/false vhs
EXPOSE 1976
ENV VHS_PORT "1976"
ENV VHS_HOST "0.0.0.0"
ENV VHS_GID "1976"
ENV VHS_UID "1976"
ENV VHS_KEY_PATH "/vhs/vhs"
ENV VHS_AUTHORIZED_KEYS_PATH ""
ENV VHS_NO_SANDBOX "true"
ENV DOCKER_BUILD=
ENTRYPOINT ["zsh"]
