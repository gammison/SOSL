type op = Add | Sub | Mul | Div | Mod | Eq
          | Union | Isec | Elof | Comp | Neq 
          | And | Or | LessEq | MoreEq
          | More | Less
type unop = Not (* cardinality is a delim like () *)
type elmTypes = Boolean | Int | Char | String | Void | Set (* more set types could be added here in future *)
type dataType = LitType of elmTypes | ArrType of elmTypes
type bind = elmTypes * string

type expr = 
          | IntLit              of int
          | CharLit             of char
          | BoolLit             of bool
          | StrLit              of string
          | Variable            of string
          | Set                 of elmTypes list
          | Arr                 of elmTypes list
          | SetAccess           of string * expr
          | ArrayAccess         of string * expr
          | Call                of string * expr list
          | Binop               of expr * op * expr
          | Unop                of unop * expr (* if we do string types or array slicing, their syntactic sugar needs to go here *)
          | Noexpr               
          | Assign               of string * expr
and stmt = Block                of stmt list 
         | Expr                 of expr
         | If                   of expr * stmt * stmt
         | For                  of expr * expr * expr * stmt 
         | ForEach              of expr * expr * stmt
         | Return               of expr
         | Break                
         | SetElementAssign     of string * expr * expr
         | ArrayElementAssign   of string * expr * expr

type fdecl = { (* function declaration *)
                ftype : elmTypes;
                fname : string;
                parameters: bind list; 
                locals: bind list;
                body : stmt list;
            }

type program = bind list * fdecl list (* a valid program is some globals and function declarations *)

(* add pretty printing for the AST ie Add -> "+" *)

let string_of_op = function
    Add         -> "+"
    | Sub       -> "-"
    | Mul       -> "*"
    | Div       -> "/"
    | Mod       -> "%"
    | Eq        -> "="
    | Neq       -> "!="
    | Less      -> "<"
    | More      -> ">"
    | LessEq    -> "<="
    | MoreEq    -> ">="
    | Union     -> ":u"
    | Isec     -> ":n"
    | Comp      -> ":c"
    | Elof      -> ":i"
    | And       -> "AND"
    | Or        -> "OR"

let string_of_unop = function
    Not -> "!"

let rec string_of_expr = function
      IntLit(l)             -> string_of_int l
    | CharLit(c)	    -> Char.escaped c
    | StrLit(strlit)        -> strlit 
    | BoolLit(true)         -> "true"
    | BoolLit(false)        -> "false"
    | Assign(s, e)          -> s ^ " = " ^ string_of_expr e ^ ";\n"
    | Variable(s)           -> s 
    | Binop(e1, o, e2)      -> string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
    | Unop(o, e)            -> string_of_unop o ^ string_of_expr e
    | Call(f, e1)           -> f ^ "(" ^ String.concat", "(List.map string_of_expr e1)^ ")"
(*
let rec string_of_stmt = function
    Block(stmts)                -> "Block{\n" ^ String.conocat "" (List.map string_of_stmt stmts) ^ "}\n"
    | Expr(expr)                -> string_of_expr ^ ";\n"
    | Return(expr)              -> "return " ^ string_of_expr expr ^ ";\n"
    | If(e, s)                  -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
    | If(e, s1, s2)             -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n" ^ string_stmt s2 (*if else*)
    | For(e1,e2,e3,s)           -> "for(" ^ string_of_expr e1 ^ "; " ^ string_of_expr e2 ^ "; " ^ string_of_expr e3 ^ ")\n" ^ string_of_stmt s
    | Foreach(e1,s1)            -> "foreach(" ^ string_of_expr eq ^ ")\n" ^ string_of_stmt s1
    | SetElmAssign(s,e1,e2)     -> s ^ "{" ^ string_of_expr e1 ^"} = " string_of_expr e2 ^";\n"
    | ArrayElmAssign(a,e1,e2)   -> a ^"[" ^ string_of_expr e1 ^"] = " string_of_expr e2 ^";\n"
    | Break                     -> "break;\n"
*)
let string_of_typ = function
        Int         -> "int"
      | String      -> "string"
      | Char        -> "char"
      | Boolean     -> "bool"
      | Void        -> "void"

(*
let string_of_vinit (s, e) = s ^ " = " ^ string_of_expr e ^ ";\n"

let string_of_fdecl fdecl =
    fdecl.ftype ^ " " ^ fdecl.fname ^ "(" ^ String.concat "," (List.map (fun x -> x) fdecl.parameters) ^
    ")\n{\n" ^
    String.concat "" (List.map string_of_stm fdecl.body) ^ "}\n"

let string_of_program (vars, funcs) = (vars, funcs)
    String.concat "" (List.map string_of_int vars) ^ "\n" ^ String.concat "\n" (List.map string_of_fdecl funcs) ^
    String.concat ";\n" (List.map string_of_fdecl funcs)*)
