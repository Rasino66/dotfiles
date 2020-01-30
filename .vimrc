"-------基本設定--------
"色をつける
syntax enable
"ファイル形式の検出を有効化
filetype plugin indent on
"クリップボード連携
set clipboard=unnamedplus

"Scheme
colorscheme desert

"複数ファイルの編集を可能にする
set hidden

"カッコを閉じたとき対応するカッコに一時的に移動
set nostartofline

"内容が変更されたら自動的に再読み込み
set autoread

"----- Keymap ------
nnoremap ;  :
nnoremap :  ;
vnoremap ;  :
vnoremap :  ;

"-----Windowsのみ有効------
if has('win32')
    "パスのセパレータを変更(\->/)
    set shellslash
    "スペースの入ったファイル名も扱えるようにする
    set isfname+=32
endif

"-----Macのみ有効------
if has('gui_macvim')
endif
