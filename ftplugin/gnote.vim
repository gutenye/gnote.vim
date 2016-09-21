if exists("b:did_gnote_ftplugin")
  finish
endif
let b:did_gnote_ftplugin = 1

setlocal expandtab
setlocal conceallevel=2 concealcursor=nc

" abbr
"iabbr nt ¤¤<left>
"iabbr ns ºº<left>
"iabbr nc «»<left>

setlocal iskeyword+=-

" list bullet
imap <buffer> <expr> * gnote#insert_bullet('*')

"" Fold
set foldmethod=marker
set commentstring=#%s
set fillchars="fold:\ "
set foldtext=GNotefoldtext('\\v¤\|º\|`\|ĥ\|∗\|«\|»')
func! GNotefoldtext(hidden)
	let pattern = substitute(&commentstring, '%s', '{{{\\d', 'g')
	let line = getline(v:foldstart)
  " a tab is 2 space
  let text = substitute(line, '\t', '  ', 'g')
	let text = substitute(text, '\M' . pattern, '', 'g')
	let text = substitute(text, a:hidden, '', 'g')
	return text . "-"
endfunc

for i in range(1,4)
	let cmd=printf("iabbr <buffer> {{%s #{{{%s<C-R>=Eatchar('\s')<CR>",i,i)
	exec cmd
endfor
for i in range(1,4)
	let cmd=printf("iabbr <buffer> }}%s #}}}%s<C-R>=Eatchar('\s')<CR>",i,i)
	exec cmd
endfor

" set updatetime=1000
" exec 'autocmd CursorHold '.expand('%:p').' write'
" exec 'autocmd InsertLeave '.expand('%:p').' write'


command Cmp :call s:compare(<f-arg>)
func! s:compare(args) "{{{1
  " edit fb
  " vnew fa
  a:args
	" in Edit_cmds
	if has_key(g:Edit_cmds, a:cmd)
		exec g:Edit_cmds[a:cmd]
		return
	endif
endfunc
