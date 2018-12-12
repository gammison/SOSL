(* Top-level of the SOSL compiler
   Does 4 things:
   1. Scan and parse input from stdin
   2. Check the computed AST and generate a SAST
   3. Generate LLVM IR,
   4. Dump the program
*)

type action = Ast | Sast | LLVM_IR | Compile (*ADD SAST back!; flags given on start *)

let () =
    let action = ref Compile in
    let set_action a () = action := a in
    let cmd_args = [
        ("-a", Arg.Unit (set_action Ast), "Print the AST");
        ("-s", Arg.Unit (set_action Sast), "Print the SAST");
        ("-l", Arg.Unit (set_action LLVM_IR), "Print the LLVM IR");
        ("-c", Arg.Unit (set_action Compile), 
                "Check and print the generated LLVM IR (default)");
    ] in
    let usage_msg = "usage: ./sosl.native [-a] [file.sl]" in
    let channel = ref stdin in
    Arg.parse cmd_args (fun filename -> channel := open_in filename) usage_msg;
    (* setting input channel to stdin, which is reading from a file *)
    let lexbuf = Lexing.from_channel !channel in
    let ast = Parser.program Scanner.token lexbuf in
    match !action with
         Ast -> print_string (Ast.string_of_program ast)
        | _ -> let sast = Semant.check ast in (*unwritten semantic checker *)
        match !action with
            Ast       -> ()
            | Sast    -> print_string (Sast.string_of_sprogram sast)
            | LLVM_IR -> print_string (Llvm.string_of_llmodule (Codegen.translate sast))
            | Compile -> let m = Codegen.translate sast in
              Llvm_analysis.assert_valid_module m;
              print_string (Llvm.string_of_llmodule m);
