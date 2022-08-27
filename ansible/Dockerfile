FROM python:3.10-buster

RUN pip3 install ansible
RUN apt update && apt install sudo

# RUN useradd -ms /bin/bash dockeruser
# RUN usermod -aG sudo dockeruser
RUN adduser --disabled-password --gecos '' dockeruser
RUN adduser dockeruser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dockeruser
RUN mkdir /home/dockeruser/ansible
WORKDIR /home/dockeruser
