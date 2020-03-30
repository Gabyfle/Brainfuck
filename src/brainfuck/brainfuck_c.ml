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
open Parser

open Util
open Parser

let file_path = Sys.argv.(0) (* 1st argument in the command line have to be the filepath *)
let compiler_path = Sys.argv(1) (* 2nd argument in the command line have to be the compiler *)

(*
    function compile
    Convert Brainfuck code into C code and then compile it using the given compiler
    string -> float
*)
let compile(code: string) =
    let start = (Sys.time ()) in (* for performances recording purpose *)


let () =
    if (Sys.file_exists file_path) then
        code := sconcat (get_code file_path); (* parse the brainfuck code *)
    else
        raise Error "This file doesn't exists."

    if (!(Sys.file_exists )) then
        raise Error "Can't find the given compiler."