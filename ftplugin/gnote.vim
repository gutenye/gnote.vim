if exists("b:did_gnote_ftplugin")
  finish
endif
let b:did_gnote_ftplugin = 1

setlocal conceallevel=2 concealcursor=nc

" @fold
for i in range(1,4)
	let cmd=printf("iabbr <buffer> {{%s #{{{%s<C-R>=Eatchar('\s')<CR>",i,i)
	exec cmd
endfor 
for i in range(1,4)
	let cmd=printf("iabbr <buffer> }}%s #}}}%s<C-R>=Eatchar('\s')<CR>",i,i)
	exec cmd
endfor 

" abbr 
iabbr nt ¤¤<left>
iabbr ns ºº<left>

setlocal iskeyword+=-

" list bullet
imap <buffer> <expr> * gnote#insert_bullet('*')

set foldmethod=marker commentstring=#%s
set foldtext=Gfoldtext('\\v¤\|º\|`\|ĥ\|∗')
" set updatetime=1000
" exec 'autocmd CursorHold '.expand('%:p').' write'
" exec 'autocmd InsertLeave '.expand('%:p').' write'
