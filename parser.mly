(*                parser.mly LOG

[10/11/18] Ryan : this parser.mly file is taken from HW1

*)

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
%token LT LEQ GT GEQ EQ NEQ NSEQ AND OR

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

stmts:
  | stmts stmt { $2 :: $1 }

stmt:
    expr SEMI                                                   { Expr $1 }
  | RETURN SEMI                                                 { Return Noexpr } (* Later *)
  | RETURN expr SEMI                                            { Return $2 }
  | LBRACE stmts RBRACE                                         { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt                                  { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt                        { If($3, $5, $7) }
  | FOR LPAREN expr_opt SEMI expr SEMI expr_opt RPAREN stmt     { For($3, $5, $7, $9) }
  | FOREACH LPAREN expr IN expr RPAREN stmt                     { ForEach($3, $5, $7) }

























expr:
expr PLUS expr { Binop($1, Add, $3) }
| expr MINUS expr { Binop($1, Sub, $3) }
| expr TIMES expr { Binop($1, Mul, $3) }
| expr DIVIDE expr { Binop($1, Div, $3) }
| expr SEQUENCE expr { Seq($1, $3) }
| VARIABLE { Var($1) }
| VARIABLE ASSIGN expr { Asn($1, $3) }
| LITERAL { Lit($1) }