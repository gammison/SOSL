type op = Add | Sub | Mul | Div | Mod | Eq
          | Union | Isec | Elof | Comp | Neq 
          | And | Or | LessEq | MoreEq
          | More | Less
type unop = Not (* cardinality is a delim like () *)
type elmTypes = Int | Boolean | Char | String | Void | Set of elmTypes    
type bind = elmTypes * string
type expr = 
          | IntLit              of int
          | CharLit             of char
          | BoolLit             of bool
          | StrLit              of string
	    | SetLit 	        of expr list
          | Variable            of string
          (*| SetAccess           of string * expr
          | ArrLit		of expr list
          | ArrayAccess         of string * expr *)
          | Call                of string * expr list
          | Binop               of expr * op * expr
          | Unop                of unop * expr (* if we do string types or array slicing, their syntactic sugar needs to go here *)
          | Noexpr               
          | Assign               of string * expr

(* and arr = ArrLit of expr *)

and stmt = Block                of stmt list 
         | Expr                 of expr
         | If                   of expr * stmt * stmt
         | For                  of expr * expr * expr * stmt 
        (* | ForEach              of expr * expr * stmt*)
         | Return               of expr
         | Break
	   | While	              of expr * stmt
         (* | SetElementAssign     of string * expr * expr
         | ArrayElementAssign   of string * expr * expr *)


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
    | Eq        -> "=="
    | Neq       -> "!="
    | Less      -> "<"
    | More      -> ">"
    | LessEq    -> "<="
    | MoreEq    -> ">="
    | Union     -> ":u"
    | Isec      -> ":n"
    | Comp      -> ":c"
    | Elof      -> ":i"
    | And       -> "AND"
    | Or        -> "OR"

let string_of_unop = function
    Not -> "!"


let rec string_of_expr = function
      IntLit(l)             -> string_of_int l
    | CharLit(c)	          -> Char.escaped c
    | StrLit(strlit)        -> strlit 
    | BoolLit(true)         -> "true"
    | BoolLit(false)        -> "false"
    | Assign(s, e)          -> s ^ " = " ^ string_of_expr e ^ ";\n"
    | SetLit(s)             -> "Set:{" ^ String.concat "" (List.map string_of_expr s) ^ "}:\n"
    | Variable(s)           -> s 
    | Binop(e1, o, e2)      -> string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
    | Unop(o, e)            -> string_of_unop o ^ string_of_expr e
    | Call(f, e1)           -> f ^ "(" ^ String.concat", "(List.map string_of_expr e1)^ ")"
    | Noexpr                -> "noexpr"
    (* | SetAccess (s,e)       -> s ^ "{" ^ string_of_expr e ^ "}"
    | ArrayAccess (s,e)     -> s ^ "[" ^ string_of_expr e ^ "]" *)

let rec string_of_stmt = function
    Block(stmts)                -> "Block{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
    | Expr(expr)                -> string_of_expr expr ^ ";\n"
    | Return(expr)              -> "return " ^ string_of_expr expr ^ ";\n"
    | If(e,s1,s2)               -> "if(" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2 (*if else*)
    | For(e1,e2,e3,s)           -> "for(" ^ string_of_expr e1 ^ "; " ^ string_of_expr e2 ^ "; " ^ string_of_expr e3 ^ ")\n" ^ string_of_stmt s
    (*| ForEach(e1,e2,s)          -> "foreach(" ^ string_of_expr e1 ^ " in " ^ string_of_expr e2 ^ ")\n" ^ string_of_stmt s *)
    | While(e, s)               -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s
    (*| SetElementAssign(s,e1,e2)     -> s ^ "{" ^ string_of_expr e1 ^"} = " ^ string_of_expr e2 ^";\n"
    | ArrayElementAssign(a,e1,e2)   -> a ^"[" ^ string_of_expr e1 ^"] = " ^ string_of_expr e2 ^";\n"*)
    | Break                     -> "break;\n"

let rec string_of_typ = function
        Int         		-> "int"
      | String      		-> "string"
      | Char        		-> "char"
      | Boolean     		-> "bool"
      | Void        		-> "void"
      | Set(l) 			-> "set:{" ^ string_of_typ l ^ "}:" 


let string_of_set (e) = "Set{" ^ String.concat "" (List.map string_of_expr e) ^ "}\n"

let string_of_bind (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_vinit (s, e) = s ^ " = " ^ string_of_expr e ^ ";\n"

let string_of_fdecl fdecl =
    string_of_typ fdecl.ftype ^ " " ^ fdecl.fname ^ "(" ^ String.concat "," (List.map snd fdecl.parameters) ^
    ")\n{\n" ^ String.concat "" (List.map string_of_stmt fdecl.body) ^ "}\n"

let string_of_program (vars, funcs) =
    String.concat "" (List.map string_of_bind vars) ^ "\n" ^ String.concat "\n" (List.map string_of_fdecl funcs) ^
    String.concat ";\n" (List.map string_of_fdecl funcs)
