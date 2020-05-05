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

open Tokenizer
open Parser

open X86

(*
    function compile
    Convert Brainfuck code into assembly x86 code and then compile it using a given compiler
    string -> float
*)
let compile(code: string) =
    (* let file_path = Sys.argv.(0) in 1st argument in the command line have to be the filepath *)
    let file_name = Sys.argv.(1) in
    let start = (Sys.time ()) in (* for performances recording purpose *)
    (* Here's the different steps according to https://en.wikipedia.org/wiki/Compiler *)
    let tokenized = tokenize code in (* tokenize the code *)
    try
        let parsed = parse tokenized in (* now let's parse it *)
        let compiled = instr_to_x86 parsed [] in (* translates it to actual x86 instruction set *)
        let optimised = merge compiled [] in
        let compiled_str = x86_to_str optimised in
        let file = Stdlib.open_in "skeleton.asm" in
        let asm = Stdlib.really_input_string file (Stdlib.in_channel_length file) in
        Stdlib.close_in file;

        let reg = Str.regexp "{{code}}" in
        let final = Str.global_replace reg compiled_str asm in

        let f = Stdlib.open_out file_name in
        Printf.fprintf f "%s\n" final;
        Stdlib.close_out f;

        Printf.printf "Compiled in %f seconds" start
    with e ->
        let msg = Printexc.to_string e in
        Printf.printf "%s" msg (* Display possible error to the user *)

let () =
    compile "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."