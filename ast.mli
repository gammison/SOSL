(*                ast.mli LOG

[10/11/18] Ryan : this ast.mli file is taken from HW1
[10/09/18] Ryan : setTypes and Set

*)

type op = Add | Sub | Mul | Div | Mod | Eq | Union | Isec | Elof | Comp | Neq | And | Or
type unop = Not (* cardinality is a delim like () *)
type elmTypes = boolean | int | char | array| set (*more set types could be added here in future*)
type datatype = setType of elmTypes | litType of elmTypes | arrType of elmTypes | void


type expr =
Binop of expr * op * expr
| intLit of int
| charLit of char
| boolLit of boolean
| Set of elmTypes list
| Arr of elmTypes list
| SetAccess of string * expr
| ArrayAccess of string * expr
| fCall of string * expr list
| Unop of unop * expr (* if we do string types or array slicing, their syntactic sugar needs to go here *)

and stmt =
    Block of stmt list 
    | Expr of expr
    | If of expr * stmt * stmt
    | For of expr * expr * expr * stmt 
    | Foreach of expr * stmt
    | Return of expr
    | Break
    | SetElementAssign of string * expr * expr
    | ArrayElementAssign of string * expr * expr
    | Assign of string * expr

type fdecl = { (* function declaration *)
    ftype : datatype
    fname : string
    parameters: string list
    body : stmt list
}
type global = string * expr (* global assignments *)
type program = global list * fdecl list (* a valid program is some globals and function declarations *)

(* add pretty printing for the AST ie Add -> "+" *)
let string_of_op = function
    Add -> "+"
    | Sub -> "-"
    | Mul -> "*"
    | Div -> "/"
    | Mod -> "%"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"
    | Sub -> "-"


