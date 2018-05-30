"
" My ${HOME}/.vimrc
" Marius Groleo <http://groleo.wordpress.com>
"               <groleo@gmail.com>
"

set nocompatible        "no backward compatible

if has("win32")
    set dir=f:\tmp\swp  "location to create swap files
else
    set dir=$HOME/.local/temp
endif

if has('gui_running')
    set guioptions=-m
    set guioptions=-M
    set guioptions=aA
    "if has("gui_gtk2")
    "    set guifont=Terminus\ 13
    "endif
endif

set t_Co=256
colorscheme groleo     "use my colorscheme
set encoding=utf-8

syntax on               "turn ON syntax highlight
filetype on             "enable filetype detection
filetype indent plugin on      "TODO
botright cwindow        "make quickfix-window always occupy the full width:


set ttymouse=xterm2     "Make vim work with 'tmux'
"set mouse-=a
"set mouse+=n
set mouse=a
set autoindent          "Copy indent from current line when starting a new line
set autowriteall        "buffers will be automatically written when abandoned
set backspace=indent,eol,start  "backspace over everything, when in insert mode
set comments=sl:/*,mb:*,elx:*/  "TODO
"insert, ctrl-v u UTFCODE
set fillchars=stl:\█,stlnc:\═,vert:\║
set hidden
set hlsearch            "highlight search matches
set ignorecase          "CaseSensytive OFF
set smartcase           "ignorecase+smartcase = if pattern contains upper, then useCase
set incsearch           "highlight search string as you type
set keymodel=startsel   "select start with a shifted key.
set laststatus=2        "when the last window will have statusline
set makeprg=make        "program to use for the ":make" command.
set nojoinspaces        "don't insert two spaces after .?! when joining lines TODO howto join
set nostartofline       "Remember the last position in Buffer
set nowrap              "turn OFF wrapping line
set number              "show lineNumbers
set ruler               "show cursor position in status bar
set shellpipe=2>&1\|\ cat\ >    "don't display text when using shellpipes
set shiftround          "round indent to multiple of 'shiftwidth'
set showmatch           "briefly jump to the matching bracket
set smartindent         "automatically insert indent in cmode
"set virtualedit=all     "let the cursor stray beyond the defined text
"set spell
"set cursorline
set visualbell          "replace the beep sounds, with visual bell
set vb t_vb=            "no bell and no visual bell (flashing)
set nowrapscan          "turn off search wrapping
set wildignore=CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
set wildmenu            "command-line completion operates in an enhanced mode
set nofsync             "play nice on laptops hdd
set splitright          "make the new window appear on the right.
set splitbelow          "make the new window appear below the current window.
set noequalalways       "don't resize after split
set list listchars=tab:\|-,trail:.,extends:>
set foldenable          "when off, all folds are open
set foldmethod=marker
set foldmarker={,}
set foldcolumn=0
let mapleader = "\\"
"set esckeys

set tags=./tags;/
autocmd FileType make set noexpandtab shiftwidth=8 " Use real tabs for Makefiles
let g:Tlist_Process_File_Always=1
let g:showmarks_enable=1
"let g:vimwiki_list = [{'path': '~/Documents/vimwiki/', 'path_html': '~/public_html/vimwiki','auto_export': 1}]
"let g:vimwiki_list = [{"path": '~/Documents/vimwiki/', 'path_html': '~/public_html/vimwiki', 'syntax': 'markdown', 'ext': '.mkd', 'custom_wiki2html': '~/.local/bin/md2html', 'auto_export': 1,"css_file": '~/public_html/vimwiki/pandoc.css'}]
let g:vimwiki_list = [{"path": '~/public_html/wiki/', 'syntax': 'markdown', 'ext': '.md.htm', 'template_path': '~/public_html/wiki/templates', }]
let &colorcolumn=80
" join(range(81,999),",")



set timeoutlen=1000 ttimeoutlen=0



