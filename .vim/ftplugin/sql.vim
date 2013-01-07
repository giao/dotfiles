iab <buffer> crtrig CREATE OR REPLACE FUNCTION<Esc>mqa() RETURNS TRIGGER AS<Return>$BODY$<Return>DECLARE<Return>BEGIN<Return>END;<Return>$BODY$<Return>LANGUAGE 'plpgsql';<Return>CREATE TRIGGER  AFTER BEFORE  ON  FOR EACH ROW EXECUTE PROCEDURE ();<Esc>`qa
iab <buffer> ai AUTO_INCREMENT
iab <buffer> ise <Esc>BvEyAIS NULL or <Esc>pA = ''''
iab <buffer> alter ALTER
iab <buffer> and AND
iab <buffer> at ALTER TABLE
iab <buffer> auto_increment AUTO_INCREMENT
iab <buffer> begin BEGIN
iab <buffer> by BY
iab <buffer> create CREATE
iab <buffer> crf CREATE OR REPLACE FUNCTION
iab <buffer> cri CREATE INDEX
iab <buffer> crs CREATE SEQUENCE
iab <buffer> crt CREATE TABLE
iab <buffer> crui CREATE UNIQUE INDEX
iab <buffer> crv CREATE VIEW
iab <buffer> database DATABASE
iab <buffer> db DATABASE
iab <buffer> default DEFAULT
iab <buffer> def DEFAULT
iab <buffer> del DELETE FROM
iab <buffer> delete DELETE FROM
iab <buffer> drop DROP
iab <buffer> else ELSE
iab <buffer> end END
iab <buffer> fkey FOREIGN KEY
iab <buffer> foreign FOREIGN
iab <buffer> from FROM
iab <buffer> gd GET DIAGNOSTICS = ROW_COUNT;<Esc>bbhi
iab <buffer> having HAVING
iab <buffer> if IF
iab <buffer> ii INSERT INTO
iab <buffer> inf IF NOT FOUND
iab <buffer> index INDEX
iab <buffer> insert INSERT INTO
iab <buffer> int8 INT8
iab <buffer> int4 INT4
iab <buffer> interval INTERVAL
iab <buffer> i4 INT4
iab <buffer> i8 INT8
iab <buffer> into INTO
iab <buffer> is IS
iab <buffer> key KEY
iab <buffer> lg LANGUAGE
iab <buffer> limit LIMIT
iab <buffer> nf NOT FOUND
iab <buffer> nn NOT NULL
iab <buffer> not NOT
iab <buffer> null NULL
iab <buffer> nv NEXTVAL
iab <buffer> ob ORDER BY
iab <buffer> or OR
iab <buffer> order ORDER
iab <buffer> pkey PRIMARY KEY
iab <buffer> primary PRIMARY
iab <buffer> ref REFERENCES
iab <buffer> ret RETURN
iab <buffer> rets RETURNS
iab <buffer> return RETURN
iab <buffer> returns RETURNS
iab <buffer> RETURNS RETURNS
iab <buffer> rtf RETURN ''f''::bool;
iab <buffer> schema SCHEMA
iab <buffer> select SELECT
iab <buffer> seq SEQUENCE
iab <buffer> sequence SEQUENCE
iab <buffer> set SET
iab <buffer> table TABLE
iab <buffer> then THEN
iab <buffer> text TEXT
iab <buffer> unique UNIQUE
iab <buffer> update UPDATE
iab <buffer> values VALUES
iab <buffer> where WHERE

setlocal nowrap
setlocal tw=10000
setlocal ai

map <silent> <F1>	<Esc>:set noai<Enter>V:!perl -ne 'chomp;s/\s*,\s*/,/g;s/\s+/ /;@a=split;$a[2]=uc($a[2]);@b=map{uc}split(/,/,$a[1]);printf("-- Function name: \%s\012-- Description  : \012-- Parameters:\012",$a[0]);for $c(0..$\#b){printf("-- \%2u. \%-8s :\n",$c+1,$b[$c])}printf("-- Returns:\012--     \%-8s : \012",$a[2]);printf("CREATE OR REPLACE FUNCTION \%s(\%s) RETURNS \%s AS \047\012DECLARE\012", $a[0], join(", ",@b), $a[2]);for $c (0..$\#b){printf("	in_                  ALIAS FOR \$\%u;\012",$c+1)}print"BEGIN\012END;\012\047 LANGUAGE \047plpgsql\047;\012"'<Enter><Enter>:set ai<Enter>
map <silent> <F2>	<Esc>VyPV:s/^CREATE\+\s\+\(\S\+\s\+[^ ;(]\+\(([^)]\+)\)\=\).*$/DROP \1;/i<Enter>/qwdfqdq<Enter>

" tworzenie tabel ze stringów typu: tabela pole1 typ1, pole2 typ2
map <silent> <F10>	V:!~/.vim/addons/sql-createTable<Return>
vmap <silent> <F10>	:!~/.vim/addons/sql-createTable<Return>

" wstawianie indeksów unikalnych (ctrl-x) i zwyk³ych <alt-x>
map <silent> <C-x>	mf^vE"fy?^CREATE TABLE<Return>2WvE"ty/^)<Return>oCREATE UNIQUE INDEX ui_<C-r>t_<C-r>f ON <C-r>t (<C-r>f);<Esc>`f
map <silent> <M-x>	mf^vE"fy?^CREATE TABLE<Return>2WvE"ty/^)<Return>oCREATE INDEX i_<C-r>t_<C-r>f ON <C-r>t (<C-r>f);<Esc>`f

" wstawianie/usuwanie NOT NULL
map <silent> <C-n>	V:!~/.vim/addons/sql-notNull<Return>
vmap <silent> <C-n>	:!~/.vim/addons/sql-notNull<Return>

" wstawianie FOREIGN KEY
map <silent> <C-f>	mf^vE"fy?^CREATE TABLE<Return>2wvE"ty/^)<Return>oALTER TABLE <C-r>t ADD FOREIGN KEY (<C-r>f) REFERENCES <C-r>f<Esc>:s/_id$//<Enter>:s/s$/se/e<Enter>As (id);<Esc>`f
