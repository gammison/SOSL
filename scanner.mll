(*                scanner.mll LOG

[10/08/18] Ryan : this scanner.mll file is taken from HW1

*)



{ open Parser }

rule token =
parse [' ' '\t' '\r' '\n'] { token lexbuf }
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIVIDE }
| '=' { ASSIGN }
| ';' { SEQUENCE }
| ['0'-'9']+ as lit { LITERAL(int_of_string lit) }
| ['a'-'z']+ as id { VARIABLE(id) }
| eof { EOF }