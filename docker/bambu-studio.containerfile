FROM ghcr.io/ublue-os/arch-distrobox

RUN pacman -Syu --noconfirm
# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
WORKDIR /home/build
RUN paru -S --noconfirm bambustudio-bin
