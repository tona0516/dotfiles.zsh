# image settings
FROM ubuntu:22.04
LABEL maintainer="tona0516 <tonango.0516@gmail.com>"

# variables
ARG USERNAME="tona0516"
ARG PASSWORD="123"

# package settings
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install sudo zsh git vim curl zip make language-pack-ja-base language-pack-ja locales

# user settings
RUN useradd -m ${USERNAME} && echo "${USERNAME}:${PASSWORD}" | chpasswd && adduser ${USERNAME} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# locale settings
RUN locale-gen ja_JP.UTF-8
RUN echo "export LANG=ja_JP.UTF-8" >> /home/${USERNAME}/.profile

USER ${USERNAME}
WORKDIR /home/${USERNAME}
