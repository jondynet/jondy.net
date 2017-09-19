" 设置字体 以及中文支持
if has("win32")
    set guifont=Inconsolata:h12:cANSI
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif

if has("gui_running")
    "au GUIEnter * simalt ~x " 窗口启动时自动最大化
    set guioptions-=m " 隐藏菜单栏
    set guioptions-=T " 隐藏工具栏
    set guioptions-=L " 隐藏左侧滚动条
    set guioptions-=r " 隐藏右侧滚动条
    set guioptions-=b " 隐藏底部滚动条
    "set showtabline=0 " 隐藏Tab栏
endif

" 配置多语言环境
if has("multi_byte")
" UTF-8 编码
    set encoding=utf-8
    set termencoding=utf-8
    set formatoptions+=mM
    set fencs=utf-8,gbk
endif

if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif

syntax on

" 色彩主题
colo pablo
if $TERM == "xterm-256color"
  set t_Co=256 " 256 色
else
  colorscheme desert
endif

" 关闭兼容模式
set nocompatible
" 开启魔法匹配
set magic
" 退格键行为
set backspace=indent,eol,start
" 右下角显示标尺
set ruler
" 编码设置
set fileencodings=ucs-bom,utf-8,gbk
set fileformats=unix,dos,mac

" 缩进设置
set list lcs=tab:\¦\ 
" set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
" 前端2格缩进
" au BufNewFile,BufRead *.js, *.html, *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
" 自动缩进
set autoindent
set smartindent
" Enable folding
set foldmethod=indent
set foldlevel=99

" 高亮括号对
set showmatch
" 高亮搜索
set hlsearch
" 状态栏显示键入的命令
set showcmd
" 不创建备份文件
set nobackup
" 高亮当前行
set cursorline
" 智能大小写判断
set ignorecase smartcase
" 语法高亮
syntax on
" 打开文件类型支持
filetype plugin indent on
" 递归向上查找 tags
set tags=tags;
" 修复 Terminal 下面中文双引号的问题
set ambiwidth=double

" 即时搜索
set incsearch

" 永远显示状态栏
set laststatus=2

" undo dir
if v:version >= 703
  set undodir=$HOME/.vimundodir
  set undofile
endif

" 最后更新时间 Last modified: <datetime>
autocmd BufWritePre,FileWritePre *.py   ks|call LastMod()|'s
fun LastMod()
    if line("$") > 10
        let l = 10
    else
        let l = line("$")
    endif
    exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: " .
        \ strftime("%Y-%m-%d %H:%I:%S")
endfun

" pelican 博客头部处理
autocmd BufWritePre,FileWritePre *.md   ks|call Pelican()|'s
fun Pelican()
    if line("$") > 10
        let l = 10
    else
        let l = line("$")
    endif
    exe "1," . l . "g/Modified: /s/Modified: .*/Modified: " .
        \ strftime("%Y-%m-%d %H:%I:%S")
endfun

" 启动代码折叠
set fdm=indent
