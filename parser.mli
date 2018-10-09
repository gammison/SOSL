(*                parser.mli LOG

[10/08/18] Ryan : this parser.mli file is taken from HW1

*)


type token =
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | EOF
  | ASSIGN
  | SEQUENCE
  | LITERAL of (int)
  | VARIABLE of (string)

val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
