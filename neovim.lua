-- equivalent of call plug#begin()
--
vim.cmd [[packadd packer.nvim]]

      
-- local myTheme = 'https://github.com/gosukiwi/vim-atom-dark'
local myTheme = "folke/tokyonight.nvim"


require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
      'neovim/nvim-lspconfig',
      opt = true,
      ft = {'typescript'},
      config = function()
        local lspconfig = require('lspconfig')
        lspconfig.tsserver.setup {}
      end,
  }
  use 'tpope/vim-fugitive'
  use 'https://github.com/scrooloose/nerdtree'

  use {
      "https://github.com/folke/tokyonight.nvim",
      config = function()
        vim.api.nvim_command('set background=dark')
        vim.api.nvim_command('colorscheme tokyonight-moon')
        -- vim.api.nvim_command("colorscheme atom-dark-256")
      end,
  }

  use {
      'https://github.com/gosukiwi/vim-atom-dark',
      config = function()
        -- vim.api.nvim_command("colorscheme atom-dark-256")
      end,
  }

  use 'https://github.com/kien/ctrlp.vim'
  use 'itchyny/lightline.vim'  -- pretty status line
  use 'airblade/vim-gitgutter'  -- shows git line changes in gutter
  use 'rbgrouleff/bclose.vim'
end)

-- lspconfig.tsserver.setup {}
    -- on_attach = on_attach,
    -- filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    -- cms = { "typescript-language-server", "--stdio" }

-- asdfasdfa  vim.g.mapleader=" "

-- move line down
-- vim.api.nvim_set_keymap('n', '<leader>j', 'ddp', {})

-- move line up
-- vim.api.nvim_set_keymap('n', '<leader>k', 'ddkP', {})

-- vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<cr>', {})
-- vim.api.nvim_set_keymap('n', '<leader>sv', ':source $MYVIMRC<cr>', {})

-- jk for escape key, disables c-c, c-[
-- vim.api.nvim_set_keymap('i', 'jk', '<esc>', {})
-- vim.api.nvim_set_keymap('i', '<c-c>', '<nop>', {})
-- vim.api.nvim_set_keymap('i', '<c-[>', '<nop>', {})




-- replaces : with ;
-- vim.api.nvim_set_keymap('n', ';', ':', {})
-- vim.api.nvim_set_keymap('n', ':', '<nop>', {})

-- equivalent of syntax on
vim.cmd [[syntax on]]
-- equivalent of filetype plugin indent on
vim.cmd [[filetype plugin indent on]]

-- editor preferences
vim.opt.colorcolumn = "120"
vim.opt.number = true
vim.g.ctrlp_working_path_mode = 'w'
vim.g.ctrlp_use_caching = 1
vim.g.ctrlp_clear_cache_on_exit = 1
vim.g.ctrlp_custom_ignore = 'node_modules\\|git\\|venv\\|.*.pyc'

-- equivalent of autocmd BufReadPre,FileReadPre * :set rnu
vim.cmd [[autocmd BufReadPre,FileReadPre * :set rnu]]

-- indentation
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.g.NERDTreeIgnore = {[[\.pyc$]]}

