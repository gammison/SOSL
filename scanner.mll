{open Parser }

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
| "string"  { STRING }

(* Boolean Type *)
| "true"     { BLIT(true) }
| "false"    { BLIT(false) }

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
| '"' { read_string (Buffer.create 17) lexbuf } 
| '"' (([^ '"'] | "\\\"")* as strlit) '"' { STR_LIT(strlit) } 
| '''([' '-'!' '#'-'[' ']'-'~' ]|['0'-'9'])''' as lxm {CHAR_LIT( String.get lxm 1)}
| eof { EOF }
| _ { raise (Failure ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }

(* nice string parser from https://v1.realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html *) 
and read_string buf =
      parse
        | '"'       { STR_LIT (Buffer.contents buf) }
        | '\\' '/'  { Buffer.add_char buf '/'; read_string buf lexbuf }
        | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
        | '\\' 'b'  { Buffer.add_char buf '\b'; read_string buf lexbuf }
        | '\\' 'f'  { Buffer.add_char buf '\012'; read_string buf lexbuf }
        | '\\' 'n'  { Buffer.add_char buf '\n'; read_string buf lexbuf }
        | '\\' 'r'  { Buffer.add_char buf '\r'; read_string buf lexbuf }
        | '\\' 't'  { Buffer.add_char buf '\t'; read_string buf lexbuf }
        | [^ '"' '\\']+
        { Buffer.add_string buf (Lexing.lexeme lexbuf);
                read_string buf lexbuf
        }
        | _ { raise (Failure ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
        | eof { raise (Failure ("String is not terminated")) }
        | eof { EOF }