" Bindings
"-------------------------------------
" Make shift-insert work like in Xterm
noremap  <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>
noremap  <F1> :sus<CR>
noremap! <F1> <esc>:sus<CR>a
noremap  <F2> :w!<CR>
noremap! <F2> <esc>:w!<CR>a
noremap  <F3> f{V%
noremap! <F3> <esc>:
set pastetoggle=<F4>
noremap  <F5> :call Make()<CR>
noremap! <F5> <esc>:call Make()<CR>i
noremap  <F6> :cn<CR>
noremap! <F6> <esc>:cn<CR>i

noremap  <F7>  :!xclip -f -sel clip<CR>
noremap  [18~  :!xclip -f -sel clip<CR>
"vmap <F7>  "*y
"vmap "+y :!xclip -f -sel clip
vmap [18~  "*y

"Copy to clipboard
noremap <F8> "+y

" Paste from clipboard
noremap <S-F8> "+gP
noremap [32~ "+gP
vmap <S-F8> <esc>"+gPi
vmap [32~ <esc>"+gPi


" Vimdiff bindings
"----------------------------------------
nnoremap <Leader>u :diffupdate<cr>
nnoremap <Leader>g :diffget<cr>
nnoremap <Leader>p :diffput<cr>

" Window bindings
"----------------------------------------
" Alt-s: horizontal split
inoremap <silent> s <C-O>:split<CR>
noremap <silent> s :split<CR>
inoremap <silent> <A-s> <C-O>:split<CR>
noremap <silent> <A-s> :split<CR>

" Alt-v: vertical split
inoremap <silent> v <C-O>:vsplit<CR>
noremap <silent> v :vsplit<CR>
inoremap <silent> <A-v> <C-O>:vsplit<CR>
noremap <silent> <A-v> :vsplit<CR>

" Alt-q: quit
inoremap <silent> q <C-O>:q<CR>
noremap <silent> q :q<CR>
inoremap <silent> <A-q> <C-O>:q<CR>
noremap <silent> <A-q> :q<CR>

" Alt-f: alternate file
inoremap <silent> f <C-O>:A
noremap <silent>  f :A<CR>

" below window
inoremap <silent> <A-Down> <C-O><C-W>j
noremap  <silent> <A-Down> <C-W>j
inoremap <silent> j      <C-O><C-W>w
noremap  <silent> j      <C-W>j

" right window
inoremap <silent> <A-l> <C-O><C-W>l
noremap  <silent> <A-l> <C-W>l
inoremap <silent> l   <C-O><C-W>l
noremap  <silent> l   <C-W>l

" left window
inoremap <silent> <A-h>   <C-O><C-W>h
noremap  <silent> <A-h>   <C-W>h
inoremap <silent> h     <C-O><C-W>h
noremap  <silent> h     <C-W>h


" window above
inoremap <silent> <A-Up> <C-O><C-W>k
noremap  <silent> <A-Up> <C-W>k
inoremap <silent> k    <C-O><C-W>W
noremap  <silent> k    <C-W>k

" Tabview
noremap <silent> <Leader>1 :tabn 1<CR>
noremap <silent> <Leader>2 :tabn 2<CR>
noremap <silent> <Leader>3 :tabn 3<CR>
noremap <silent> <Leader>4 :tabn 4<CR>
noremap <silent> <Leader>5 :tabn 5<CR>
noremap <silent> <Leader>6 :tabn 6<CR>
noremap <silent> <Leader>7 :tabn 7<CR>
noremap <silent> <Leader>8 :tabn 8<CR>
noremap <silent> <Leader>9 :tabn 9<CR>
noremap <silent> <Leader>0 :tabn 10<CR>


"inoremap <silent> OD <C-O>:tabprev<CR>a
"noremap <silent> OD :tabprev<CR>
"inoremap <silent> OC <C-O>:tabnext<CR>a
"noremap <silent> OC :tabnext<CR>

" CTAGS
"-------------------------------------
"C-] - go to definition
"C-T - Jump back from the definition.
"C-W C-] - Open the definition in a horizontal split
"C-\ - Open the definition in a new tab
"map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"A-] - Open the definition in a vertical split
map <C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map - :Explore<cr>
map <C-\> :exec("Doxf ".expand("<cword>"))<CR>
noremap ; :exec("Doxd ".expand("<cword>"))<CR>



" Match redundant whitspaces
highlight RedundantSpaces guibg=green ctermbg=green
match RedundantSpaces /\s\+$\| \+\ze\t/
"highlight Folded         cterm=standout ctermfg=4 ctermbg=248 guifg=#b0d0e0 guibg=#305060
"highlight FoldColumn     cterm=standout ctermfg=8 ctermbg=248 guifg=#b0d0e0 guibg=#305060



"-------------------------------------
"autocmd VimEnter * tab all
"autocmd BufAdd * exe 'tablast | tabe "' . expand( "<afile") .'"'
autocmd BufReadPre *.pdf set ro
autocmd BufReadPost *.pdf %!pdftotext -nopgbrk "%" -
autocmd BufReadPost * :DetectIndent

"autocmd BufWritePre *{.c,.cpp,.h,.hpp,.sh,.ini,Makefile}  call RemoveTrailingSpace() " Remove trailing spaces for C/C++ and Vim files

"function! SyntaxItem()
"  return synIDattr(synID(line("."),col("."),1),"name")
"endfunction
"set statusline=%1*%=\|%f\ %h%m%r\ %-5l,%-5c\ %P%1*
"set statusline+=%{SyntaxItem()}
"autocmd VimEnter * call ShowMarksOn()
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
"let Powerline_symbols = 'compatible'
"let g:Powerline_symbols = 'fancy'
"au BufRead,BufNewFile *.log set filetype=diver
"au! Syntax diver source /home/mariusn/.vim/syntax/diver.vim

" Set an orange cursor in Insert mode, and red cursor otherwise.
" Works at least for xterm and rxvt terminals
" Does not work at least for gnome terminal, konsole, xfce4-terminal
"if &cterm =~ "xterm\\|rxvt\\|screen"
"  :silent !echo -ne "\033]12;red\007"
"  let &t_SI = "\033]12;orange\007"
"  let &t_EI = "\033]12;red\007"
"  autocmd VimLeave * :!echo -ne "\033]12;red\007"
"endif
"highlight Cursor gui=reverse
"highlight iCursor gui=reverse
"set guicursor=n-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
"set guicursor+=n-v-c:blinkon0-Cursor
"set guicursor+=i:blinkwait20-iCursor


