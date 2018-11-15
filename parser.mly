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
%token LT LEQ GT GEQ EQ NEQ AND OR NOT

/* Control Flow */
%token IF ELSE FOR FOREACH IN RETURN BREAK

/* Literals, Identifiers, EOF */
%token <int> NUM_LIT /* we are only doing ints rn, if add floats will need to make an AST.num type that handles both */
%token <char> CHAR_LIT
%token <string> VARIABLE
%token EOF

/* Order and Associativity */
%nonassoc NOELSE
%nonassoc ELSE
%left PLUS MINUS TIMES DIVIDE MOD 
%left UNION INTSEC ELEM COMP
%left LT LEQ GT GEQ EQ NEQ NSEQ
%left OR AND
%right ASSIGN NOT

%start program
%type <Ast.program> program
%%

program: decls EOF { $1 }

decls: /* nothing */   { [], []                 }
     | decls vdecl    { ($2 :: fst $1), snd $1 } 
     | decls fdecls    { fst $1, ($2 :: snd $1) } 

fdecls: dtype VARIABLE LPAREN params RPAREN LBRACE vdecls stmts RBRACE {
          {
            ftype = $1;
            fname = $2;
            parameters = List.rev $4;
            locals = List.rev $7;
            body = List.rev $8
          }
        }

params: /* nothing */               { []             }
      | dtype VARIABLE               { [($1,$2)]      }
      | params COMMA dtype VARIABLE  { ($3, $4) :: $1 }


dtype: INT       { Int }
     | BOOL      { Boolean}
     | CHAR      { Char }
     | SET       { Set }

vdecls: /* nothing */   { [] }
      | vdecls vdecl    { $2 :: $1 }

vdecl: dtype VARIABLE SEMI { ($1, $2) }

stmts: /* nothing */    { [] }
     | stmts stmt       { $2 :: $1 }

stmt:
    expr SEMI                                                   { Expr $1 }
  | BREAK SEMI                                                  { Break }
  | RETURN expr SEMI                                            { Return $2 } /* Consider optional expressions */
  | LBRACE stmts RBRACE                                         { Block(List.rev $2) }
  | IF LPAREN expr RPAREN stmt %prec NOELSE                     { If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt                        { If($3, $5, $7) }
  | FOR LPAREN expr SEMI expr SEMI expr RPAREN stmt             { For($3, $5, $7, $9) } /* Consider optional expressions */
  | FOREACH LPAREN expr IN expr RPAREN stmt                     { ForEach($3, $5, $7) }
  | VARIABLE ASSIGN expr                                        { Assign($1, $3) } /* Consider Variable ASSIGN expre */

expr:
    NUM_LIT                                                     { IntLit($1) }
  | CHAR_LIT                                                    { CharLit($1) }
  | TRUE                                                        { BoolLit(true) }
  | FALSE                                                       { BoolLit(false) }
  | VARIABLE                                                    { Variable($1) } 
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
  | expr INTSEC expr                                            { Binop($1, Isec, $3) }
  | expr COMP expr                                              { Binop($1, Comp, $3) }
  | expr ELEM expr                                              { Binop($1, ElOf, $3) }
  | NOT expr                                                    { Unop(Not, $2) }
  | VARIABLE LPAREN fparams RPAREN                              { Call($1, List.rev $3) } /* consider using optional args */
  | LPAREN expr RPAREN                                          { $2 }
 /* | LBRACKET set RBRACKET                                       { $2 }*/

fparams: expr                       { [$1] }
       | fparams COMMA expr         { $3 :: $1 }

/*set: expr           { [$1] }
   | set COMMA expr { $3 :: $1 }*/
