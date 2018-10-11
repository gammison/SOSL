(*                parser.mli LOG

[10/11/18] Ryan : this ast.mli file is taken from HW1
[10/09/18] Ryan : setTypes and Set

*)

type operator = Add | Sub | Mul | Div
type setTypes = int | set (*more types could be added in future*)

type expr =
Binop of expr * operator * expr
| Lit of int
| Seq of expr * expr
| Asn of string * expr
| Var of string
| Set of setTypes