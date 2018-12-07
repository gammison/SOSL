open Ast

type sexpr = elmTypes * sx
and sx = 
          | SIntLit              of int
          | SCharLit             of char
          | SBoolLit             of bool 
          | SStrLit              of string 
          | SVariable            of string
          | SSet                 of sexpr list
          | SSetAccess           of string * sexpr 
	  | SArrLit		 of sexpr list
          | SArrayAccess         of string * sexpr
          | SCall                of string * sexpr list 
          | SBinop               of sexpr * op * sexpr 
          | SUnop                of unop * sexpr (* if we do string or array slicing, their syntactic sugar here *)
          | SNoexpr               
          | SAssign               of string * sexpr

and arr = SArrLit of sexpr list
and sstmt = 
	   SBlock                of sstmt list 
         | SExpr                 of sexpr 
         | SIf                   of sexpr * sstmt * sstmt
	 | SWhile                of sexpr * sstmt  
         | SFor                  of sexpr * sexpr * sexpr * sstmt 
         | SForEach              of sexpr * sexpr * sstmt
         | SReturn               of sexpr
         | SBreak                
         | SSetElementAssign     of string * sexpr * sexpr
         | SArrayElementAssign   of string * sexpr * sexpr

type sfdecl = { (* function declaration *)
                sftype : elmTypes;
                sfname : string;
                sparameters: bind list; 
                slocals: bind list;
                sbody : sstmt list;
            }

type sprogram = bind list * sfdecl list (* a valid program is some globals and function declarations *)

let string_of_unop = function
    Not -> "!"

let rec string_of_sexpr (t , e) =
      "(" ^ string_of_typ t ^ " : " ^ (match e with
      SIntLit(l)             -> string_of_int l
    | SCharLit(c)	    -> Char.escaped c
    | SStrLit(strlit)        -> strlit 
    | SBoolLit(true)         -> "true"
    | SBoolLit(false)        -> "false"
    | SAssign(s, e)          -> s ^ " = " ^ string_of_sexpr e ^ ";\n"
    | SVariable(s)           -> s 
    | SBinop(e1, o, e2)      -> string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
    | SUnop(o, e)            -> string_of_unop o ^ string_of_sexpr e
    | SCall(f, e1)           -> f ^ "(" ^ String.concat", "(List.map string_of_sexpr e1)^ ")"              
    | SNoexpr                -> "noexpr"
    | SSetAccess (s,e)       -> s ^ "{" ^ string_of_sexpr e ^ "}"
    | SArrayAccess (s,e)     -> s ^ "[" ^ string_of_sexpr e ^ "]"
		) ^ ")"

let rec string_of_sstmt = function
      SBlock(stmts)                -> "Block{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
    | SExpr(expr)                -> string_of_sexpr expr ^ ";\n"
    | SReturn(expr)              -> "return " ^ string_of_sexpr expr ^ ";\n"
    | SIf(e,s1,s2)               -> "if(" ^ string_of_sexpr e ^ ")\n" ^ string_of_sstmt s1 ^ "else\n" ^ string_of_sstmt s2 (*if else*)
    | SWhile(e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ string_of_sstmt s
    | SFor(e1,e2,e3,s)           -> "for(" ^ string_of_sexpr e1 ^ "; " ^ string_of_sexpr e2 ^ "; " ^ string_of_sexpr e3 ^ ")\n" ^ string_of_sstmt s
    | SForEach(e1,e2,s)          -> "foreach(" ^ string_of_sexpr e1 ^ " in " ^ string_of_sexpr e2 ^ ")\n" ^ string_of_sstmt s
    | SSetElementAssign(s,e1,e2)     -> s ^ "{" ^ string_of_sexpr e1 ^"} = " ^ string_of_sexpr e2 ^";\n"
    | SArrayElementAssign(a,e1,e2)   -> a ^"[" ^ string_of_sexpr e1 ^"] = " ^ string_of_sexpr e2 ^";\n"
    | SBreak                     -> "break;\n"

let string_of_typ = function
        Int         -> "int"
      | String      -> "string"
      | Char        -> "char"
      | Boolean     -> "bool"
      | Void        -> "void"

(* add pretty printing for the AST ie Add -> "+" *)
(*
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

let string_of_unop = function
    Not -> "!"
need to put in string_of_expr
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
    | ArrayAccess(a,e)        -> a ^ "[" ^ string_of_expr a^ "]"

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

(* let rec string_of_typ = function
      dataType(Int)           -> "int"
      | dataType(Char)        -> "char"
      | dataType(Boolean)        -> "boolean"
      | dataType(Void)        -> "void"
      | SetType(s)            -> string_of_typ (dataType(s))
      | ArrType(a)            -> string_of_typ (dataType(a))

let string_of_vinit (s, e) = s ^ " = " ^ string_of_expr e ^ ";\n"
*)
let string_of_fdecl fdecl =
    fdecl.ftype ^ " " ^ fdecl.fname ^ "(" ^ String.concat "," (List.map (fun x -> x) fdecl.parameters) ^
    ")\n{\n" ^
    String.concat "" (List.map string_of_stm fdecl.body) ^ "}\n"
*)
(*
let string_of_program (vars, funcs) = (vars, funcs)
   (* String.concat "" (List.map string_of_int vars) ^ "\n" ^ String.concat "\n" (List.map string_of_fdecl funcs) ^
    String.concat ";\n" (List.map string_of_fdecl funcs)*)*)
