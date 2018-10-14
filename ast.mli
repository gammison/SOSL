(*                ast.mli LOG

[10/11/18] Ryan : this ast.mli file is taken from HW1
[10/09/18] Ryan : setTypes and Set

*)

type op = Add | Sub | Mul | Div | Mod | Eq | Union | Isec | Elof | Comp | Neq | SNeq
type setTypes = int | set (*more set types could be added here in future*)


type expr =
Binop of expr * operator * expr
| Lit of int
| Seq of expr * expr
| Asn of string * expr
| Var of string
| Set of setTypes
| Union of set * u: *set
| Isect of set * n: * set
| Elof of setTypes * i: * set
| Comp of set * c: * set



let string_of_op = function
   Add    -> "+"
  |Sub    -> "-"
  |Mul    -> "*"
  |Div    -> "/"
  |Mod    -> "%"
  |Eq     -> "==="
  |Union  -> "u:"
  |Isec   -> "n:"
  |Elof   -> "i:"
  |Comp   -> "c:"
  |Neq    -> "!="
  |SNeq   -> "!=="

    
