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
        (raise (File_Exists (Printf.sprintf "File %s does not exists!\n" file)));
    let code = Stdlib.open_in file in
    Stdlib.really_input_string code (Stdlib.in_channel_length code)

(*
    function compile
    Convert Brainfuck code into assembly x86 code
    string -> float
*)
let compile (code: string) (output: string) (opt: bool) =
    (* Here's the different steps according to https://en.wikipedia.org/wiki/Compiler *)
    try
        let tokens = lexer code in (* 1st: get a rough representation of the code *)
        let parsed = parse tokens in (* verify that everything is correct with our first representation *)
        (* 
            generate assembly code string from this first valid representation
            actually it first converts it to a ASM representation then
            it does optimization if they are active and generate the ASM code as a string
        *)
        let assembly = gen_asm parsed opt in
        write_to output assembly;

    with e -> begin
        let msg = Printexc.to_string e in
        Printf.eprintf "%s" msg (* Display possible error to the user *)
    end

(*
    function cli
    Parse arguments
    string ref -> bool ref -> string ref
*)
let cli (filename: string ref) (opt: bool ref) (output_name: string ref) =
    let options = [
        ("-opt", Arg.Unit (fun () -> opt := true), ": turns optimizations on");
        ("-o", Arg.Set_string output_name, ": changes the output file name");
    ] in
    Arg.parse options (fun name -> filename := name) "brainfuck <filename> [-opt] [-o <output>]";
    try
        if !filename = "" then
            (raise (Arg.Bad "You have to provide a file to compile!\n"));
        if !output_name = "" then
                output_name := Filename.basename !filename
    with e -> begin
        let msg = Printexc.to_string e in
        Printf.eprintf "An error occurred while trying to parse arguments: %s\n" msg
    end

let () = (* Application entry point *)
    let start = (Sys.time ()) in

    let opt = ref false in
    let file_path = ref "" in
    let output_name = ref "gabyfle_brainfuck.asm" in

    cli file_path opt output_name;
    compile (read_from !file_path) !output_name !opt;
    Printf.printf "Compiled in %f seconds\n" ((Sys.time ()) -. start)
