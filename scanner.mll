(* Ocamllex scanner for pixelman 
 * Brian Tsau
 * Teresa Choe
 * Gabriel Kramer-Garcia
 * Anthony Chan
 * *)

{ open Parser }

let character = [' '-'!' '#'-'[' ']'-'~'] | ('\\' ['\\' ''' '"' 'n' 'r' 't'])
let digit = ['0'-'9']
let whitespace = [' ' '\t' '\n' '\r'] 
let float_lit = (digit*) ['.'] digit+
let int_lit = digit+

rule token = parse
  whitespace { token lexbuf }             (* Whitespace *)
  | ":)"     { sl_comment lexbuf } 
  | "(:"     { comment lexbuf }

  (* Separators *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ';'      { SEMI }
| ','      { COMMA }
| "["      { LBRACKET } 
| "]"      { RBRACKET } 
| "[|"     { LMATBRACK } 
| "|]"     { RMATBRACK } 
(*| ':'      { COLON } *)
| "."      { DOT } 

	(* Assignment Operators *)
| '='      { ASSIGN }

	(* Casting Operators *)
| "$int"    { INTCAST }
| "$float"  { FLOATCAST } 

    (* Binary Arithmetic Operators *)
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| "%"      { MOD } 

	(* Binary Comparison Operators *)
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }

	(* Binary Boolean Operators *)
| "&&"     { AND }
| "||"     { OR }

	(* Unary Boolean Operators *)
| "!"      { NOT }

	(* Binary Bitwise Operators *)
| "|"      { BITOR }
| "<<"     { LSHIFT } 
| ">>"     { RSHIFT }
| "&"      { BITAND }
| "^"      { BITXOR } 

	(* Branching Control *)
| "if"       { IF }
| "else"     { ELSE }
| "for"      { FOR }
| "while"    { WHILE }
(* | "continue" { CONTINUE } 
| "break"    { BREAK } *)
| "return"   { RETURN }

	(* function definition *)
| "def"      { DEF } 

	(* Data and Return Types *)
| "char"   { CHAR }
| "int"    { INT }
| "float"  { FLOAT } 
| "bool"   { BOOL }
| "string" { STRING }
| "void"   { VOID }
| "true"   { TRUE }
| "false"  { FALSE }
(*| "Image"  { IMAGE }*)
| "sizeof" { SIZEOF }

(* Literals *)
| int_lit   as lxm    { INT_LITERAL(int_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| ''' character '''    as lxm    { CHAR_LITERAL(lxm.[1]) }
| '"' ((character*) as lxm) '"' { STRING_LITERAL(lxm) }
| float_lit as lxm   { FLOAT_LITERAL(float_of_string lxm) } 

(* Comment *) 
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse 
  ":)" { token lexbuf } 
  | _  { comment lexbuf } 

and sl_comment = parse
  | '\n' { token lexbuf }
  | _    { sl_comment lexbuf }
