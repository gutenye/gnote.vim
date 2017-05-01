if exists('b:current_syntax')
	finish
endif
let b:current_syntax='gnote'

" From onedark colorscheme
let s:red = { "gui": "#E06C75", "cterm": "204", "cterm16": "1" }
let s:dark_red = { "gui": "#BE5046", "cterm": "196", "cterm16": "9" }
let s:green = { "gui": "#98C379", "cterm": "114", "cterm16": "2" }
let s:yellow = { "gui": "#E5C07B", "cterm": "180", "cterm16": "3" }
let s:dark_yellow = { "gui": "#D19A66", "cterm": "173", "cterm16": "11" }
let s:blue = { "gui": "#61AFEF", "cterm": "39", "cterm16": "4" }
let s:purple = { "gui": "#C678DD", "cterm": "170", "cterm16": "5" }
let s:cyan = { "gui": "#56B6C2", "cterm": "38", "cterm16": "6" }
let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16": "7" }
let s:black = { "gui": "#282C34", "cterm": "235", "cterm16": "0" }
let s:visual_black = { "gui": "NONE", "cterm": "NONE", "cterm16": s:black.cterm16 } " Black out selected text in 16-color visual mode
let s:comment_grey = { "gui": "#5C6370", "cterm": "59", "cterm16": "15" }
let s:gutter_fg_grey = { "gui": "#636D83", "cterm": "238", "cterm16": "15" }
let s:cursor_grey = { "gui": "#2C323C", "cterm": "236", "cterm16": "8" }
let s:visual_grey = { "gui": "#3E4452", "cterm": "237", "cterm16": "15" }
let s:menu_grey = { "gui": s:visual_grey.gui, "cterm": s:visual_grey.cterm, "cterm16": "8" }
let s:special_grey = { "gui": "#3B4048", "cterm": "238", "cterm16": "15" }
let s:vertsplit = { "gui": "#181A1F", "cterm": "59", "cterm16": "15" }

syn cluster gnoteAll_c contains=gnoteTODO,gnoteTitle,gnoteSubTitle,gnoteSymbol,gnoteIgnore,gnoteNormal,gnoteComment,gnoteHighlight
syn keyword gnoteTODO  TODO FIXME
syn match gnoteBold	      /∙[^∙]\+∙/ contains=gnoteConceal
syn match gnoteItalic	    /∘[^∘]\+∘/ contains=gnoteConceal
syn match gnoteUnderline	/―[^―]\+―/ contains=gnoteConceal
syn match gnoteConceal contained /∙\|∘\|―/ conceal
syn match gnoteJump	/∥[^∗∥]\+∥/ contains=gnoteBar
syn match gnoteTarget	/∗[^∗∥]\+∗\s/he=e-1 contains=gnoteStar
syn match gnoteTarget	/∗[^∗∥]\+∗$/ contains=gnoteStar
syn match gnoteBar		contained /∥/ conceal
syn match gnoteStar		contained /∗/ conceal
syn match gnoteIgnore /#{{{\|#}}}/
syn region gnoteNormal  start=+´+ end=+´+ 
syn match gnoteListBullet /^\s*•/
syn match gnoteListNumber /^\s*\d\+\. /
syn match gnoteSymbol /^|\|^: /
syn match gnoteKeySymbol /∷\|∶/ 
syn region gnoteTitle   matchgroup=gnoteIgnore start=/¤/  end=/¤/ oneline
syn region gnoteSubTitle matchgroup=gnoteIgnore start=/º/ end=/º/ oneline
syn region gnoteHighlight matchgroup=gnoteIgnore start=/ĥ/ end=/ĥ/ oneline
syn region gnoteComment matchgroup=gnoteNormal start=/(/ end=/)/ oneline contains=@gnoteAll_c
syn region gnoteComment matchgroup=gnoteIgnore start=/«/ end=/»/ contains=@gnoteAll_c
syntax match gnoteModeLine /\_^vim:.*\_s*\%$/

hi! link Folded Normal
hi link gnoteComment Comment
hi link gnoteJump	Identifier
hi link gnoteTarget	String
hi link gnoteIgnore Ignore
hi link gnoteTitle Statement
hi link gnoteSubTitle Special
" hi link gnoteTODO WarningMsg
" hi link gnoteNormal Normal
" hi gnoteBold cterm=bold
" hi gnoteItalic cterm=italic
" hi gnoteUnderline cterm=underline
" hi link gnoteSymbol Comment
" hi gnoteKeySymbol ctermfg=5
" hi gnoteHighlight ctermfg=11
" hi link gnoteListBullet Comment
" hi link gnoteListNumber Comment
" hi link gnoteModeLine LineNr
