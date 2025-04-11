From docker.io/ubuntu:24.04

ENV DOCKER_BUILD=1
ENV PATH="${PATH}:/root/.local/share/bob/nvim-bin"
ENV PATH="${PATH}:/root/.local/bin"
ENV PATH="${PATH}:/root/.local/share/nvim/mason/bin"
ENV PATH="${PATH}:/root/n/bin"
ENV PATH="${PATH}:/root/devtainer/one-shot-apps"
COPY installer /installer
RUN apt-get update && apt-get install -y --no-install-recommends \
    bat \
    ca-certificates \
    cargo \
    chromium-browser \
    curl \
    entr \
    fd-find \
    ffmpeg \
    fzf \
    g++ \
    gcc \
    git \
    golang \
    libbz2-dev \
    libc6-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    make \
    pciutils \
    podman \
    ripgrep \
    sqlite3 \
    stow \
    tmux \
    unzip \
    vlc \
    xclip \
    zlib1g-dev \
    zsh \
    && \
    mkdir ~/.local/bin -p && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    cd /root/.local/bin

WORKDIR  /usr/local/bin
RUN bash /installer/install.sh
# RUN cargo install fastmod

RUN apt-get update && apt-get install -y --no-install-recommends windsurf && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# installer does not work with the release format of ttyd
RUN curl --fail -# -L https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.x86_64 > /bin/ttyd && \
    chmod +x /bin/ttyd

ENV PATH="/root/.venv/bin:$PATH"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv python install 3.10 3.11 3.12 && \
    uv venv /root/.venv --python 3.11 && \
    uv tool install harlequin && \
    uv tool install ipython && \
    uv tool install lolcat && \
    uv tool install visidata && \
    uv tool install waylonwalker

RUN bob install v0.10.3 && \
    bob install v0.10.4 && \
    bob install v0.11.0 && \
    bob use v0.10.3

RUN mkdir /root/downloads && \
    cd /root/downloads && \
    apt-get update && apt-get install -y --no-install-recommends wget && \
    rm -rf /var/lib/apt/lists/* && \
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
COPY one-shot-apps /root/devtainer/one-shot-apps
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
RUN node -v && \
    npm -v && \  # Verify the installation
    mkdir -p /usr/local/share/.npm-global && \
    npm config set prefix /usr/local/share/.npm-global
RUN /bin/npm i -g tailwindcss

RUN nvim --headless "+Lazy! restore" +qa
RUN nvim --headless "+TSInstallSync! c cpp go lua python rust tsx javascript typescript vimdoc vim bash yaml toml vue" +qa
RUN nvim --headless "+MasonInstall lua-language-server rustywind ruff ruff-lsp html-lsp typescript-language-server beautysh fixjson isort markdownlint stylua yamlfmt python-lsp-server" +qa

RUN chsh -s $(which zsh)

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
