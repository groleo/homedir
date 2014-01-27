" Vi color file
" Maintainer:	Marius Negreanu <groleo@gmail.com>
" Last Change:	2006 Jul 23

if &t_Co != 256 && ! has("gui_running")
    echomsg ""
    echomsg "write 'set t_Co=256' in your .vimrc or this file won't load"
    echomsg ""
    finish
endif
" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlight and set the defaults.
hi clear
"{
" Load the syntax highlight defaults, if it's enabled.
"}



set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "groleo"


highlight Boolean		ctermfg=green guifg=Green guibg=bg  gui=NONE
highlight Cursor		ctermfg=lightred ctermbg=lightred
highlight CursorIM		ctermfg=lightred ctermbg=lightred
highlight Directory		ctermfg=11 guifg=Brown term=bold gui=bold
highlight IncSearch		ctermfg=cyan ctermbg=yellow cterm=inverse
highlight LineNr		ctermfg=brown guifg=grey60 guibg=black gui=NONE
highlight MatchParen	ctermfg=darkgreen ctermbg=red guifg=darkgreen guibg=red
highlight ModeMsg		ctermfg=yellow ctermbg=red
highlight PmenuSel		ctermfg=yellow ctermbg=red
highlight Statement		ctermfg=yellow guifg=yellow gui=NONE
highlight TabLineSel	ctermfg=yellow ctermbg=red cterm=bold
highlight WarningMsg    ctermfg=yellow ctermbg=red cterm=bold guifg=yellow guibg=red gui=bold
highlight Normal		ctermfg=grey	 ctermbg=black		guifg=grey guibg=black
highlight Number		ctermfg=lightred	guifg=Red guibg=bg gui=NONE
highlight Pmenu			ctermfg=grey ctermbg=darkblue
highlight PreProc		ctermfg=green guifg=green gui=NONE
highlight SpecialChar	ctermfg=cyan
highlight SpellBad		ctermfg=white ctermbg=brown
highlight StatusLine	ctermfg=grey	guifg=grey60 guibg=grey90
highlight StatusLineNC	ctermfg=grey guifg=grey60 guibg=grey90
highlight String		ctermfg=white		guifg=Blue guibg=bg gui=NONE
highlight TabLine		ctermfg=grey ctermbg=blue guibg=NONE cterm=NONE gui=NONE
highlight Type			ctermfg=121 term=underline guifg=#60ff60
highlight cFormat		ctermfg=magenta

"highlight Comment		term=bold ctermfg=12 guifg=#80a0ff
highlight Comment  term=bold ctermfg=1 guifg=red2
highlight TabLineFill	ctermbg=blue cterm=NONE
highlight CursorLine	ctermbg=21  cterm=NONE
highlight Delimiter		guifg=blue
highlight FoldColumn	guifg=#b0d0e0 guibg=#305060 gui=NONE
highlight Folded		ctermfg=153 ctermbg=23 cterm=NONE guifg=#b0d0e0 guibg=#305060 gui=NONE
highlight Todo			guifg=cyan  guibg=#507080
highlight VertSplit		cterm=NONE gui=NONE
highlight Visual		ctermbg=67 cterm=NONE
highlight CursorLine	term=NONE cterm=NONE ctermbg=1
highlight PmenuSbar		ctermbg=darkblue
highlight Search		term=reverse ctermbg=1 guibg=Yellow
highlight DiffDelete	term=bold ctermfg=12 ctermbg=159 gui=bold guifg=Blue guibg=Cyan
hi ShowMarksHLl ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
hi ShowMarksHLu ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
hi ShowMarksHLo ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
hi ShowMarksHLm ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
