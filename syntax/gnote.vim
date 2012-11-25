if exists('b:current_syntax')
	finish
endif
let b:current_syntax='gnote'

syn cluster gnoteAll_c contains=gnoteMarker,gnoteTitle,gnoteSubTitle,gnoteSymbol,gnoteIgnore,gnoteNormal,gnoteJumpTo,gnoteComment,gnotehighlight
syn keyword gnoteMarker  TODO FIXME
syn match gnoteBold	      /∙[^∙]\+∙/ contains=gnoteConceal
syn match gnoteItalic	    /∘[^∘]\+∘/ contains=gnoteConceal
syn match gnoteUnderline	/―[^―]\+―/ contains=gnoteConceal
syn match gnoteConceal contained /∙\|∘\|―/ conceal
syn match gnoteHyperTextJump	/∥[^∗∥]\+∥/ contains=gnoteBar
syn match gnoteHyperTextEntry	/∗[^∗∥]\+∗\s/he=e-1 contains=gnoteStar
syn match gnoteHyperTextEntry	/∗[^∗∥]\+∗$/ contains=gnoteStar
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

hi gnoteBold cterm=bold
hi gnoteItalic cterm=italic
hi gnoteUnderline cterm=underline
hi gnoteJumpTo cterm=underline
hi gnoteSep ctermfg=5
hi def link gnoteMarker WarningMsg
hi link gnoteSymbol Comment
hi gnoteKeySymbol ctermfg=5
hi gnoteTitle ctermfg=5
hi gnoteSubTitle ctermfg=6
hi gnotehighlight ctermfg=11
hi def link gnoteIgnore Ignore
hi def link gnoteComment Comment
hi def link gnoteNormal Normal
hi def link gnoteHyperTextJump	helpHyperTextJump
hi def link gnoteHyperTextEntry	helpHyperTextEntry
hi def link gnoteListBullet Comment
hi def link gnoteListNumber Comment
hi def link gnoteModeLine LineNr

" FIXME
hi Ignore ctermfg=234
