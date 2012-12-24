" Parser compiled on Mon 24 Dec 2012 05:59:34 AM CST,
" with VimPEG v0.2 and VimPEG Compiler v0.1
" from "ex.vimpeg"
" with the following grammar:

" ; Vim :ex Parser
" ; Barry Arthur, 23 Dec 2012
" ; version 0.0 - Dev
" 
" .skip_white = false
" .namespace = 'ex'
" .parser_name = 'ex#parser'
" .root_element = 'ex_'
" 
" ex_ ::= ex eof
" ex ::= ex_commands*
" ex_commands ::= whitespace | (block_command w) | non_block_command
" 
" block_command ::= s_if
" non_block_command ::= (s_lets w ex)
" 
" s_if ::= c 'if' S expr1 w ex s_elseif* s_else? s_endif
" s_elseif ::= c 'elsei\%[f]' S expr1 w ex
" s_else ::= c 'el\%[se]' w ex
" s_endif ::= c 'en\%[dif]'
" 
" s_lets ::= s_let_ass | s_let_list
" s_let_cmd ::= c 'let'
" s_let_ass ::= s_let_cmd S s_let_var s ass_op s expr1
" s_let_list ::= s_let_cmd (S s_let_var_name)*
" 
" s_let_var ::= s_let_var_listref | s_let_var_env | s_let_var_reg | s_let_var_opt | s_let_var_name_list | s_let_var_name
" 
" s_let_var_name ::= ident
" s_let_var_listref ::= ident listref
" s_let_var_env ::= envvar
" s_let_var_reg ::= regval
" s_let_var_opt ::= '&' ('l:' | 'g:')? '\w\+'
" s_let_var_name_list ::= '\[' s s_let_var_name (s ',' s s_let_var_name)* (s ';' s s_let_var_name)? s '\]'
" 
" ass_op ::=  '=' | '+=' | '-=' | '.='
" 
" 
" ; replace this section with vimpeg-parser-viml - dummy values for now
" ;---------------------------------------------
" expr1 ::= '\d\+'
" ident ::= '\w\+'
" listref         ::=  '\[' s exprange s '\]'
" ;exprange        ::=  expr1 (s ':' s expr1)?
" exprange        ::=  (expr1? s ':' s expr1?) | expr1
" envvar          ::=  '\$\w\+'
" regval          ::=  '@[a-z0-9_/.+*"'']'
" ;---------------------------------------------
" 
" c ::= ':'* s
" 
" whitespace ::= (W | comment_to_eol)+
" 
" ; Optional space
" s ::= ws*
" 
" ; Mandatory space
" S ::= ws+
" 
" ; ws<bar><nlws>   or   <nlws>
" w ::= (s '|' W*) | W+
" 
" ; spaces, tabs and newlines
" W ::= '[\x20\t\n\r]'
" 
" ; spaces and tabs
" ws ::= '\s'
" 
" comment_to_eol ::= '"' (!'\n' '.')+
" 
" eof ::= ! '.'

let s:p = vimpeg#parser({'root_element': 'ex_', 'skip_white': 0, 'parser_name': 'ex#parser', 'namespace': 'ex'})
call s:p.and(['ex', 'eof'],
      \{'id': 'ex_'})
call s:p.maybe_many('ex_commands',
      \{'id': 'ex'})
call s:p.or(['whitespace', s:p.and(['block_command', 'w']), 'non_block_command'],
      \{'id': 'ex_commands'})
call s:p.and(['s_if'],
      \{'id': 'block_command'})
call s:p.and(['s_lets', 'w', 'ex'],
      \{'id': 'non_block_command'})
call s:p.and(['c', s:p.e('if'), 'S', 'expr1', 'w', 'ex', s:p.maybe_many('s_elseif'), s:p.maybe_one('s_else'), 's_endif'],
      \{'id': 's_if'})
call s:p.and(['c', s:p.e('elsei\%[f]'), 'S', 'expr1', 'w', 'ex'],
      \{'id': 's_elseif'})
call s:p.and(['c', s:p.e('el\%[se]'), 'w', 'ex'],
      \{'id': 's_else'})
call s:p.and(['c', s:p.e('en\%[dif]')],
      \{'id': 's_endif'})
call s:p.or(['s_let_ass', 's_let_list'],
      \{'id': 's_lets'})
call s:p.and(['c', s:p.e('let')],
      \{'id': 's_let_cmd'})
call s:p.and(['s_let_cmd', 'S', 's_let_var', 's', 'ass_op', 's', 'expr1'],
      \{'id': 's_let_ass'})
call s:p.and(['s_let_cmd', s:p.maybe_many(s:p.and(['S', 's_let_var_name']))],
      \{'id': 's_let_list'})
call s:p.or(['s_let_var_listref', 's_let_var_env', 's_let_var_reg', 's_let_var_opt', 's_let_var_name_list', 's_let_var_name'],
      \{'id': 's_let_var'})
call s:p.and(['ident'],
      \{'id': 's_let_var_name'})
call s:p.and(['ident', 'listref'],
      \{'id': 's_let_var_listref'})
call s:p.and(['envvar'],
      \{'id': 's_let_var_env'})
call s:p.and(['regval'],
      \{'id': 's_let_var_reg'})
call s:p.and([s:p.e('&'), s:p.maybe_one(s:p.or([s:p.e('l:'), s:p.e('g:')])), s:p.e('\w\+')],
      \{'id': 's_let_var_opt'})
call s:p.and([s:p.e('\['), 's', 's_let_var_name', s:p.maybe_many(s:p.and(['s', s:p.e(','), 's', 's_let_var_name'])), s:p.maybe_one(s:p.and(['s', s:p.e(';'), 's', 's_let_var_name'])), 's', s:p.e('\]')],
      \{'id': 's_let_var_name_list'})
call s:p.or([s:p.e('='), s:p.e('+='), s:p.e('-='), s:p.e('.=')],
      \{'id': 'ass_op'})
call s:p.e('\d\+',
      \{'id': 'expr1'})
call s:p.e('\w\+',
      \{'id': 'ident'})
call s:p.and([s:p.e('\['), 's', 'exprange', 's', s:p.e('\]')],
      \{'id': 'listref'})
call s:p.or([s:p.and([s:p.maybe_one('expr1'), 's', s:p.e(':'), 's', s:p.maybe_one('expr1')]), 'expr1'],
      \{'id': 'exprange'})
call s:p.e('\$\w\+',
      \{'id': 'envvar'})
call s:p.e('@[a-z0-9_/.+*"'']',
      \{'id': 'regval'})
call s:p.and([s:p.maybe_many(s:p.e(':')), 's'],
      \{'id': 'c'})
call s:p.many(s:p.or(['W', 'comment_to_eol']),
      \{'id': 'whitespace'})
call s:p.maybe_many('ws',
      \{'id': 's'})
call s:p.many('ws',
      \{'id': 'S'})
call s:p.or([s:p.and(['s', s:p.e('|'), s:p.maybe_many('W')]), s:p.many('W')],
      \{'id': 'w'})
call s:p.e('[\x20\t\n\r]',
      \{'id': 'W'})
call s:p.e('\s',
      \{'id': 'ws'})
call s:p.and([s:p.e('"'), s:p.many(s:p.and([s:p.not_has(s:p.e('\n')), s:p.e('.')]))],
      \{'id': 'comment_to_eol'})
call s:p.not_has(s:p.e('.'),
      \{'id': 'eof'})

let g:ex#parser = s:p.GetSym('ex_')
