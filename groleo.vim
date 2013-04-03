" Vi color file
" Maintainer:	Marius Negreanu <groleo@gmail.com>
" Last Change:	2006 Jul 23

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlight and set the defaults.
hi clear

" Load the syntax highlight defaults, if it's enabled.




set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "groleo"


"highlight Comment	term=bold ctermfg=6 guifg=SkyBlue
"highlight CursorLine cterm=inverse "ctermbg=blue guibg=blue
"highlight Visual		gui=reverse guibg=WHITE guifg=SeaGreen
"highlight Type		ctermfg=darkgreen
"highlight CursorLine term=reverse cterm=reverse gui=reverse
highlight Boolean	ctermfg=green guifg=Green guibg=bg  gui=NONE
highlight Comment	term=bold ctermfg=12 guifg=#80a0ff
highlight Cursor	ctermfg=lightred ctermbg=lightred
highlight CursorIM	ctermfg=lightred ctermbg=lightred
highlight CursorLine	ctermbg=21  cterm=NONE
highlight Delimiter     guifg=blue
highlight Directory     term=bold ctermfg=11 gui=bold guifg=Brown
highlight FoldColumn	guifg=#b0d0e0 guibg=#305060 gui=NONE
highlight Folded	guifg=#b0d0e0 guibg=#305060 gui=NONE
highlight IncSearch	ctermfg=cyan ctermbg=yellow cterm=inverse
highlight LineNr	ctermfg=brown		guifg=grey60 guibg=black gui=NONE
highlight MatchParen	ctermfg=darkgreen ctermbg=red guifg=darkgreen guibg=red
highlight ModeMsg	ctermfg=yellow ctermbg=red
highlight Normal	ctermfg=grey	 ctermbg=black		guifg=grey guibg=black
highlight Number	ctermfg=lightred	guifg=Red guibg=bg gui=NONE
highlight Pmenu		ctermfg=grey ctermbg=darkblue
highlight PmenuSbar	ctermbg=darkblue
highlight PmenuSel	ctermbg=red  ctermfg=yellow
highlight PreProc	ctermfg=green		guifg=green gui=NONE
highlight Search term=reverse ctermbg=1 guibg=Yellow
highlight SpecialChar	ctermfg=cyan
highlight SpellBad	ctermbg=brown ctermfg=white
highlight Statement	ctermfg=yellow
highlight StatusLine	ctermfg=grey	guifg=grey60 guibg=grey90
highlight StatusLineNC	guifg=grey60 guibg=grey90
highlight String	ctermfg=white		guifg=Blue guibg=bg gui=NONE
highlight TabLine        ctermfg=grey ctermbg=blue guibg=none cterm=none gui=none
highlight TabLineFill    cterm=none ctermbg=blue
highlight TabLineSel     ctermfg=yellow ctermbg=red cterm=bold
highlight Todo		guifg=Cyan  guibg=#507080
highlight Type		term=underline ctermfg=121 guifg=#60ff60
highlight VertSplit cterm=none
highlight Visual	ctermbg=67 cterm=NONE
highlight WarningMsg    ctermfg=yellow ctermbg=red cterm=bold
highlight cFormat	ctermfg=magenta

hi ShowMarksHLl ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
hi ShowMarksHLu ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
hi ShowMarksHLo ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
hi ShowMarksHLm ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
" Documentation BUG. is specified as ParenMatch
" matchparen bug: if I press the down, when the cursor is allready at bottom, the function is still called