" Functions
"-------------------------------------
function! RemoveTrailingSpace()
    "if $VIM_HATE_SPACE_ERRORS != '0' &&
     " \(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
      normal! m`
      silent! :%s/\s\+$//e
      normal! ``
    "endif
endfunction

function! Make()
	if &filetype == 'stp'
		set makeprg=./stapify\ %
		" semantic error: while resolving probe point: identifier " 'process' at dvmCollectGarbage.stp:1:34
		let &efm  = 'semantic error: %m at %f:%l:%c'
	endif
	":silent! make
	make
	:copen 5
	:redr!
endfunction

" nice tab completion
function! InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
             return "\<tab>"
      else
             return "\<c-n>"
      endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

function! SoftTab(width)
      set expandtab           "use spaces instead of tabs
      "set softtabstop=a:width       "spaces to insert when <Tab> is pressed
      "Number of spaces that a <Tab> in the file counts for
       execute "set tabstop=".str2nr(a:width)
      "Number of spaces to use for each step of (auto)indent
       execute "set shiftwidth=".str2nr(a:width)
endfunction
function! HardTab(width)
      set noexpandtab
      "Number of spaces that a <Tab> in the file counts for
       execute "set tabstop=".str2nr(a:width)
      "Number of spaces to use for each step of (auto)indent
       execute "set shiftwidth=".str2nr(a:width)
       set cindent
endfunction
command! -bar -nargs=1 HardTab call HardTab(<q-args>)

function! DeleteHiddenBuffers()
		let tpbl=[]
		call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
		for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
		silent execute 'bwipeout!' buf
		endfor
endfunction

function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        let buflist = tabpagebuflist(i+1)
        let winnr = tabpagewinnr(i+1)
        let buffername = bufname(buflist[winnr-1])
        let filename = fnamemodify(buffername,':t')
        " check if there is no name
        if filename == ''
            let filename = 'No Name'
        endif
        " only show the first 6 letters of the name and
        " .. if the filename is more than 8 letters long
        "if strlen(filename) >=15
        "    let s .= (i+1).':'.filename[0:15]
        "else
            let s .= (i+1).':'.filename
        "endif
        let s .= '%#NONE#%#TabLineFill# %#NONE#'
    endfor
    " after the last tab fill with TabLineFill and reset tab page #
    let s .= '%#TabLineFill#%T'
    return s
endfunction
set tabline=%!MyTabLine()

if has('statusline')
  set statusline=
  set statusline+=%(%{Tlist_Get_Tagname_By_Line()}%)
  set statusline+=%*
  set statusline+=\ 
  set statusline+=%#DiffDelete#              " set highlighting
  set statusline+=%m                         " modified
  set statusline+=%*
  set statusline+=%#WarningMsg#              " set highlighting
  set statusline+=%t                         " file name tail
  set statusline+=%#Question#                " set highlighting
  set statusline+=\ 
  set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
  set statusline+=%{&fileformat}             " file format
  set statusline+=%*
  set statusline+=\ 
  set statusline+=0x%-8B\                    " character code under cursor
  set statusline+=%-7.(%l:%c,%o%V%)\ %<%P    " cursor position/offset
endif


function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction



let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1
let g:netrw_banner=0 
