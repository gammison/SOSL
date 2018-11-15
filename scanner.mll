{ open Parser }

rule token = parse 
(* Whitespace*)
[' ' '\t' '\r' '\n'] { token lexbuf }

(* Delimiters *)
| '(' { LPAREN }
| ')' { RPAREN }
| '[' { LBRACKET }
| ']' { RBRACKET }
| '{' { LBRACE }
| '}' { RBRACE }
| '|' { CARD }
| ';' { SEMI } 
| ',' { COMMA } 
| ':' { COLON } 

(* Arithmetic Operators *)
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIVIDE }
| '=' { ASSIGN }
| '%' { MOD }

(* Data Type *)
| "int"     { INT }
| "char"    { CHAR }
| "boolean" { BOOL }
| "void"    { VOID }
| "set"     { SET }

(* Boolean Type *)
| "true"     { TRUE }
| "false"    { FALSE }

(* Set Operators *)
| ":u" { UNION }
| ":n" { INTSEC }
| ":i" { ELEM }
| ":c" { COMP }

(* Relational Operators *)
| '<'   { LT } 
| "<="  { LEQ } 
| '>'   { GT }
| ">="  { GEQ } 
| "=="  { EQ }  (* we got rid of SEQ and NSEQ *)
| "!="  { NEQ } 
| "AND" { AND }
| "OR"  { OR }
| "!"   { NOT } 

(* Control Flow *)
| "if"  { IF } 
| "else" { ELSE } 
| "for"  { FOR }
| "forEach" { FOREACH } 
| "in" { IN } 
| "return" { RETURN } 
| "break" { BREAK }
(* Literals and EOF *)
| ['0'-'9']+ as lxm { NUM_LIT(int_of_string lxm)}
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']*+ as lxm { VARIABLE(lxm) }
| eof { EOF }
