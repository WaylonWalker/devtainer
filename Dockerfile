FROM archlinux

RUN echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
    pacman --noconfirm -Syyu && \
    pacman --noconfirm -S base-devel git && \
    groupadd --gid 1000 devtainer && \
    useradd --uid 1000 --gid 1000 -m -r -s /bin/bash devtainer && \
    passwd -d devtainer && \
    echo 'devtainer ALL=(ALL) ALL' > /etc/sudoers.d/devtainer && \
    mkdir -p /home/devtainer/.gnupg && \
    echo 'standard-resolver' > /home/devtainer/.gnupg/dirmngr.conf && \
    chown -R devtainer:devtainer /home/devtainer && \
    mkdir /build && \
    chown -R devtainer:devtainer /build && \
    cd /build && \
    sudo -u devtainer git clone --depth 1 https://aur.archlinux.org/paru.git && \
    cd paru && \
    sudo -u devtainer makepkg --noconfirm -si && \
    sed -i 's/#RemoveMake/RemoveMake/g' /etc/paru.conf && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    rm -rf /home/devtainer/.cache && \
    rm -rf /build

USER devtainer

RUN sudo -u devtainer paru --noconfirm --skipreview --useask -S \
      bat \
      cargo \
      direnv \
      dua-cli \
      fd \
      github-cli \
      gitui \
      htop \
      # ijq-bin \
      lf-bin \
      linux-headers \
      lolcat \
      man-db \
      man-pages \
      neofetch \
      neovim-nightly-bin \
      neovim-plug-git \
      nvm-git \
      pyenv \
      ripgrep \
      starship \
      stow \
      the_silver_searcher \
      tldr \
      tmux \
      tree \
      unzip \
      viddy \
      zsh \
      zsh-autosuggestions \
      zsh-history-substring-search \
      zsh-syntax-highlighting \
      zsh-vi-mode-git

# workdir /home/devtainer/devtainer
RUN git clone https://github.com/waylonwalker/devtainer /home/devtainer/devtainer

# stow options, I can never remember these
# -d DIR, --dir=DIR     Set stow dir to DIR (default is current dir)
# -t DIR, --target=DIR  Set target to DIR (default is parent of stow dir)
# -S, --stow            Stow the package names that follow this option
RUN stow -d /home/devtainer/devtainer -t /home/devtainer --stow zsh tmux bin nvim
RUN nvim -u /home/devtainer/.config/nvim/plugins.vim +PlugInstall +qall
WORKDIR /home/devtainer


# COPY . /devtainer

# RUN pacman -Syu --noconfirm
# RUN pacman -S --needed base-devel --noconfirm
# RUN pacman -S git ansible rustup --noconfirm

# RUN useradd -ms /bin/bash -d /home/dockeruser dockeruser && passwd -d dockeruser
# USER dockeruser

# RUN rustup default stable

# RUN git clone https://aur.archlinux.org/paru.git /home/dockeruser/third-party/paru
# WORKDIR /home/dockeruser/third-party/paru
# RUN yes | makepkg -si
# RUN git clone https://github.com/waylonwalker/devtainer /home/dockeruser/devtainer

# RUN paru -S neovim --noconfirm

    # make it as the dockeruser otherwise it becomes owned by root
    # RUN mkdir /home/dockeruser/.local/share/nvim/site/autoload/ -p

    # ENV PATH="${PATH}:/home/dockeruser/.local/bin"
    # RUN pip3 install pipx
    # RUN pipx run --spec ansible ansible-playbook /devtainer/ansible/local.yml -t core

    # stow options, I can never remember these
    # -d DIR, --dir=DIR     Set stow dir to DIR (default is current dir)
    # -t DIR, --target=DIR  Set target to DIR (default is parent of stow dir)
    # -S, --stow            Stow the package names that follow this option
    # RUN stow -d /devtainer -t /home/dockeruser --stow zsh tmux bin nvim

    # RUN pipx run --spec ansible ansible-playbook /devtainer/ansible/local.yml -t "nvim, zsh"

# WORKDIR /home/dockeruser

CMD ["zsh"]

