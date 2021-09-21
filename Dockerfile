FROM python:3.8-buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade && apt install sudo
RUN adduser --disabled-password --gecos '' dockeruser
RUN adduser dockeruser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dockeruser
COPY . /devtainer
workdir /devtainer

# make it as the dockeruser otherwise it becomes owned by root
RUN mkdir ~/.local/share/nvim/site/autoload/ -p

ENV PATH="${PATH}:/home/dockeruser/.local/bin"
RUN pip3 install pipx
RUN pipx run --spec ansible ansible-playbook /devtainer/ansible/local.yml -t core

# stow options, I can never remember these
# -d DIR, --dir=DIR     Set stow dir to DIR (default is current dir)
# -t DIR, --target=DIR  Set target to DIR (default is parent of stow dir)
# -S, --stow            Stow the package names that follow this option
RUN stow -d /devtainer -t /home/dockeruser --stow zsh tmux bin nvim

RUN pipx run --spec ansible ansible-playbook /devtainer/ansible/local.yml -t "nvim, zsh"

WORKDIR /home/dockeruser

CMD ["zsh"]

