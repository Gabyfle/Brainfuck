(* 
    Brainfuck compiler
    brainfuck_c.ml


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

open Util
open Tokenizer
open Parser

let file_path = Sys.argv.(0) (* 1st argument in the command line have to be the filepath *)

(*
    function compile
    Convert Brainfuck code into assembly x86 code and then compile it using a given compiler
    string -> float
*)
let compile(code: string) =
    let start = (Sys.time ()) in (* for performances recording purpose *)
    (* Here's the different steps according to https://en.wikipedia.org/wiki/Compiler *)
    let tokenized = tokenize code in (* tokenize the code *)
    try
        let parsed = parse tokenized in (* now let's parse it *)
        ()
    with e ->
        let msg = Printexc.to_string e in
        Printf.printf "%s" msg (* Display possible error to the user *)



let () =
    compile "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
