FROM docker.io/ubuntu:24.04

ENV DOCKER_BUILD=1
ENV PATH="/root/.local/bin:/root/.local/share/mise/shims:/root/.local/share/mise/bin:/root/.local/share/nvim/mason/bin:/root/devtainer/one-shot-apps:${PATH}"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bat \
    ca-certificates \
    chromium-browser \
    curl \
    entr \
    ffmpeg \
    g++ \
    gcc \
    git \
    golang \
    gpg \
    gpg-agent \
    kitty-terminfo \
    libbz2-dev \
    libc6-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    make \
    ncurses-bin \
    ncurses-term \
    neovim \
    nodejs \
    npm \
    pciutils \
    podman \
    python3 \
    python3-venv \
    sqlite3 \
    stow \
    tar \
    unzip \
    vlc \
    wl-clipboard \
    xclip \
    xz-utils \
    zlib1g-dev \
    zsh && \
    useradd --create-home --shell /usr/bin/zsh devtainer && \
    mkdir -p /root/.local/bin /root/devtainer /home/devtainer/.local/bin /home/devtainer/.local/share && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN curl -fsSL https://mise.run | sh

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# installer does not work with the release format of ttyd
RUN curl --fail -# -L https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.x86_64 > /bin/ttyd && \
    chmod +x /bin/ttyd

RUN mkdir /root/downloads && \
    cd /root/downloads && \
    curl -fsSLO https://github.com/helix-editor/helix/releases/download/24.07/helix-24.07-x86_64-linux.tar.xz && \
    tar -xf helix-24.07-x86_64-linux.tar.xz && \
    mv helix-24.07-x86_64-linux/hx /usr/local/bin/hx && \
    mkdir -p /usr/local/share/helix/runtime && \
    mv helix-24.07-x86_64-linux/runtime/* /usr/local/share/helix/runtime/ && \
    cd /root && \
    rm -rf /root/downloads

COPY zsh /root/devtainer/zsh
COPY tmux /root/devtainer/tmux
COPY bin /root/devtainer/bin
COPY one-shot-apps /root/devtainer/one-shot-apps
COPY nvim /root/devtainer/nvim
COPY helix /root/devtainer/helix
COPY mise /root/devtainer/mise
COPY cmd /root/devtainer/cmd
COPY go.mod /root/devtainer/go.mod
COPY go.sum /root/devtainer/go.sum

WORKDIR /root/devtainer

RUN go build -ldflags "-X main.version=$(git describe --tags --always --dirty 2>/dev/null || echo dev)" -o /usr/local/bin/devtainer ./cmd/devtainer

RUN mkdir -p /opt/devtainer-home && \
    cp -a zsh tmux bin one-shot-apps nvim helix mise /opt/devtainer-home/ && \
    chmod -R a+rX /opt/devtainer-home && \
    stow -d /opt/devtainer-home -t /home/devtainer zsh && \
    stow -d /opt/devtainer-home -t /home/devtainer tmux && \
    stow -d /opt/devtainer-home -t /home/devtainer nvim && \
    stow -d /opt/devtainer-home -t /home/devtainer helix && \
    stow -d /opt/devtainer-home -t /home/devtainer mise && \
    install -m 755 /opt/devtainer-home/bin/.local/bin/devtainer-bootstrap-home /usr/local/bin/devtainer-bootstrap-home && \
    chown -R devtainer:devtainer /home/devtainer

RUN --mount=type=secret,id=gh_token \
    export MISE_GITHUB_TOKEN="$(cat /run/secrets/gh_token)" && \
    mise install && \
    mise x -- npm install -g tailwindcss && \
    mise x -- uv tool install podman-compose && \
    mise x -- uv tool install harlequin && \
    mise x -- uv tool install ipython && \
    mise x -- uv tool install lolcat && \
    mise x -- uv tool install visidata && \
    mise x -- uv tool install waylonwalker

RUN mise x -- nvim --headless "+Lazy! restore" +qa
RUN mise x -- nvim --headless "+TSInstallSync! c cpp go lua python rust tsx javascript typescript vimdoc vim bash yaml toml vue" +qa
RUN mise x -- nvim --headless "+MasonInstall lua-language-server rustywind ruff html-lsp typescript-language-server beautysh fixjson isort markdownlint stylua yamlfmt python-lsp-server" +qa
RUN rm -rf /home/devtainer/.local/share/mise && \
    cp -a /root/.local/share/mise /home/devtainer/.local/share/mise && \
    chown -R devtainer:devtainer /home/devtainer/.local/share/mise

RUN useradd -u 1976 -U -s /bin/false vhs

EXPOSE 1976
ENV VHS_PORT="1976"
ENV VHS_HOST="0.0.0.0"
ENV VHS_GID="1976"
ENV VHS_UID="1976"
ENV VHS_KEY_PATH="/vhs/vhs"
ENV VHS_AUTHORIZED_KEYS_PATH=""
ENV VHS_NO_SANDBOX="true"
ENV DOCKER_BUILD=
ENV HOME="/home/devtainer"
ENV USER="devtainer"
ENV PATH="/home/devtainer/.local/bin:/home/devtainer/.local/share/mise/shims:/home/devtainer/.local/share/mise/bin:/home/devtainer/.local/share/nvim/mason/bin:/opt/devtainer-home/one-shot-apps:${PATH}"

USER devtainer
WORKDIR /home/devtainer
ENTRYPOINT ["zsh"]
