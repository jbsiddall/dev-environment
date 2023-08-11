-- equivalent of call plug#begin()
--
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    "folke/which-key.nvim",
    config = function()
    vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup { }
    end
  }


  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
   'phaazon/hop.nvim',
    branch = 'v2', -- optional bu
    config = function()
      local hop = require('hop')
      hop.setup {}

      local directions = require('hop.hint').HintDirection
      vim.keymap.set('n', 'f', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
      end, {remap=true})
      vim.keymap.set('n', 'F', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
      end, {remap=true})
      vim.keymap.set('n', 't', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
      end, {remap=true})
      vim.keymap.set('n', 'T', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
      end, {remap=true})
    end,
  }

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
  use {
      'https://github.com/scrooloose/nerdtree',
      config = function()
        vim.g.NERDTreeIgnore = {
            [[\.pyc$]],
            "node_modules$",
        }
      end,
  }

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

  use {
    'https://github.com/kien/ctrlp.vim',
    config = function()
        vim.g.ctrlp_working_path_mode = 'rc'
        vim.g.ctrlp_use_caching = 1
        vim.g.ctrlp_clear_cache_on_exit = 1
        vim.g.ctrlp_show_hidden = 1
        vim.g.ctrlp_custom_ignore = 'node_modules\\|git\\|venv\\|.*.pyc'
    end,
  }

  use 'itchyny/lightline.vim'  -- pretty status line
  use 'airblade/vim-gitgutter'  -- shows git line changes in gutter
  use 'rbgrouleff/bclose.vim'
end)

local AU_GROUP = "siddall-nvim-config"
vim.api.nvim_create_augroup(AU_GROUP, {})

vim.g.NERDTreeBookmarksFile = "$HOME/.config/nvim/nerdtree-bookmarks.txt"

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

vim.o.shell = "/bin/zsh"

-- editor preferences
-- vim.opt.colorcolumn = "120"
vim.opt.number = true

-- equivalent of autocmd BufReadPre,FileReadPre * :set rnu
vim.api.nvim_create_autocmd({"BufReadPre","FileReadPre"}, {
    group = AU_GROUP,
    command = "set rnu"
})

-- indentation
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.g.editorconfig = true


vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = {"init.lua"},
    group = AU_GROUP,
    callback = function(ctx)
        if ctx.file ~= "/home/dev/.config/nvim/init.lua" then
	    print('sad', ctx.file)
            return
	end
        vim.api.nvim_command("source " .. ctx.file)
        local packer = require('packer')
        packer.sync()
    end,
})
