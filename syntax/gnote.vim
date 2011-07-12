if exists('b:current_syntax')
	finish
endif
let b:current_syntax='gnote'

" ywsmall "{{{1
syn cluster gnoteAll_c contains=gnoteKeyword,gnoteTitle,gnoteSubTitle,gnoteSymbol,gnoteIgnore,gnoteNormal,gnoteJumpTo,gnoteComment,gnotehighlight
syn match gnoteIgnore "^#gnote#$\|#{{{\|#}}}" 
syn region gnoteNormal  start=+´+ end=+´+ 
syn region gnoteJumpTo  matchgroup=gnoteIgnore start="Г" end="Г"
hi gnoteJumpTo cterm=underline
syn match gnoteSep "-\{6\}-*"
hi gnoteSep ctermfg=5

																"}}}1
" keywords "{{{1
syn keyword gnoteKeyword 
   \ ywman ywvs ywnok ywok yweg 
   \ ywor ywand ywthen ywso
   \ ywguts ywsec ywread ywuse ywsee ywsmall ywbad
   \ SAME_AS ONLY_AT
hi gnoteKeyword ctermfg=5
" not <== ==> <==>. confict
syn match gnoteSymbol "^|\|^: "
" hi gnoteSymbol ctermfg=5 
hi link gnoteSymbol Comment
syn match gnoteKeySymbol "∷\|∶" 
hi gnoteKeySymbol ctermfg=5
"}}}1
" title "{{{1
syn region gnoteTitle   matchgroup=gnoteIgnore start="¤"  end="¤" oneline
	hi gnoteTitle ctermfg=5
syn region gnoteSubTitle matchgroup=gnoteIgnore start="º" end="º" oneline
	hi gnoteSubTitle ctermfg=6
syn region gnoteHighlight matchgroup=gnoteIgnore start="ĥ" end="ĥ" oneline
	hi gnotehighlight ctermfg=11

"}}}1
" comment "{{{1
	syn region gnoteComment matchgroup=gnoteNormal start='(' end=')' oneline contains=@gnoteAll_c
	syn region gnoteComment matchgroup=gnoteIgnore start='«' end='»' contains=@gnoteAll_c
"}}}1
" hi link "{{{1
hi link gnoteIgnore Ignore
hi link gnoteComment Comment
hi link gnoteNormal Normal
"}}}1
