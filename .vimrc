" Basic {{{1
"==============================================================================
" encoding
set encoding=utf-8
" file encofing
set fileencodings=utf-8,euc-jp,sjis,cp932,iso-2022-jp
"色をつける
syntax enable
"Scheme
colorscheme desert
"ファイル形式の検出を有効化
filetype plugin indent on
"クリップボード連携
set clipboard=unnamedplus
"複数ファイルの編集を可能にする
set hidden
" Status line
set laststatus=2
" Cursor line
set cursorline
" Tab setting
  " Expand TAB to Space
set expandtab
  " TAB characters that appear 2-Spaces-wide 
set tabstop=2
  " TAB characters(auto indent) that appear 2-Spaces-wide 
set shiftwidth=2
  " Sets the number of columns for a TAB
set softtabstop=2
  " Auto indent on
set autoindent
set smartindent
"vimfilter <- netrw
let g:vimfiler_as_default_explorer = 1
" Windowsのみ有効 ====
if has('win32')
  "パスのセパレータを変更(\->/)
  set shellslash
  "スペースの入ったファイル名も扱えるようにする
  set isfname+=32
endif

" Macのみ有効 -====
if has('gui_macvim')
endif
"==========================================================================}}}1
"
" Plugins {{{1
"==============================================================================
" plug install
let s:vim_plug_url='https://github.com/junegunn/vim-plug'

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" 実際の呼ぶ処理
call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
"submod関連 keymap
Plug 'kana/vim-submode'
"vimFile 関連
Plug 'shougo/unite.vim'
Plug 'shougo/vimfiler.vim'
call plug#end()
"==========================================================================}}}1
"
" Keymap {{{1
"==============================================================================
" Change ; & :
noremap ;  :
noremap :  ;
" Reload vimrc
nnoremap <F5> :<C-u>source $MYVIMRC<CR>
" Open vimrc
nnoremap <F4> :<C-u>tabedit $MYVIMRC<CR>

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')
"==========================================================================}}}1
"
" Default {{{1
"==============================================================================
"==========================================================================}}}1
