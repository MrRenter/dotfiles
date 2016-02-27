set nocompatible              " be iMproved, required
filetype off                  " required

    " highlighting
  set relativenumber
syntax on
set background=dark
set cursorline
let mapleader = ','
let g:mapleader = ','
set invlist
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
nmap <leader>l :set list!<cr>
highlight SpecialKey ctermbg=none " make the highlighting of tabs less annoying


" tabbing
set expandtab
set shiftwidth=2
set softtabstop=2

" folding settings
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

set laststatus=1
set t_Co=256
set backspace=2

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Bundle 'Powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'ervandew/supertab'
Plugin 'tomtom/tcomment_vim'
Plugin 'walm/jshint.vim'
execute pathogen#infect()

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Powerline
set laststatus=2
set rtp+={~/.vim/bundle/powerline/powerline/bindings/vim}
set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\

"nerdtree
let g:NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
nmap <silent><leader>k :NERDTreeToggle<cr>
nmap <silent><leader>t :CtrlP<cr>
inoremap {<CR> {<CR>}<C-o>O
nnoremap <Leader>c iconsole.log(<Esc>A);
map <F9> :w<CR>:!clear;node %<CR>
map <F10> :w<CR>:JSHint<CR>
colorscheme delek
