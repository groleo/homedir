" Vi color file
" Maintainer:        Adrian-Marius Negreanu <groleo@gmail.com>

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
let g:colors_name = "groleo-dark"


highlight Normal              ctermfg=253 ctermbg=16  guifg=grey guibg=black
highlight Type                ctermfg=121 term=underline guifg=#60ff60
highlight Number              ctermfg=lightred guifg=Red guibg=bg gui=NONE
highlight Identifier          ctermfg=001  ctermbg=NONE cterm=bold   guifg=#800000 guibg=NONE    gui=bold
highlight Statement           ctermfg=yellow guifg=yellow gui=NONE
highlight Question            ctermfg=012  ctermbg=009  cterm=NONE   guifg=#0000ff guibg=#ff0000 gui=NONE
highlight Boolean             ctermfg=green  guifg=Green guibg=bg  gui=NONE
highlight Cursor              ctermfg=lightred ctermbg=lightred
highlight CursorIM            ctermfg=lightred ctermbg=lightred
highlight Directory           ctermfg=11 guifg=Brown term=bold gui=bold
highlight Search              ctermfg=black ctermbg=111
highlight IncSearch           ctermfg=cyan ctermbg=black
highlight LineNr              ctermfg=brown guifg=grey60 guibg=black gui=NONE
highlight MatchParen          ctermfg=darkgreen ctermbg=red guifg=darkgreen guibg=red
highlight ModeMsg             ctermfg=yellow ctermbg=red
highlight PmenuSel            ctermfg=yellow ctermbg=red
highlight WarningMsg          ctermfg=yellow ctermbg=red cterm=bold guifg=yellow guibg=red gui=bold
highlight String              ctermfg=253                guifg=Blue guibg=bg gui=NONE
highlight Pmenu               ctermfg=grey ctermbg=darkblue
highlight SpecialChar         ctermfg=cyan
highlight SpecialKey          ctermfg=008  ctermbg=NONE cterm=NONE   guifg=#808080 guibg=NONE    gui=NONE

highlight SpellBad            ctermfg=white ctermbg=brown
highlight StatusLine          ctermfg=grey        guifg=grey60 guibg=grey90
highlight StatusLineNC        ctermfg=235 ctermbg=241
highlight cFormat             ctermfg=magenta

highlight PreCondit           ctermfg=000  ctermbg=035  cterm=NONE   guifg=#000000 guibg=#00af5f gui=NONE
highlight PreProc             ctermfg=green guifg=green gui=NONE
highlight TabLine             ctermfg=grey ctermbg=17 cterm=NONE
highlight TabLineSel          ctermfg=yellow ctermbg=124 cterm=bold
highlight TabLineFill         ctermbg=17 cterm=NONE
highlight Comment             cterm=bold ctermfg=1 guifg=red2
highlight CursorLine          ctermbg=21  cterm=NONE
highlight ColorColumn         ctermfg=NONE ctermbg=236 guifg=bg guibg=fg
highlight Delimiter           guifg=blue
highlight FoldColumn          guifg=#b0d0e0 guibg=#305060 gui=NONE
highlight Folded              ctermfg=153 ctermbg=23 cterm=NONE guifg=#b0d0e0 guibg=#305060 gui=NONE
highlight Todo                guifg=cyan  guibg=#507080
highlight VertSplit           cterm=NONE gui=NONE
highlight Visual              ctermbg=67 cterm=NONE
highlight Function            ctermfg=028  ctermbg=NONE cterm=bold   guifg=#008700 guibg=NONE    gui=bold
highlight PmenuSbar                ctermbg=darkblue

" for vimdiff
highlight DiffAdd             cterm=NONE ctermfg=24 ctermbg=225
highlight DiffChange          cterm=NONE ctermfg=5 ctermbg=218
highlight DiffDelete          cterm=bold ctermfg=12 ctermbg=159 gui=bold guifg=Blue guibg=Cyan
highlight DiffText            cterm=NONE ctermfg=0 ctermbg=200

" .diff file
highlight diffDelete          ctermfg=012  ctermbg=159  cterm=bold   guifg=#0000ff guibg=#afffff gui=bold
highlight diffOldFile         ctermfg=012  ctermbg=051  cterm=bold   guifg=#ff9cf1 guibg=#00ffff gui=bold
highlight diffNewFile         ctermfg=012  ctermbg=051  cterm=bold   guifg=#ff9cf1 guibg=#00ffff gui=bold

highlight ShowMarksHLl ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
highlight ShowMarksHLu ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
highlight ShowMarksHLo ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
highlight ShowMarksHLm ctermfg=white ctermbg=blue cterm=bold guifg=blue guibg=lightblue gui=bold
