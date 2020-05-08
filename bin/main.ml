(* 
    Brainfuck compiler
    main.ml


    Copyright 2019 Gabriel Santamaria

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*)

open Lexer
open Parser

open X86

exception File_Exists of string

(*
    function write_to
    Writes a content to a file
    string -> string -> unit
*)
let write_to (file: string) (content: string) =
    if (Sys.file_exists file) then
        (raise (File_Exists (Printf.sprintf "File %s already exists!" file)));
    let code = Stdlib.open_out file in
    Printf.fprintf code "%s\n" content;
    Stdlib.close_out code

(*
    function read_from
    Read contents from a file
    string -> string
*)
let read_from (file: string) =
    if not (Sys.file_exists file) then
        (raise (File_Exists (Printf.sprintf "File %s does not exists!" file)));
    let code = Stdlib.open_in file in
    Stdlib.really_input_string code (Stdlib.in_channel_length code)

(*
    function compile
    Convert Brainfuck code into assembly x86 code
    string -> float
*)
let compile (code: string) (output: string) (opt: bool) =
    (* Here's the different steps according to https://en.wikipedia.org/wiki/Compiler *)

    let tokens = lexer code in (* 1st: get a rough representation of the code *)

    try
        let parsed = parse tokens in (* verify that everything is correct with our first representation *)
        (* 
            generate assembly code string from this first valid representation
            actually it first converts it to a ASM representation then
            it does optimization if they are active and generate the ASM code as a string
        *)
        let assembly = gen_asm parsed opt in
        write_to output assembly;

    with e ->
        let msg = Printexc.to_string e in
        Printf.printf "%s" msg (* Display possible error to the user *)

let () = (* Application entry point *)
    (*
        TODO: Arguments parser with Arg module from the standard library
    *)
    
    Printf.printf "Compiled in %f seconds\n" start
