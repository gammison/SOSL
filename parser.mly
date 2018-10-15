/*                parser.mly LOG

[10/11/18] Ryan : this parser.mly file is taken from HW1

*/

%{ open Ast %}

/* Delimiters */
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token CARD SEMI COMMA COLON

/* Arithmetic Operators */
%token PLUS MINUS TIMES DIVIDE ASSIGN MOD

/* Data Types */
%token INT CHAR BOOL VOID SET

/* Boolean Values */
%token TRUE FALSE

/* Boolean Values */
%token UNION INTSEC ELEM COMP

/* Relational Operators */
%token LT LEQ GT GEQ EQ NEQ AND OR

/* Control Flow */
%token IF ELSE FOR FOREACH IN RETURN

/* Literals, Identifiers, EOF */
%token <Ast.num> NUM_LIT
%token <string> STRING_LIT
%token <string> ID
%token EOF

/* Order and Associativity */
%nonassoc ELSE
%left PLUS MINUS TIMES DIVIDE MOD 
%left UNION INTSEC ELEM COMP
%left LT LEQ GT GEQ EQ NEQ NSEQ
%left OR AND
%right ASSIGN

%start program
%type <Ast.program> program
%%

program:
    decls EOF { $1 }

decls: 
    | decls vinit { ($2 :: fst $1), snd $1 } 
    | decls function { fst $1, ($2 :: snd $1) } 

function:
  type VARIABLE LPAREN params RPAREN LBRACE stmts RBRACE {
    {
      ftype = $1;
      fname = $2;
      parameters = List.rev $4;
      body = List.rev $7;
    }
  }

params:
  type VARIABLE {[($1,$2)]}
| params COMMA type VARIABLE { ($3, $4) :: $1 }


type:
    INT       { Int }
  | BOOL      { Bool }
  | VOID      { Void }
  | CHAR      { Char }
  | SET       { Set }

init: 
  type VARIABLE SEMI { ($1, $2) }

vinit:
  VARIABLE ASSIGN expr SEMI { ($1, $3) }

vinits:
                 { [] }
  | vinits vinit { $2 :: $1 }

stmts:
               { [] }
  | stmts stmt { $2 :: $1 }

stmt:
    expr SEMI                                                   { Expr $1 }
  | BREAK SEMI                                                  { Break }
  | RETURN expr SEMI                                            { Return $2 }
  | LBRACE stmts RBRACE                                         { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt                                  { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt                        { If($3, $5, $7) }
  | FOR LPAREN expr_opt SEMI expr SEMI expr_opt RPAREN stmt     { For($3, $5, $7, $9) }
  | FOREACH LPAREN expr IN expr RPAREN stmt                     { ForEach($3, $5, $7) }

expr:
    NUM_LIT                                                     { IntLit($1) }
  | CHAR_LIT                                                    { charLit($1) }
  | TRUE                                                        { BoolLit(true) }
  | FALSE                                                       { BoolLit(false) }
  | VARIABLE                                                    { Id($1) }
  | expr PLUS expr                                              { Binop($1, Add, $3) }
  | expr MINUS expr                                             { Binop($1, Sub, $3) }
  | expr TIMES expr                                             { Binop($1, Mul, $3) }
  | expr DIVIDE expr                                            { Binop($1, Div, $3) }
  | expr MOD expr                                               { Binop($1, Mod, $3) }
  | expr EQ expr                                                { Binop($1, Eq, $3) }
  | expr NEQ expr                                               { Binop($1, Neq, $3) }
  | expr LT expr                                                { Binop($1, Less, $3) }
  | expr LEQ expr                                               { Binop($1, LessEq, $3) }
  | expr GT expr                                                { Binop($1, More, $3) }
  | expr GEQ expr                                               { Binop($1, MoreEq, $3) }
  | expr AND expr                                               { Binop($1, And, $3) }
  | expr OR expr                                                { Binop($1, Or, $3) }
  | expr UNION expr                                             { Binop($1, Union, $3) }
  | expr INTSEC expr                                            { Binop($1, Isect, $3) }
  | expr COMP expr                                              { Binop($1, Comp, $3) }
  | expr ELEM expr                                              { Binop($1, ElOf, $3) }
  | NOT expr                                                    { Unop(Not, $2) }
  | expr ASSIGN expr                                            { Assign($1, $3) }
  | ID LPAREN fparams RPAREN                                { Call($1, $3) }
  | LPAREN expr RPAREN                                          { $2 }
  | LBRACE expr RBRACE                                          { Set }






















expr:
expr PLUS expr { Binop($1, Add, $3) }
| expr MINUS expr { Binop($1, Sub, $3) }
| expr TIMES expr { Binop($1, Mul, $3) }
| expr DIVIDE expr { Binop($1, Div, $3) }
| expr SEQUENCE expr { Seq($1, $3) }
| VARIABLE { Var($1) }
| VARIABLE ASSIGN expr { Asn($1, $3) }
| LITERAL { Lit($1) }