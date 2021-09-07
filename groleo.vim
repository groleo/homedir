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
let g:colors_name = "groleo"


highlight Normal              ctermfg=000  ctermbg=230  cterm=NONE   guifg=#000000 guibg=#ffffd7 gui=NONE
highlight Type                ctermfg=090  ctermbg=NONE cterm=bold   guifg=#870087 guibg=NONE    gui=bold
highlight Number              ctermfg=063  ctermbg=NONE cterm=NONE   guifg=#5f5fff guibg=NONE    gui=NONE
highlight Identifier          ctermfg=001  ctermbg=NONE cterm=bold   guifg=#800000 guibg=NONE    gui=bold
highlight Statement           ctermfg=012  ctermbg=NONE cterm=bold   guifg=#0000ff guibg=NONE    gui=bold
highlight Question            ctermfg=012  ctermbg=009  cterm=NONE   guifg=#0000ff guibg=#ff0000 gui=NONE
highlight Boolean             ctermfg=002  ctermbg=NONE cterm=NONE   guifg=#008000 guibg=NONE    gui=NONE
highlight Cursor              ctermfg=011  ctermbg=000  cterm=bold   guifg=#ffff00 guibg=#000000 gui=bold
highlight CursorIM            ctermfg=011  ctermbg=000  cterm=bold   guifg=#ffff00 guibg=#000000 gui=bold
highlight Directory           ctermfg=009  ctermbg=NONE cterm=bold   guifg=#ff0000 guibg=NONE    gui=bold
highlight Search              ctermfg=015  ctermbg=240  cterm=NONE   guifg=#ffffff guibg=#585858 gui=NONE
highlight IncSearch           ctermfg=000  ctermbg=009  cterm=NONE   guifg=#000000 guibg=#ff0000 gui=NONE
highlight LineNr              ctermfg=001  ctermbg=NONE cterm=NONE   guifg=#800000 guibg=NONE    gui=NONE
highlight MatchParen          ctermfg=022  ctermbg=009  cterm=NONE   guifg=#005f00 guibg=#ff0000 gui=NONE
highlight ModeMsg             ctermfg=011  ctermbg=009  cterm=NONE   guifg=#ffff00 guibg=#ff0000 gui=NONE
highlight PmenuSel            ctermfg=011  ctermbg=009  cterm=NONE   guifg=#ffff00 guibg=#ff0000 gui=NONE
highlight WarningMsg          ctermfg=011  ctermbg=009  cterm=bold   guifg=#ffff00 guibg=#ff0000 gui=bold
highlight String              ctermfg=056  ctermbg=NONE cterm=NONE   guifg=#5f00d7 guibg=NONE    gui=NONE
highlight Pmenu               ctermfg=008  ctermbg=018  cterm=NONE   guifg=#808080 guibg=#000087 gui=NONE
highlight SpecialChar         ctermfg=009  ctermbg=NONE cterm=NONE   guifg=#ff0000 guibg=NONE    gui=NONE
highlight SpecialKey          ctermfg=008  ctermbg=NONE cterm=NONE   guifg=#808080 guibg=NONE    gui=NONE

highlight SpellBad            ctermfg=015  ctermbg=001  cterm=NONE   guifg=#ffffff guibg=#800000 gui=NONE
highlight StatusLine          ctermfg=241  ctermbg=NONE cterm=NONE   guifg=#626262 guibg=NONE    gui=NONE
highlight StatusLineNC        ctermfg=008  ctermbg=NONE cterm=NONE   guifg=#808080 guibg=NONE    gui=NONE
highlight cFormat             ctermfg=090  ctermbg=NONE cterm=NONE   guifg=#870087 guibg=NONE    gui=NONE

highlight PreCondit           ctermfg=000  ctermbg=035  cterm=NONE   guifg=#000000 guibg=#00af5f gui=NONE
highlight PreProc             ctermfg=028  ctermbg=NONE cterm=bold   guifg=#008700 guibg=NONE    gui=bold
highlight TabLine             ctermfg=253  ctermbg=012  cterm=NONE   guifg=#dadada guibg=#0000ff gui=NONE
highlight TabLineSel          ctermfg=011  ctermbg=009  cterm=bold   guifg=#ffff00 guibg=#ff0000 gui=bold
highlight TabLineFill         ctermfg=NONE ctermbg=012  cterm=NONE   guifg=NONE    guibg=#0000ff gui=NONE
highlight Comment             ctermfg=198  ctermbg=NONE cterm=bold   guifg=#ff0087 guibg=NONE    gui=bold
highlight CursorLine          ctermfg=NONE ctermbg=042  cterm=bold   guifg=NONE    guibg=#00d787 gui=bold
highlight Delimiter           ctermfg=012  ctermbg=NONE cterm=NONE   guifg=#0000ff guibg=NONE    gui=NONE
highlight FoldColumn          ctermfg=116  ctermbg=023  cterm=NONE   guifg=#87d7d7 guibg=#005f5f gui=NONE
highlight Folded              ctermfg=195  ctermbg=023  cterm=bold   guifg=#b0d0e0 guibg=#305060 gui=bold
highlight Todo                ctermfg=NONE ctermbg=NONE cterm=NONE   guifg=cyan    guibg=#507080 gui=NONE
highlight VertSplit           ctermfg=NONE ctermbg=NONE cterm=NONE   guifg=NONE    guibg=NONE    gui=NONE
highlight Visual              ctermfg=000  ctermbg=067  cterm=NONE   guifg=#000000 guibg=#5f87af gui=NONE
highlight Function            ctermfg=028  ctermbg=NONE cterm=bold   guifg=#008700 guibg=NONE    gui=bold
highlight PmenuSbar           ctermbg=018  ctermbg=NONE cterm=NONE   guifg=#008700 guibg=NONE    gui=NONE

highlight diffDelete          ctermfg=012  ctermbg=159  cterm=bold   guifg=#0000ff guibg=#afffff gui=bold
highlight diffAdded           ctermfg=130  ctermbg=NONE cterm=bold   guifg=#af5f00 guibg=NONE    gui=bold
highlight diffOldFile         ctermfg=012  ctermbg=051  cterm=bold   guifg=#ff9cf1 guibg=#00ffff gui=bold
highlight diffNewFile         ctermfg=012  ctermbg=051  cterm=bold   guifg=#ff9cf1 guibg=#00ffff gui=bold

highlight ShowMarksHLl        ctermfg=015  ctermbg=069  cterm=bold   guifg=#0000ff guibg=#5f87ff gui=bold
highlight ShowMarksHLu        ctermfg=015  ctermbg=069  cterm=bold   guifg=#0000ff guibg=#5f87ff gui=bold
highlight ShowMarksHLo        ctermfg=015  ctermbg=069  cterm=bold   guifg=#0000ff guibg=#5f87ff gui=bold
highlight ShowMarksHLm        ctermfg=015  ctermbg=069  cterm=bold   guifg=#0000ff guibg=#5f87ff gui=bold
