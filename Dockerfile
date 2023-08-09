FROM archlinux as dev
RUN pacman -Syy
RUN pacman --noconfirm -Su
RUN useradd -ms /bin/bash newuser
RUN pacman -Sy --noconfirm neovim git base-devel
RUN pacman -Sy --noconfirm sudo
RUN pacman -Sy --noconfirm openssh


RUN echo 'root:helloroot' | chpasswd
RUN useradd -m dev
RUN echo 'dev:hellodev' | chpasswd
COPY ./sudoers /etc/sudoers

USER dev
WORKDIR /home/dev
RUN mkdir -p /home/dev/.config/nvim
RUN git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

RUN git clone https://aur.archlinux.org/nvim-packer-git.git && cd nvim-packer-git && makepkg -si --noconfirm


FROM dev as typescript-dev
RUN sudo pacman -Sy --noconfirm nodejs
RUN sudo corepack enable
RUN sudo yarn global add typescript typescript-language-server
