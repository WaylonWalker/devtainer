FROM python:3.8-buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade && apt install sudo
RUN adduser --disabled-password --gecos '' dockeruser
RUN adduser dockeruser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dockeruser
COPY . /devtainer
workdir /devtainer

ENV PATH="${PATH}:/home/dockeruser/.local/bin"
RUN pip3 install pipx
RUN pipx run --spec ansible ansible-playbook /devtainer/ansible/local.yml -t core
RUN stow zsh
RUN stow tmux
RUN stow bin
RUN stow nvim
RUN pipx run --spec ansible ansible-playbook /home/dockeruser/devtainer/ansible/local.yml -t nvim
RUN pipx run --spec ansible ansible-playbook /home/dockeruser/devtainer/ansible/local.yml -t zsh

WORKDIR /home/dockeruser

CMD ["zsh"]

