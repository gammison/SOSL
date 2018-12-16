open Ast

type sexpr = elmTypes * sx
and sx = 
          | SIntLit              of int
          | SCharLit             of char
          | SBoolLit             of bool 
          | SStrLit              of string 
          | SSetLit              of sexpr list
          | SVariable            of string
          (*| SSetAccess           of string * sexpr *)
	        (* | SArrLit		 of sexpr list*)
          (*| SArrayAccess         of string * sexpr *)
          | SCall                of string * sexpr list 
          | SBinop               of sexpr * op * sexpr 
          | SUnop                of unop * sexpr (* if we do string or array slicing, their syntactic sugar here *)
          | SNoexpr               
          | SAssign               of string * sexpr

(*and arr = SArrLit of sexpr list*)
and sstmt = 
	   SBlock                of sstmt list 
         | SExpr                 of sexpr 
         | SIf                   of sexpr * sstmt * sstmt
	 | SWhile                of sexpr * sstmt  
         | SFor                  of sexpr * sexpr * sexpr * sstmt 
         | SForEach              of sexpr * sexpr * sstmt
         | SReturn               of sexpr
         | SBreak                
         (*| SSetElementAssign     of string * sexpr * sexpr not done*)
         (*| SArrayElementAssign   of string * sexpr * sexpr we dont have arrays rn*)

type sfdecl = { (* function declaration *)
                sftype : elmTypes;
                sfname : string;
                sparameters: bind list; 
                slocals: bind list;
                sbody : sstmt list;
            }

type sprogram = bind list * sfdecl list (* a valid program is some globals and function declarations *)

let string_of_sunop = function
    Not -> "!"

let rec string_of_sexpr (t , e) =
      "(" ^ string_of_typ t ^ " : " ^ (match e with
      SIntLit(l)             -> string_of_int l
    | SCharLit(c)	     -> Char.escaped c
    | SStrLit(strlit)        -> strlit 
    | SBoolLit(true)         -> "true"
    | SBoolLit(false)        -> "false"
    | SSetLit(setlit)        -> ":{" ^ List.fold_left (^) "" (List.map string_of_sexpr setlit) ^ "}:"
    | SAssign(s, e)          -> s ^ " = " ^ string_of_sexpr e ^ ";\n"
    | SVariable(s)           -> s 
    | SBinop(e1, o, e2)      -> string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
    | SUnop(o, e)            -> string_of_sunop o ^ string_of_sexpr e
    | SCall(f, e1)           -> f ^ "(" ^ String.concat", "(List.map string_of_sexpr e1)^ ")"              
    | SNoexpr                -> "noexpr"
    (*| SSetAccess (s,e)       -> s ^ "{" ^ string_of_sexpr e ^ "}"
    | SArrayAccess (s,e)     -> s ^ "[" ^ string_of_sexpr e ^ "]"*)
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

let string_of_vinit (s, e) = s ^ " = " ^ string_of_sexpr e ^ ";\n"
 

let string_of_sfdecl fdecl =
  string_of_typ fdecl.sftype ^ " " ^
  fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sparameters) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_bind fdecl.slocals) ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "}\n"


let string_of_sprogram (vars, funcs) =
    String.concat "" (List.map string_of_bind vars) ^ "\n" ^ String.concat "\n" (List.map string_of_sfdecl funcs)
