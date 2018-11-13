type op = Add | Sub | Mul | Div | Mod | Eq
          | Union | Isec | Elof | Comp | Neq 
          | And | Or | LessEq | MoreEq
          | More | Less | In
type unop = Not (* cardinality is a delim like () *)
type elmTypes = Boolean | Int | Char | Array | Set (* more set types could be added here in future *)
type dataType = SetType of elmTypes | LitType of elmTypes | ArrType of elmTypes | Void
type bind = dataType * string

type expr = 
          | IntLit              of int
          | CharLit             of char
          | BoolLit             of bool
          (*Need Variable: Example -- Variable of string *)
          | Set                 of elmTypes list
          | Arr                 of elmTypes list
          | SetAccess           of string * expr
          | ArrayAccess         of string * expr
          | Call               of string * expr list
          | Binop               of expr * op * expr
          | Unop                of unop * expr (* if we do string types or array slicing, their syntactic sugar needs to go here *)

and stmt = Block                of stmt list 
         | Expr                 of expr
         | If                   of expr * stmt * stmt
         | For                  of expr * expr * expr * stmt 
         | Foreach              of expr * stmt
         | Return               of expr
         | Break                of string 
         | SetElementAssign     of string * expr * expr
         | ArrayElementAssign   of string * expr * expr
         | Assign               of string * expr

type fdecl = { (* function declaration *)
                ftype : dataType;
                fname : string;
                parameters: bind list; 
                locals: bind list;
                body : stmt list;
            }

type global = bind (* global assignments *) 
type program = global list * fdecl list (* a valid program is some globals and function declarations *)

(* add pretty printing for the AST ie Add -> "+" *)
let string_of_binop = function
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
    | In        -> "in"

(* let string_of_unop = function
    Not -> "!"

 let string_binop_expr = function
    IntLit(l)               -> string_of_int l
    | CharLit(l)            -> string_of_char l
    | BoolLit(true)         -> "true"
    | BoolLit(false)        -> "false"
    | Variable(s)           -> s 
    | Binop(e1, o, e2)      -> string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
    | Unop(o, e)            -> string_of_unop o ^ sring_of_expr e
    | Call(f, e1)           -> f ^ "(" ^ String.concat", "(List.map string_of_expr e1)^ ")"
    | Set(l)                -> "{" ^ String.concat " " (List.map string_of_expr l) ^ "}"
    | Arr(l)                -> "[" ^ String.concat " " (List.map string_of_expr l) ^ "]"
    | SetAccess(s,e)        -> s ^ "{" ^ string_of_expr e ^ "}"
    | ArrAccess(a,e)        -> a ^ "[" ^ string_of_expr a^ "]"

let rec string_of_stmt = function
    Block(stmts)                -> "Block{\n" ^ String.conocat "" (List.map string_of_stmt stmts) ^ "}\n"
    | Expr(expr)                -> string_of_expr ^ ";\n"
    | Return(expr)              -> "return " ^ string_of_expr expr ^ ";\n"
    | If(e, s)                  -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
    | If(e, s1, s2)             -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n" ^ string_stmt s2 (*if else*)
    | For(e1,e2,e3,s)           -> "for(" ^ string_of_expr e1 ^ "; " ^ string_of_expr e2 ^ "; " ^ string_of_expr e3 ^ ")\n" ^ string_of_stmt s
    | Foreach(e1,s1)            -> "foreach(" ^ string_of_expr eq ^ ")\n" ^ string_of_stmt s1
    | Assign(s, e)              -> s ^ " = " string_of_expr ^ ";\n"
    | SetElmAssign(s,e1,e2)     -> s ^ "{" ^ string_of_expr e1 ^"} = " string_of_expr e2 ^";\n"
    | ArrayElmAssign(a,e1,e2)   -> a ^"[" ^ string_of_expr e1 ^"] = " string_of_expr e2 ^";\n"
    | Break                     -> "break;\n"
    | Noexpr            -> "Noexpr"

let rec string_of_typ = function
      dataType(Int)           -> "int"
      | dataType(Char)        -> "char"
      | dataType(Boolean)        -> "boolean"
      | dataType(Void)        -> "void"
      | SetType(s)            -> string_of_typ (dataType(s))
      | ArrType(a)            -> string_of_typ (dataType(a))

let string_of_vinit (s, e) = s ^ " = " ^ string_of_expr e ^ ";\n"

let string_of_fdecl fdecl =
    fdecl.type ^ " " ^ fdecl.fname ^ "(" ^ String.concat "," (List.map (fun x -> x) fdecl.parameters) ^
    ")\n{\n" ^
    String.concat "" (List.map string_of_stm fdecl.body) ^ "}\n"

let string_of_prog (vars, funcs, Calls) =
    String.concat "" (List.map string_of_init vars) ^ "\n" ^ String.concat "\n" (List.map string_of_fdecl funcs) ^
    String.concat ";\n" (List.map string_of_expr Calls)
*)
