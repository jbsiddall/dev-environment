SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

docker run -it --rm \
    --mount type=bind,source=${SCRIPT_DIR}/neovim.lua,destination=/home/dev/.config/nvim/init.lua \
    --mount type=bind,source=${HOME}/.ssh,destination=/home/dev/.ssh,readonly \
    --mount type=bind,source=${HOME}/.gitconfig,destination=/home/dev/.gitconfig,readonly \
    --mount type=bind,source=${HOME}/Projects,destination=/home/dev/Projects \
    --mount type=volume,source=pnpm-store,destination=/pnpm-store \
    dev-environment zsh
