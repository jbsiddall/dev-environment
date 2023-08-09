#! env zsh

set -su

docker run -it --rm \
    -v ./neovim.lua:/home/dev/.config/nvim/init.lua \
    --mount type=bind,source=${HOME}/.ssh,destination=/home/dev/.ssh,readonly \
    --mount type=bind,source=${HOME}/.gitconfig,destination=/home/dev/.gitconfig,readonly \
    -v ~/Projects:/home/dev/Projects \
    dev-environment
