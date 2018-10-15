(*                ast.mli LOG

[10/11/18] Ryan : this ast.mli file is taken from HW1
[10/09/18] Ryan : setTypes and Set

*)

type op = Add | Sub | Mul | Div | Mod | Eq | Union | Isec | Elof | Comp | Neq | And | Or
type unop = Not (* cardinality is a delim like () *)
type elmTypes = boolean | int | char | array| set (*more set types could be added here in future*)
type datatype = setType of elmTypes | dataType of elmTypes | arrType of elmTypes


type expr =
Binop of expr * op * expr
| intLit of int
| charLit of char
| boolLit of boolean
| Set of elmTypes
| Arr of elmTypes
| Unop of unop * expr (* if we do string types or array slicing, their syntactic sugar needs to go here *)

and stmt =
    Block of stmt
    | Expr of expr
    | If of expr * stmt * stmt
    | For of expr * stmt 
    | Foreach of expr * stmt
    | Return of expr
    | Break
    | SetElementAssign of stmt
    | ArrayElementAssign of stmt
    | Assign of elmTypes * expr
