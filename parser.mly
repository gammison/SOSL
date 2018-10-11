(*                parser.mly LOG

[10/11/18] Ryan : this parser.mly file is taken from HW1

*)

%{ open Ast %}

%token PLUS MINUS TIMES DIVIDE EOF
%token ASSIGN SEQUENCE
%token <int> LITERAL
%token <string> VARIABLE
%left PLUS MINUS
%left TIMES DIVIDE
%left SEQUENCE
%right ASSIGN
%start expr
%type <Ast.expr> expr
%%

expr:
expr PLUS expr { Binop($1, Add, $3) }
| expr MINUS expr { Binop($1, Sub, $3) }
| expr TIMES expr { Binop($1, Mul, $3) }
| expr DIVIDE expr { Binop($1, Div, $3) }
| expr SEQUENCE expr { Seq($1, $3) }
| VARIABLE { Var($1) }
| VARIABLE ASSIGN expr { Asn($1, $3) }
| LITERAL { Lit($1) }