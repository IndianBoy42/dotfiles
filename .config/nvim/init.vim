" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'justinmk/vim-sneak'
"Plug 'easymotion/vim-easymotion'
Plug 'unblevable/quick-scope'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'liuchengxu/vim-which-key'

set clipboard=unnamedplus

" Initialize plugin system
call plug#end()

let g:sneak#label = 1
if has('mouse')
	set mouse=a
endif
set tabstop=4
set shiftwidth=4
set hlsearch
set incsearch
set smartindent

set ruler
syntax on

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

" let mapleader = " "
" nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
set timeoutlen=100

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END
