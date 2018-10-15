(*                scanner.mll LOG

[10/08/18] Ryan : this scanner.mll file is taken from HW1
[10/09/18] Ryan : fundamental structure

*)

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
| "=="  { EQ } 
| "!="  { NEQ } 
| "=="  { SEQ } 
| "!==" { NSEQ }
| "AND" { AND }
| "OR"  { OR }

(* Control Flow *)
| "if"  { IF } 
| "else" { ELSE } 
| "for"  { FOR }
| "forEach" { FOREACH } 
| "in" { IN } 
| "return" { RETURN } 

(* Literals and EOF *)
| ['0'-'9']+ as lxm { NUM_LIT(Ast.IntLit(int_of_string lxm)) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']*+ as lxm { VARIABLE(lxm) }
| eof { EOF }
