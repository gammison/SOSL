# SOSL: Set Operation Simplification Language

SOSL is a set theoretic language designed to make manipulating and creating sets easier.
The compiler is written in OCaml.

You can see our Language reference manual here:
Also check out the wiki:  

## Build instructions
To build the Scanner:
```Bash
ocamlex scanner.mll
```
To build the Parser use ocamlyacc or menhir:
```Bash
ocamlyacc parser.mly
```
To compile the AST types:
```
ocamlc -c ast.mli
```

Now compile the parser types, scanner, parser.
```
ocamlc -c parser.mli
ocamlc -c scanner.ml
ocamlc -c parser.ml
```

Now compile the compiler and final binary (missing complier step)
```
ocaml -o sosl parser.cmo scanner.cmo 
```
