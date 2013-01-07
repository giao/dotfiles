" Vim syntax file
" Language:	SQL, PL/SQL (Oracle 8i)
" Maintainer:	Paul Moore <gustav@morpheus.demon.co.uk>
" Last Change:	2001 Apr 30

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" The SQL reserved words, defined as keywords.
syn keyword sqlSpecial  false null true

syn keyword sqlKeyword	access add after as asc before begin by check cluster column
syn keyword sqlKeyword	compress connect current cursor decimal declare default desc each
syn keyword sqlKeyword	else elsif end exception exclusive file for foreign from
syn keyword sqlKeyword	function group having identified if immediate increment
syn keyword sqlKeyword	index initial into is key level limit loop maxextents mode modify
syn keyword sqlKeyword	nocompress nowait of offline on online primary start
syn keyword sqlKeyword	successful synonym table then to trigger uid oids
syn keyword sqlKeyword	unique user validate values view whenever
syn keyword sqlKeyword	where with option order pctfree privileges procedure
syn keyword sqlKeyword	public resource return returns row rowlabel rownum rows
syn keyword sqlKeyword	session share size smallint type using

syn keyword sqlOperator	not and or
syn keyword sqlOperator	in any some all between exists
syn keyword sqlOperator	like escape
syn keyword sqlOperator union intersect minus
syn keyword sqlOperator prior distinct
syn keyword sqlOperator	sysdate out without nextval currval

syn keyword sqlStatement alter alias analyze audit comment commit create
syn keyword sqlStatement delete drop execute explain grant insert lock noaudit
syn keyword sqlStatement rename replace revoke rollback savepoint select set
syn keyword sqlStatement truncate update vacuum language

syn keyword sqlType abstime bigint bigserial binary bit
syn keyword sqlType blob bool boolean box bytea
syn keyword sqlType char character cidr circle date
syn keyword sqlType datetime decimal double float4 float8
syn keyword sqlType inet int2 int4 int8 integer
syn keyword sqlType interval large line lseg macaddr
syn keyword sqlType money name numeric object oid
syn keyword sqlType path point polygon precision real record
syn keyword sqlType reltime serial serial4 serial8 smallint
syn keyword sqlType text time timestamp timestamptz timetz
syn keyword sqlType varbit varchar varying with without
syn keyword sqlType zone


syn keyword sqlCommonFunction abbrev abs acos age area ascii asin atan atan2 bit_length
syn keyword sqlCommonFunction box broadcast btrim cbrt ceil center character_length chr circle coalesce
syn keyword sqlCommonFunction convert cos cot count current_date current_time current_timestamp currval date_part date_trunc
syn keyword sqlCommonFunction decode degrees diameter encode exp extract floor found has_table_privilege height host
syn keyword sqlCommonFunction ilike initcap isclosed isfinite isopen length like ln log lower
syn keyword sqlCommonFunction lpad lseg ltrim masklen max min mod netmask network nextval
syn keyword sqlCommonFunction now npoint nullif octet_length path pclose pg_client_encoding pi point polygon
syn keyword sqlCommonFunction popen position pow radians radius random repeat round rpad rtrim
syn keyword sqlCommonFunction set_masklen setseed setval sign sin sqrt stddev strpos substr substring
syn keyword sqlCommonFunction sum switch tan timeofday timestamp to_ascii to_char to_date to_number
syn keyword sqlCommonFunction to_timestamp translate trim trunc upper variance width

" Numbers:
syn match sqlNumber		"-\=\<\d*\.\=[0-9_]\>"
syn match sqlArgument "\$\d\+"

syn match sqlOperator "[:+*=/<>-]"

" Comments:
syn match sqlBracket "[\[\](){}]"
syn region sqlComment    start="/\*"  end="\*/"
syn match sqlComment	"--.*"

" Strings and characters:
syn region sqlString		start=+"+  skip=+\\\\\|\\"+  end=+"+ 
syn region sqlString		start=+'+  skip=+\\\\\|\\'+  end=+'+
syn region sqlFunctionString    start="''" end="''" contained
syn region sqlFunctionBody      start="'$"  end="^'" contains=sqlStatement,sqlKeyword,sqlType,sqlOperator,sqlSpecial,sqlFunctionString,sqlNumber,sqlComment,sqlOperator,sqlBracket,sqlArgument,sqlCommonFunction

syn sync ccomment sqlComment

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_sql_syn_inits")
  if version < 508
    let did_sql_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink sqlComment	Comment
  HiLink sqlKeyword	sqlSpecial
  HiLink sqlNumber	Number
  HiLink sqlSpecial	Special
  HiLink sqlStatement	Statement
  HiLink sqlString	String
  HiLink sqlFunctionString      String
  HiLink sqlType	Type
  HiLink sqlOperator sqlOperator
  HiLink sqlBracket sqlBracket
  HiLink sqlCommonFunction sqlCommonFunction

  " hi sqlOperator ctermfg=White
  " hi sqlBracket ctermfg=DarkGreen
  " hi sqlCommonFunction ctermfg=LightBlue
  " hi Comment ctermbg=black ctermfg=DarkBlue
  " hi Cursor ctermbg=red ctermfg=Yellow

  delcommand HiLink
endif

let b:current_syntax = "pgsql"

" vim: ts=8
