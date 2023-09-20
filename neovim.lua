-- for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ABSOLUTELY IMPORTANT
-- this means any drop downs don't auto select the first item
vim.o.completeopt="menuone,noinsert,noselect"

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local was_packer_installed = ensure_packer()

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
      'David-Kunz/jester', -- jest runner for typescript
      config = function()
          require'jester'.setup {
              cmd = "pnpm test -t '$result' -- $file"
          }
      end
  }

  use {
    "ahmedkhalf/project.nvim",
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
        require("project_nvim").setup { }
        require('telescope').load_extension('projects')
    end
  }

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
    requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
  }

  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require('telescope').load_extension('file_browser')
    end
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
      'jbsiddall/nvim-notify',
      config = function()
          vim.opt.termguicolors = true
          local notify = require'notify'
          notify.setup {}
          vim.notify = function(message, level, opts)
              return notify(message, level, opts) -- <-- Important to return the value from `nvim-notify`
          end
      end
  }
  use {
      'dmmulroy/tsc.nvim',
      ft = 'typescript',
      after = 'nvim-notify',
      requires = {'nvim-notify'},
      config = function()
          require('tsc').setup {
              auto_open_qflist = false,
          }
      end
  }
  use {
    'mrded/nvim-lsp-notify',
    after = {'nvim-notify'},
    config = function()
        require('lsp-notify').setup {
            -- notify = require'notify'
        }
    end
  }

  use {
    'mfussenegger/nvim-lsp-compl',
    requires = {'neovim/nvim-lspconfig'},
    after = 'nvim-lspconfig',
    config = function()
        local lspconfig = require('lspconfig')
        local autocomplete = require('lsp_compl')
        lspconfig.tsserver.setup {
            capabilities = vim.tbl_deep_extend(
                'force',
                vim.lsp.protocol.make_client_capabilities(),
                autocomplete.capabilities()
            ),
            on_attach = function(client, bufnr)
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                autocomplete.attach(client, bufnr,  {
                    server_side_fuzzy_completion = false 
                })

            end
        }
    end
  }

  use {
      'neovim/nvim-lspconfig',
      opt = true,
      after = 'nvim-lsp-notify',
      ft = {'typescript'},
      config = function()

        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                -- vim.api.nvim_buf_set_option(ev.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
                -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gr', require'telescope.builtin'.lsp_references, opts)
                vim.keymap.set('n', '<space>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)
            end,
        })
        
      end,
  }
  use 'tpope/vim-fugitive'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
        'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
        require'nvim-tree'.setup {
            update_cwd = true,
            open_on_setup = true,
            open_on_setup_file = true,

            diagnostics = {
                enable = true
            },
            modified = {
                enable = true,
            },
            filters = {
                dotfiles = false,
                git_ignored = false,
            },
        }
    end,
  }
  
  -- use {
  --     'https://github.com/scrooloose/nerdtree',
  --     config = function()
  --       vim.g.NERDTreeIgnore = {
  --           [[\.pyc$]],
  --           "node_modules$",
  --       }
  --     end,
  -- }

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

  use 'itchyny/lightline.vim'  -- pretty status line
  use 'airblade/vim-gitgutter'  -- shows git line changes in gutter
  use 'rbgrouleff/bclose.vim'


end)

vim.g.mapleader = " "
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

local VIM_CONFIG_PATH = "/home/dev/.config/nvim/init.lua"

vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = {VIM_CONFIG_PATH},
    group = AU_GROUP,
    callback = function(ctx)
        vim.api.nvim_command("source " .. ctx.file)
        local packer = require('packer')
        packer.sync()
    end,
})

if was_packer_installed then
    require('packer').sync()
end

vim.cmd('badd ' .. VIM_CONFIG_PATH)
