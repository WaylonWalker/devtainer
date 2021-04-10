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

COPY dotfiles/ $HOME
COPY install.sh $HOME

RUN source $HOME/install.sh; \
    install_main; \
    # rm -rf /downloads; \
    # rm -rf /root/.npm/_cacache; \
    # rm -rf /root/.cache/pip; \
    # rm -rf /usr/lib/ghc */; \
    # chmod 0750 ~/.local/share/nvim/; \
    # mkdir ~/.local/share/nvim/backup/; \
    # mkdir ~/.local/share/nvim/swap/; \
    # mkdir ~/.local/share/nvim/undo/; \
    echo done;

WORKDIR /src

CMD ["tmux"]
