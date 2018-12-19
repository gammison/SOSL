(* COPY from MicroC codegen.ml*)

(* Code generation: translate takes a semantically checked AST and
produces LLVM IR

LLVM tutorial: Make sure to read the OCaml version of the tutorial

http://llvm.org/docs/tutorial/index.html

Detailed documentation on the OCaml LLVM library:

http://llvm.moe/
http://llvm.moe/ocaml/

*)

module L = Llvm
module A = Ast
open Sast 

module StringMap = Map.Make(String)

(* translate : Sast.program -> Llvm.module *)
let translate (globals, functions) =
  let context    = L.global_context () in
  
  (* Create the LLVM compilation module into which
     we will generate code *)
  let the_module = L.create_module context "SOSL" in

  (* Get types from the context *)
  let i32_t          = L.i32_type    context
  and i1_t           = L.i1_type     context
  and i8_t           = L.i8_type     context
  and void_t         = L.void_type   context 
  and str_t          = L.pointer_type (L.i8_type context)
  and void_ptr_t     = L.pointer_type (L.i8_type context) in
  
  (*
  and set_t	         = L.named_struct_type context "set" 
  
  in
  let void_ptr_t  = L.pointer_type set_t
  (* and array_t    = L.array_type*)
 
  in
  *)

  let br_block    = ref (L.block_of_value (L.const_int i32_t 0)) in 

  (* Return the LLVM type for a MicroC type *)
  let ltype_of_typ = function
      A.Int      	   -> i32_t
    | A.Boolean  	   -> i1_t
    | A.Char     	   -> i8_t 
    | A.String	 	   -> str_t 
    | A.Void               -> void_t
    | A.Set(ltype_of_typ)  -> void_ptr_t
    | _ -> raise (Failure "not a supported data type")
  in

  (* Create a map of global variables after creating each *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m (t, n) = 
      let init = match t with
          _ -> L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in
  (*Create set.c functions*)

  
  (*Build printf function from C*)

  let printf_t : L.lltype = 
      L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue = 
      L.declare_function "printf" printf_t the_module in
  let print_set_t : L.lltype =
      L.var_arg_function_type i32_t [| void_ptr_t |] in
  let print_set_func : L.llvalue = 
      L.declare_function "print_set" print_set_t the_module in 
  let create_set : L.lltype =
      L.var_arg_function_type void_ptr_t [| i32_t |] in
  let create_set_func : L.llvalue = 
      L.declare_function "create" create_set the_module in
  let get_head : L.lltype =
      L.var_arg_function_type void_ptr_t [| void_ptr_t |] in
  let get_head_func : L.llvalue = 
      L.declare_function "get_head" get_head the_module in   
  let get_data_from_node : L.lltype =
      L.var_arg_function_type void_ptr_t [| void_ptr_t |] in
  let get_data_from_node_func : L.llvalue = 
      L.declare_function "get_data_from_node" get_data_from_node the_module in 
  let get_next_node : L.lltype =
      L.var_arg_function_type void_ptr_t [| void_ptr_t |] in
  let get_next_node_func : L.llvalue = 
      L.declare_function "get_next_node" get_next_node the_module in 

  let compare_int_bool_char : L.lltype =
      L.var_arg_function_type i32_t [| void_ptr_t ; void_ptr_t |] in
  let compare_int_bool_char_func : L.llvalue = 
      L.declare_function "compare_int_bool_char" compare_int_bool_char the_module in 
  let compare_string : L.lltype =
      L.var_arg_function_type i32_t [| void_ptr_t ; void_ptr_t |] in
  let compare_string_func : L.llvalue =
      L.declare_function "compare_string" compare_string the_module in 
  let compare_set : L.lltype =
      L.var_arg_function_type void_ptr_t [| void_ptr_t ; void_ptr_t |] in
  let compare_set_func : L.llvalue = 
      L.declare_function "comare_set" compare_set the_module in 

  let add_set : L.lltype =
      L.var_arg_function_type void_ptr_t [| void_ptr_t ; i32_t |] in
  let add_set_func : L.llvalue = 
      L.declare_function "adds" add_set the_module in 
  let destroy_set : L.lltype =
      L.var_arg_function_type void_t [| void_ptr_t |] in
  let destroy_set_func : L.llvalue = 
      L.declare_function "destroy" destroy_set the_module in 
  let rem_set : L.lltype =
      L.var_arg_function_type void_t [| void_ptr_t ; void_ptr_t |] in
  let rem_set_func : L.llvalue = 
      L.declare_function "remove" rem_set the_module in 
  let has_elmt : L.lltype =
      L.var_arg_function_type i32_t [| void_ptr_t ; void_ptr_t |] in
  let has_elmt_func : L.llvalue = 
      L.declare_function "has" has_elmt the_module in 
  let complement_set : L.lltype =
      L.var_arg_function_type  void_ptr_t [| void_ptr_t ; void_ptr_t |] in
  let complement_set_func : L.llvalue =
      L.declare_function "complement" complement_set the_module in
  let copy_set : L.lltype =
      L.var_arg_function_type void_ptr_t [|void_ptr_t |] in
  let copy_set_func : L.llvalue =
      L.declare_function "copy" copy_set the_module in
  let union_set : L.lltype =
      L.var_arg_function_type void_ptr_t [|void_ptr_t ; void_ptr_t |] in
  let union_set_func : L.llvalue =
      L.declare_function "union" union_set the_module in
  let intsect_set : L.lltype =
      L.var_arg_function_type void_ptr_t [| void_ptr_t ; void_ptr_t |] in
  let intsect_set_func : L.llvalue =
      L.declare_function "intersect" intsect_set the_module in
  let get_card : L.lltype =
      L.var_arg_function_type i32_t [| void_ptr_t |] in
  let get_card_func : L.llvalue =
      L.declare_function "get_card" intsect_set the_module in
  
  
   let function_decls : (L.llvalue * sfdecl) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and parameter_types = 
	Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sparameters)
      in let ftype = L.function_type (ltype_of_typ fdecl.sftype) parameter_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in
  
  (* Fill in the body of the given function *)
    let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in
    
    (*declare variables and formatting for each C printf type to be called below in SCall*)
    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder
    and float_format_str = L.build_global_stringptr "%g\n" "fmt" builder 
    and str_format_str = L.build_global_stringptr "%s\n" "fmt" builder
    and char_format_str = L.build_global_stringptr "%c\n" "fmt" builder in

    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p = 
        L.set_value_name n p;
	let local = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p local builder);
	StringMap.add n local m 

      (* Allocate space for any locally declared variables and add the
       * resulting registers to our map *)
      and add_local m (t, n) =
	let local_var = L.build_alloca (ltype_of_typ t) n builder
	in StringMap.add n local_var m 
      in

      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sparameters
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.slocals 
    in

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup n = try StringMap.find n local_vars
                   with Not_found -> StringMap.find n global_vars
    in

   (* Construct code for an expression; return its value *)
    let rec expr builder = function
        SIntLit i     -> L.const_int i32_t i
      | SBoolLit b    -> L.const_int i1_t (if b then 1 else 0)
      | SCharLit c    -> L.const_int i8_t (Char.code c)
      | SStrLit str   -> L.build_global_stringptr str "string" builder
      | SSetLit sl    ->
        (match sl with 
        | [] -> L.build_call create_set_func [| L.const_int i32_t 5 |] "tmp" builder
        | hd :: _ -> 
            let (_, e1) = hd in
            let e1' = expr builder e1 in
            let s = L.build_call create_set_func [| e1' |] "s" builder in 
            let addNodes ex = 
                let (ty, e2) = ex in
                    L.build_call add_set_func [| s; expr builder e2 |] "s" builder in
            List.map addNodes sl;
            s
            )
      | SNoexpr       -> L.const_int i32_t 0
      | SVariable s   -> L.build_load (lookup s) s builder
      | SAssign (s,ex) -> let (_ , e) = ex in 
			 let e' = expr builder e in
                         ignore(L.build_store e' (lookup s) builder); e'
      | SBinop ((_,e1), op, (_,e2)) ->
        let e1' = expr builder e1 and e2' = expr builder e2 in
        (match op with
          A.Add     -> L.build_add e1' e2' "tmp" builder
        | A.Sub     -> L.build_sub e1' e2' "tmp" builder
        | A.Mul     -> L.build_mul e1' e2' "tmp" builder
        | A.Div     -> L.build_sdiv e1' e2' "tmp" builder
        | A.And     -> L.build_and e1' e2' "tmp" builder
        | A.Or      -> L.build_or e1' e2' "tmp" builder
        | A.Eq      -> L.build_icmp L.Icmp.Eq e1' e2' "tmp" builder
        | A.Neq     -> L.build_icmp L.Icmp.Ne e1' e2' "tmp" builder
        | A.Less    -> L.build_icmp L.Icmp.Slt e1' e2' "tmp" builder
        | A.LessEq  -> L.build_icmp L.Icmp.Sle e1' e2' "tmp" builder
        | A.More    -> L.build_icmp L.Icmp.Sgt e1' e2' "tmp" builder
        | A.MoreEq  -> L.build_icmp L.Icmp.Sge e1' e2' "tmp" builder
        | A.Mod     -> L.build_frem e1' e2' "tmp" builder
        | A.Elof    -> L.build_call has_elmt_func [| e1'; e2' |] "has" builder
        | A.Comp    -> L.build_call complement_set_func [| e1' ; e2' |] "complement" builder
        | A.Isec    -> L.build_call intsect_set_func [| e1' ; e2' |] "intersect" builder
        | A.Union   -> L.build_call union_set_func [| e1' ; e2' |] "set_union" builder)
      | SUnop(op, (_, e)) ->
          let e' = expr builder e in
	        (match op with
           A.Not          -> L.build_not) e' "tmp" builder
      
      (*Map various print functions back to C's printf function*)
      | SCall ("print", [(_, e)]) | SCall ("printb", [(_, e)]) ->
	    L.build_call printf_func [| int_format_str ; (expr builder e) |] "print" builder
      | SCall ("prints", [(_, e)]) ->
	    L.build_call printf_func [| str_format_str ; (expr builder e) |] "prints" builder
      | SCall ("printc", [(_, e)]) ->
	    L.build_call printf_func [| char_format_str;  (expr builder e) |] "print_char" builder
      | SCall ("printf", [(_, e)]) -> 
        L.build_call printf_func [| float_format_str ; (expr builder e) |] "printf" builder
      | SCall ("print_set_int", [(_,e)]) ->
        L.build_call print_set_func [| expr builder e |] "print_set" builder
      | SCall ("print_set_bool", [(_,e)]) ->
        L.build_call print_set_func [| expr builder e |] "print_set" builder
      | SCall ("print_set_char", [(_,e)]) ->
        L.build_call print_set_func [| expr builder e |] "print_set" builder
      | SCall ("print_set_string", [(_,e)]) ->
        L.build_call print_set_func [| expr builder e |] "print_set" builder
      (*| SCall ("print_set_set", [(_,e)]) ->
        L.build_call print_set_func [| expr builder e |] "print_set" builder*)

      | SCall ("adds_int", [(_,e1); (_,e2)]) ->
	L.build_call add_set_func [| (expr builder e1) ; (expr builder e2) |] "add" builder
      | SCall ("adds_int", [(_,e1); (_,e2)]) ->
	L.build_call add_set_func [| (expr builder e1) ; (expr builder e2) |] "add" builder
      | SCall ("adds_int", [(_,e1); (_,e2)]) ->
	L.build_call add_set_func [| (expr builder e1) ; (expr builder e2) |] "add" builder
      | SCall ("adds_int", [(_,e1); (_,e2)]) ->
	L.build_call add_set_func [| (expr builder e1) ; (expr builder e2) |] "add" builder
      | SCall ("adds_int", [(_,e1); (_,e2)]) ->
	L.build_call add_set_func [| (expr builder e1) ; (expr builder e2) |] "add" builder
      | SCall ("rems_int", [(_,e1); (_,e2)]) ->
	L.build_call add_set_func [| (expr builder e1) ; (expr builder e2) |] "add" builder
      | SCall ("rems_int", [(_,e1); (_,e2)]) ->
	L.build_call rem_set_func [| (expr builder e1) ; (expr builder e2) |] "remove_elm" builder
      | SCall ("rems_int", [(_,e1); (_,e2)]) ->
	L.build_call rem_set_func [| (expr builder e1) ; (expr builder e2) |] "remove_elm" builder
      | SCall ("rems_int", [(_,e1); (_,e2)]) ->
	L.build_call rem_set_func [| (expr builder e1) ; (expr builder e2) |] "remove_elm" builder
      | SCall ("rems_int", [(_,e1); (_,e2)]) ->
	L.build_call rem_set_func [| (expr builder e1) ; (expr builder e2) |] "remove_elm" builder
      (*| SCall ("rems_set", [(_,e1); (_,e2)]) ->
	L.build_call rem_set_func [| (expr builder e1) ; (expr builder e2) |] "remove_elm" builder*)


      | SCall (f, args) ->
            let (fdef, fdecl) = StringMap.find f function_decls in
	        let llargs = List.rev (List.map (expr builder) (List.rev_map snd args)) in
            let result = 
                (match fdecl.sftype with 
                    _ -> f ^ "_result") in
            L.build_call fdef (Array.of_list llargs) result builder
    in
    
    (* LLVM insists each basic block end with exactly one "terminator" 
       instruction that transfers control.  This function runs "instr builder"
       if the current block does not already have a terminator.  Used,
       e.g., to handle the "fall off the end of the function" case. *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
	Some _ -> ()
      | None -> ignore (instr builder) in
	
    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)
    
    let rec stmt builder = function
	      SBlock sl       -> List.fold_left stmt builder sl
      | SExpr (_, e)    -> ignore(expr builder e); builder 
      | SReturn (_, e)       -> ignore(match fdecl.sftype with
                   Void         -> L.build_ret_void builder (* Special "return nothing" instr *)
                  | _           -> L.build_ret (expr builder e) builder ); builder

      | SIf ((_, predicate), then_stmt, else_stmt) ->
        let bool_val = expr builder predicate in
	        let merge_bb = L.append_block context "merge" the_function in
            let build_br_merge = L.build_br merge_bb in (* partial function *)

	            let then_bb = L.append_block context "then" the_function in
	              add_terminal (stmt (L.builder_at_end context then_bb) then_stmt)
	                build_br_merge;

              let else_bb = L.append_block context "else" the_function in
                add_terminal (stmt (L.builder_at_end context else_bb) else_stmt)
                  build_br_merge;

              ignore(L.build_cond_br bool_val then_bb else_bb builder);
              L.builder_at_end context merge_bb

      | SBreak -> ignore (L.build_br !br_block builder);  builder

      | SWhile ((_, predicate), body) ->
        let pred_bb = L.append_block context "while" the_function in
          ignore(L.build_br pred_bb builder);
        let body_bb = L.append_block context "while_body" the_function in
          add_terminal (stmt (L.builder_at_end context body_bb) body)
          (L.build_br pred_bb);

        let pred_builder = L.builder_at_end context pred_bb in
        let bool_val = expr pred_builder predicate in

        let merge_bb = L.append_block context "merge" the_function in
          ignore(L.build_cond_br bool_val body_bb merge_bb pred_builder);
          L.builder_at_end context merge_bb

        (*
        | SForEach (e1, e2, s) -> 
            let set_ptr = expr builder e2 in 
            let counter = L.build_alloca i32_t "counter" builder in
            ignore(L.build_store (L.const_int i32_t 0) counter builder);
            
            let size = L.build_call get_card_func [| set_ptr |] "size" builder in
            let node_var = L.build_alloca void_ptr_t n builder in
            let vars = StringMap.add n set_var vars in

            let current_node_ptr = L.build_alloca void_ptr_t "current" builder in
            let head_node = L.build_call get_head_func [| set_ptr |] "head" builder in
            ignore(L.build_store head_node current_node_ptr builder);

            let body_bb = L.append_block context "while_body" the_function in
            let body_builder = L.builder_at_end context body_bb in

            let current_node = L.build_load current_node_ptr "current_tmp" body_builder in
            
            let data_ptr = L.build_call get_data_from_vertex_func [| current_node |] (n ^ "_tmp") body_builder in
            ignore(L.build_store data_ptr node_var body_builder);
            
            let next_node = L.build_call get_next_vertex_func [| current_node |] "next" body_builder in
            ignore(L.build_store next_node current_node_ptr body_builder);
            
            let counter_val = L.build_load counter "counter_tmp" body_builder in
            let counter_incr = L.build_add (L.const_int i32_t 1) counter_val "counter_incr" body_builder in
            ignore(L.build_store counter_incr counter body_builder);
            
            add_terminal (stmt vars body_builder body) (L.build_br pred_bb);

            let pred_builder = L.builder_at_end context pred_bb in
            let counter_val = L.build_load counter "counter_tmp" pred_builder in
            let done_bool_val = L.build_icmp L.Icmp.Slt counter_val size "done" pred_builder in

            let merge_bb = L.append_block context "merge" the_function in
            ignore (L.build_cond_br done_bool_val body_bb merge_bb pred_builder);
            L.builder_at_end context merge_bb *)

      (* Implement for loops as while loops *)
      | SFor (e1, e2, e3, body) -> stmt builder
	      ( SBlock [SExpr e1 ; SWhile (e2, SBlock [body ; SExpr e3]) ] ) in
      
      (* Build the code for each statement in the function *)
        let builder = stmt builder (SBlock fdecl.sbody) in

        (* Add a return if the last block falls off the end *)
        add_terminal builder (match fdecl.sftype with
          (* A.Void -> L.build_ret_void*)
          | t -> L.build_ret (L.const_int (ltype_of_typ t) 0))
 in

 List.iter build_function_body functions;
 the_module
