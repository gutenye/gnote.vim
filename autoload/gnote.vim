func! gnote#insert_bullet(chr)
  " Insert a UTF-8 list bullet when the user types "*".
  if getline('.')[0 : max([0, col('.') - 2])] =~ '^\s*$'
    return '•'
  endif
  return a:chr
endfunc
