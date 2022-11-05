"setting
"文字コードをUFT-8に設定
set fenc=utf-8
set encoding=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" (macでは不要だけど)BackSpace有効
set backspace=start,eol,indent

set ambiwidth=double

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=full
set wildmenu
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
"シンタックスに色をつける
syntax on
" スクロール時に数行余らせる
set scrolloff=3

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4
"ソフトタブを有効にする
set expandtab
" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
"重いスクロールの解決
set lazyredraw
" 挿入モード時はctrl+hjklで移動できるようにする
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
" emacsのようにctrl+aで先頭、ctrl+eで末尾に移動する
nnoremap <C-a> <Home>
nnoremap <C-e> <End>l
vnoremap <C-a> <Home>
vnoremap <C-e> <End>
" Tabでタブ移動
nnoremap <Tab> :tabn<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <C-t> :tabnew<CR>
" ノーマルモードで改行、バックスペース
nnoremap <CR> i<Return><Esc>
nnoremap <BS> i<BS><Esc>
" 挿入モードでも半ページスクロール
inoremap <C-u> <ESC><C-u>i
inoremap <C-d> <ESC><C-d>i

" 不可視文字を表示する
set list
set listchars=tab:»-,trail:-,eol:$,extends:»,precedes:«,nbsp:%

"jjでノーマルモードに
inoremap <silent> jj <ESC>
" 挿入モード時に点滅の縦棒タイプのカーソル
let &t_SI .= "\e[5 q"
" ノーマルモード時に点滅の矩形タイプのカーソル
let &t_EI .= "\e[1 q"

"左右のカーソル移動で行間移動可能にする。
set whichwrap+=b,s,h,l,<,>,[,]

" 最後にいたカーソルを記憶する
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

" 新しいウィンドウを右側で開く
set splitright

" space+lで行情報+不可視文字の表示/非表示
function! s:toggle_line_info()
  set invnumber
  set invlist
  GitGutterToggle
endfunction
command! LineInfoToggle call s:toggle_line_info()
nnoremap <Space>l :LineInfoToggle<CR>

"----------------------------------------
" vim-plug
"----------------------------------------
call plug#begin('~/.vim/plugged')
" colorschme
Plug 'w0ng/vim-hybrid'
Plug 'tomasr/molokai'
Plug 'dylnmc/novum.vim'
Plug 'mushanyoung/vim-windflower'

" others
Plug 'itchyny/lightline.vim'
Plug 'Townk/vim-autoclose'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'roxma/vim-paste-easy'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'dag/vim-fish'
call plug#end()

" インストール判定関数
function s:is_plugged(name)
  if exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
    return 1
  else
    return 0
  endif
endfunction

"----------------------------------------
" colorscheme
"----------------------------------------
if s:is_plugged("vim-hybrid") && has('unix')
  set background=dark
  colorscheme hybrid
  highlight LineNr ctermfg=lightgreen
endif

"----------------------------------------
" NERDTree
"----------------------------------------
if s:is_plugged("nerdtree")
  nmap <Space>n :NERDTreeTabsToggle<CR>
  let NERDTreeShowHidden = 1
  let g:NERDTreeWinSize = 48
  let NERDTreeMapOpenInTab='<ENTER>'
endif

"----------------------------------------
" fzf
"----------------------------------------
if s:is_plugged("fzf.vim")
  nmap <Space>o :GFiles<CR>
  nmap gs :GFiles?<CR>
  nmap <Space>f :Files<CR>
  nmap <Space>r :History<CR>
  nmap r :redo<CR>
endif
