FROM archlinux as dev
RUN pacman -Syy
RUN pacman --noconfirm -Su
RUN useradd -ms /bin/bash newuser
RUN pacman -Sy --noconfirm neovim git base-devel sudo openssh zsh \
    ripgrep fd # needed for nvim telescope

RUN echo 'root:helloroot' | chpasswd
RUN useradd -m dev
RUN echo 'dev:hellodev' | chpasswd
RUN chsh -s /bin/zsh dev
COPY ./sudoers /etc/sudoers

RUN mkdir /pnpm-store && chown dev /pnpm-store

USER dev
WORKDIR /home/dev
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN mkdir -p /home/dev/.config/nvim

# RUN git clone https://aur.archlinux.org/nvim-packer-git.git && cd nvim-packer-git && makepkg -si --noconfirm


FROM dev as typescript-dev
RUN sudo pacman -Sy --noconfirm nodejs
RUN sudo corepack enable
RUN sudo yarn global add typescript typescript-language-server
