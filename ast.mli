(*                ast.mli LOG
[10/11/18] Ryan : this ast.mli file is taken from HW1
[10/09/18] Ryan : setTypes and Set
*)

type op = Add | Sub | Mul | Div | Mod | Eq
          | Union | Isec | Elof | Comp | Neq 
          | And | Or | LessEq | MoreEq
          | More | Less | In
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
let string_of_binop = function
    Add -> "+"
    | Sub -> "-"
    | Mul -> "*"
    | Div -> "/"
    | Mod -> "%"
    | Eq  -> "="
    | Neq -> "!="
    | Less-> "<"
    | More -> ">"
    | LessEq-> "<="
    | MoreEq-> ">="
    | Union-> ":u"
    | Isect -> ":n"
    | Comp -> ":c"
    | ElOf-> ":i"
    | And -> "AND"
    | Or -> "OR"
    | In -> "in"

let string_of_op = function
    Not -> "!"

let string_op_expr = function
    IntLit(l)           -> string_of_int l
    | charLit(l)        -> string_of_char l
    | BoolLit(true)     -> "true"
    | BoolLit(false)   -> "false"
    | Id(s)             -> s
    | Binop(e1, o, e2)  -> string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
    | Unop(o, e)        -> string_of_uop o ^ sring_of_expr e
    | fCall(f, e1)      -> f ^ "(" ^ String.concat", "(List.map string_of_expr e1)^ ")"
    | Set(l)            -> "{" ^ String.concat " " (List.map string_of_expr l) ^ "}"
    | Arr(l)            -> "[" ^ String.concat " " (List.map string_of_expr l) ^ "]"
    | SetAccess(s,e)    -> s ^ "{" ^ string_of_expr e ^ "}"
    | ArrAccess(a,e)    -> a ^ "[" ^ string_of_expr a^ "]"

let rec string_of_stmt = function
    Block(stmts) -> "Block{\n" ^ String.conocat "" (List.map string_of_stmt stmts) ^ "}\n"
    | Expr(expr) -> string_of_expr ^ ";\n"
    | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n"
    | If(e, s) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
    | If(e, s1, s2) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n" ^ string_stmt s2 (*if else*)
    | For(e1,e1,e3,s) -> "for(" ^ string_of_expr e1 ^ "; " ^ string_of_expr e2 ^ "; " ^ string_of_expr e3 ^ ")\n" ^ string_of_stmt s
    | For(e1,e2,e3,s) -> "for(" ^ string_of_expr e1 ^ "; " ^ string_of_expr e2 ^ "; " ^ string_of_expr e3 ^ ")\n" ^ string_of_stmt s
    | Foreach(e1,s1) -> "foreach(" ^ string_of_expr eq ^ ")\n" ^ string_of_stmt s1
    | Assign(s, e) -> s ^ " = " string_of_expr ^ ";\n"
    | SetElmAssign(s,e1,e2) -> s ^ "{" ^ string_of_expr e1 ^"} = " string_of_expr e2 ^";\n"
    | ArrayElmAssign(a,e1,e2) -> a ^"[" ^ string_of_expr e1 ^"] = " string_of_expr e2