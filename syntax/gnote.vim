if exists('b:current_syntax')
	finish
endif
let b:current_syntax='gnote'

syn cluster gnoteAll_c contains=gnoteKeyword,gnoteTitle,gnoteSubTitle,gnoteSymbol,gnoteIgnore,gnoteNormal,gnoteJumpTo,gnoteComment,gnotehighlight
syn match gnoteIgnore "^#gnote#$\|#{{{\|#}}}" 
syn region gnoteNormal  start=+´+ end=+´+ 

syn match gnoteHyperTextJump	"∥[^∗∥]\+∥" contains=gnoteBar
syn match gnoteHyperTextEntry	"∗[^∗∥]\+∗\s"he=e-1 contains=gnoteStar
syn match gnoteHyperTextEntry	"∗[^∗∥]\+∗$" contains=gnoteStar
syn match gnoteBar		contained "∥" conceal
syn match gnoteStar		contained "∗" conceal

syn keyword gnoteKeyword 
   \ ywman ywvs ywnok ywok yweg 
   \ ywor ywand ywthen ywso
   \ ywguts ywsec ywread ywuse ywsee ywsmall ywbad
   \ SAME_AS ONLY_AT

syn match gnoteSymbol "^|\|^: "
syn match gnoteKeySymbol "∷\|∶" 
syn region gnoteTitle   matchgroup=gnoteIgnore start="¤"  end="¤" oneline
syn region gnoteSubTitle matchgroup=gnoteIgnore start="º" end="º" oneline
syn region gnoteHighlight matchgroup=gnoteIgnore start="ĥ" end="ĥ" oneline
syn region gnoteComment matchgroup=gnoteNormal start='(' end=')' oneline contains=@gnoteAll_c
syn region gnoteComment matchgroup=gnoteIgnore start='«' end='»' contains=@gnoteAll_c

hi gnoteJumpTo cterm=underline
hi gnoteSep ctermfg=5
hi gnoteKeyword ctermfg=5
" hi gnoteSymbol ctermfg=5 
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

" tmp
hi Ignore ctermfg=234

