call plug#begin()
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/gosukiwi/vim-atom-dark'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
call plug#end()

let mapleader=" "

" move line down
nnoremap <leader>j ddp

" move line up
nnoremap <leader>k ddkP

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" jk for escape key, disables c-c, c-[
inoremap jk <esc>
inoremap <c-c> <nop>
inoremap <c-[> <nop>

" replaces : with ;
nnoremap ; :
nnoremap : <nop>

syntax on
filetype plugin indent on

" editor preferences
set colorcolumn=120
set nu
let g:ctrlp_working_path_mode = 'w'
let g:ctrlp_use_caching = 0

autocmd BufReadPre,FileReadPre * :set rnu

" indentation
set shiftwidth=4
set shiftround
set tabstop=4
set expandtab

:autocmd FileType html call SetHtmlOptions()

function! SetHtmlOptions()
    set shiftwidth=2
    set tabstop=2
endfunction

function! SetJavascriptOptions()
    set shiftwidth=4
    set tabstop=4
    set expandtab
endfunction

:autocmd FileType javascript call SetJavascriptOptions()


colorscheme atom-dark


" ctrlp: regex to ignore directories
let g:ctrlp_custom_ignore = 'node_modules\|git'
