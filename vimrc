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
    if has("gui_gtk2")
        set guifont=Terminus\ 13
    endif
endif

set t_Co=256
set encoding=utf-8

colorscheme groleo     "use my colorscheme
syntax on               "turn ON syntax highlight
filetype on             "enable filetype detection
filetype plugin on      "TODO
botright cwindow        "make quickfix-window always occupy the full width:


"set ttymouse=xterm2     "Make vim work with 'tmux'
set mouse-=a
set mouse+=n
set autoindent          "Copy indent from current line when starting a new line t
set autowriteall        "buffers will be automatically written when abandoned
set backspace=indent,eol,start  "backspace over everything, when in insert mode
set comments=sl:/*,mb:*,elx:*/  "TODO
"insert, ctrl-v u UTFCODE
set fillchars=stl:^,stlnc:.,vert:\║
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
let mapleader = "\\"


" Bindings
"-------------------------------------
" Make shift-insert work like in Xterm
map  <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
map  <F2> :w<CR>
map! <F2> <esc>:w<CR>a
map  <F3> :
map! <F3> <esc>:
set pastetoggle=<F4>
map  <F5> :call Make()<CR>
map! <F5> <esc>:call Make()<CR>i
map  [18~  :silent w !xclip<CR><CR>
vmap [18~  "*y
map  <F6> :cn<CR>
map! <F6> <esc>:cn<CR>i
map  <F7>  :silent w !xclip<CR><CR>
vmap <F7>  "*y
"Copy to clipboard
map <F8> "+y
" Paste from clipboard
map <S-F8> "+gP
map!<S-F8> <esc>"+gPi


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

" Alt-v: vertical split
inoremap <silent> v <C-O>:vsplit<CR>
noremap <silent> v :vsplit<CR>

" Alt-q: quit
inoremap <silent> q <C-O>:q<CR>
noremap <silent> q :q<CR>

" Alt-f: alternate file
inoremap <silent>f <C-O>:A
noremap <silent>f  :A<CR>

" below window
inoremap <silent> <A-Down> <C-O><C-W>j
noremap <silent> <A-Down> <C-W>j
inoremap <silent> [1;3B <C-O><C-W>w
noremap <silent> [1;3B <C-W>j

" right window
inoremap <silent> <A-Right> <C-O><C-W>l
noremap <silent> <A-Right> <C-W>l
inoremap <silent> [1;3C  <C-O><C-W>l
noremap <silent> [1;3C <C-W>l

" left window
inoremap <silent> <A-Left> <C-O><C-W>h
noremap <silent> <A-Left> <C-W>h
inoremap <silent> [1;3D <C-O><C-W>h
noremap <silent> [1;3D <C-W>h

" window above
inoremap <silent> <A-Up> <C-O><C-W>k
noremap <silent> <A-Up> <C-W>k
inoremap <silent> [1;3A <C-O><C-W>W
noremap <silent> [1;3A <C-W>k

" Tabview
inoremap <silent> <C-1> <C-O>:tabn 1<CR>a


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
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"A-] - Open the definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set tags=./tags;/
"inoremap <Nul> <C-x><C-o>
map - :Explore<cr>



"------------------------------------
" Highlight the 80th column so that you know
if has('autocmd')
   " Do not highlight the character if it is a:
   "      <>[]{}()"':
   " since that messes up the syntax highlighting for the file
   let rightMargin = 'au FileType * syn clear rightMargin | ' .
               \ 'syn match rightMargin /\%80' .
               \ 'v[^<>(){}\[\]:/\"'."'".']/ containedin=ALL'
   execute rightMargin
   hi rightMargin ctermbg=Red guibg=Red
   " Convienent command to clear it, if it messes up syntax
   " highlighting, which it usually does on when the 80th column
   " is a single or double quote
   command! RightMarginClear syn clear rightMargin
endif

" Match redundant whitspaces
highlight RedundantSpaces guibg=green ctermbg=green
match RedundantSpaces /\s\+$\| \+\ze\t/
"highlight Folded         term=standout ctermfg=4 ctermbg=248 guifg=#b0d0e0 guibg=#305060
"highlight FoldColumn     term=standout ctermfg=8 ctermbg=248 guifg=#b0d0e0 guibg=#305060



"-------------------------------------
"autocmd VimEnter * tab all
"autocmd BufAdd * exe 'tablast | tabe "' . expand( "<afile") .'"'
autocmd BufReadPre *.pdf set ro
autocmd BufReadPost *.pdf %!pdftotext -nopgbrk "%" -
"autocmd BufWritePre *{.c,.cpp,.h,.hpp,.sh,.ini,Makefile}  call RemoveTrailingSpace() " Remove trailing spaces for C/C++ and Vim files

autocmd FileType make set noexpandtab shiftwidth=8 " Use real tabs for Makefiles
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction
let g:Tlist_Process_File_Always=1
"set statusline=%1*%=\|%f\ %h%m%r\ %-5l,%-5c\ %P%1*
"set statusline+=%{SyntaxItem()}





let g:showmarks_enable=1
"autocmd VimEnter * call ShowMarksOn()

"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
"let Powerline_symbols = 'compatible'
"let g:Powerline_symbols = 'fancy'


"au BufRead,BufNewFile *.log set filetype=diver
"au! Syntax diver source /home/mariusn/.vim/syntax/diver.vim

" Set an orange cursor in Insert mode, and red cursor otherwise.
" Works at least for xterm and rxvt terminals
" Does not work at least for gnome terminal, konsole, xfce4-terminal
"if &term =~ "xterm\\|rxvt"
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

function! SetTab(width)
      "set noexpandtab
      set noexpandtab           "use spaces instead of tabs
      "set softtabstop=a:width       "spaces to insert when <Tab> is pressed
      "Number of spaces that a <Tab> in the file counts for
       execute "set tabstop=".str2nr(a:width)
      "Number of spaces to use for each step of (auto)indent
       execute "set shiftwidth=".str2nr(a:width)
endfunction

function! DeleteHiddenBuffers()
		let tpbl=[]
		call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
		for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
		silent execute 'bwipeout' buf
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
        let s .= '%#NONE#%#StatusLineNC# %#NONE#'
    endfor
    " after the last tab fill with TabLineFill and reset tab page #
    let s .= '%#TabLineFill#%T'
    return s
endfunction
set tabline=%!MyTabLine()

if has('statusline')
  set statusline=%#Question#                   " set highlighting
  set statusline+=%#StatusLineNC#              " set highlighting
  set statusline+=%-2.2n\                    " buffer number
  set statusline+=%#DiffDelete#
  set statusline+=%(%{Tlist_Get_Tagname_By_Line()}%)
  set statusline+=%#StatusLineNC#              " set highlighting
  set statusline+=\ \                          " set highlighting
  set statusline+=%#WarningMsg#                " set highlighting
  set statusline+=%f                         " file name
  set statusline+=%#Question#                  " set highlighting
  set statusline+=\ \                          " set highlighting
  "set statusline+=%h                          " help
  "set statusline+=%#Question#                  " set highlighting
  "set statusline+=%r                       " read-only
  "set statusline+=%w                       " read-only
  "set statusline+=%{strlen(&ft)?&ft:'none'},   " file type
  "set statusline+=%{(&fenc==\"\"?&enc:&fenc)}, " encoding
  set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
  set statusline+=%{&fileformat},              " file format
  "set statusline+=%{&spelllang},               " language of spelling checker
  "set statusline+=%{SyntaxItem()}              " syntax highlight group under cursor
  set statusline+=%=                           " ident to the right
  set statusline+=%#DiffDelete#              " set highlighting
  set statusline+=%m                       " modified
  set statusline+=%#StatusLineNC#              " set highlighting
  set statusline+=%#Question#                  " set highlighting
  set statusline+=\ \                          " set highlighting
  set statusline+=0x%-8B\                      " character code under cursor
  set statusline+=%-7.(%l,%L,%c%V%)\ %<%P         " cursor position/offset
  set statusline+=%14o                         " cursor position/offset
endif

call SetTab(8)
let g:vimwiki_list = [{'path': '~/Doc/vimwiki/', 'path_html': '~/public_html/vimwiki'}]
