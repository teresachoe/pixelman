(* Ocamllex scanner for MicroC *)

{ open Parser }

let character = [' '-'!' '#'-'[' ']'-'~'] | ('\\' ['\\' ''' '"' 'n' 'r' 't'])
let digit = ['0'-'9']

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| ":)"     { comment lexbuf }           (* Comments *)

    (* Operators and Separators *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ';'      { SEMI }
| ','      { COMMA }
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '='      { ASSIGN }
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| "&&"     { AND }
| "||"     { OR }
| "!"      { NOT }
| "."      { DOT }
| "["      { LBRACKET } 
| "]"      { RBRACKET } 
| "|"      { BITOR }
| "%"      { MOD } 
| "<<"     { LSHIFT } 
| ">>"     { RSHIFT }
| "&"      { BITAND }
| "^"      { BITXOR } 
| "*="     { MULTASSIGN } 
| "/="     { DIVASSIGN }
| "%="     { MODASSIGN } 
| "+="     { PLUSASSIGN } 
| "-="     { SUBASSIGN } 
| ">>="    { RASSIGN } 
| "<<="    { LASSIGN } 
| "&="     { ANDASSIGN } 
| "!="     { NOTASSIGN } 
| "//"     { DIVINT } 

(* Branching Control *)
| "if"       { IF }
| "else"     { ELSE }
| "for"      { FOR }
| "continue" { CONTINUE } 
| "break"    { BREAK } 
| "while"    { WHILE }
| "return"   { RETURN }
| "def"      { DEF } 
| "main"     { MAIN } 
| "throw"    { THROW } 

(* Data and Return Types *)
| "char"   { CHAR }
| "int"    { INT }
| "float"  { FLOAT } 
| "bool"   { BOOL }
| "string" { STRING }
| "void"   { VOID }
| "true"   { TRUE }
| "false"  { FALSE }
| "Image"  { IMAGE } 
| "Pixel"  { PIXEL }  
| "null"   { NULL } 

(* Literals *)
| ('-'?) digit+    as lxm    { INT_LITERAL(int_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| ''' character '''    as lxm    { CHAR_LITERAL(lxm.[1]) }
| '"' (character*) '"' as lxm    { STRING_LITERAL(lxm) }
| ('-'?) (digit+) ['.'] digit+ as lxm   { FLOAT_LITERAL(lxm) } 

| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  ":)" { token lexbuf }
| _    { comment lexbuf }
