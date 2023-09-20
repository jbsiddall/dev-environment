SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

docker run -it --rm \
    --mount type=bind,source=${SCRIPT_DIR}/neovim.lua,destination=/home/dev/.config/nvim/init.lua \
    --mount type=bind,source=${HOME}/.ssh,destination=/home/dev/.ssh,readonly \
    --mount type=bind,source=${HOME}/.gitconfig,destination=/home/dev/.gitconfig,readonly \
    --mount type=bind,source=${HOME}/Projects,destination=/home/dev/Projects \
    --mount type=volume,source=pnpm-store,destination=/pnpm-store \
    --mount type=bind,source=${SCRIPT_DIR}/vscode-server-config.yaml,destination=/home/dev/.config/code-server/config.yaml \
    --publish=8080:8080 --expose=8080 \
    --name=dev-environment \
    dev-environment zsh
