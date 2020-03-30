(* 
    Brainfuck interpreter
    brainfuck.ml


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

let file_path = Sys.argv.(0) (* 1st argument in the command line have to be the filepath *)
let code = ref ""

(*
    function execute
    Execute the Brainfuck code from an already parsed string and returns the time it tooks
    string -> float
*)
let execute (code: string) =
    let start = (Sys.time ()) in (* for performances recording purpose *)
    let table = Array.make 4096 0 in
    let ptr = ref 0 in
    let rec eval (pos: int) =
        if pos > (String.length code) - 1 then
            pos
        else
            match code.[pos] with
                | '>' -> incr ptr; eval (pos + 1)
                | '<' -> decr ptr; eval (pos + 1)
                | '+' -> table.(!ptr) <- succ table.(!ptr); eval (pos + 1)
                | '-' -> table.(!ptr) <- pred table.(!ptr); eval (pos + 1)
                | '.' -> Printf.printf "%c " (Char.chr table.(!ptr)); eval (pos + 1)
                | ',' -> table.(!ptr) <- Scanf.scanf " %d" (fun x -> x); eval (pos + 1)
                | '[' -> begin
                    let npos = ref pos in
                    while table.(!ptr) <> 0 do
                        npos := eval (pos + 1)
                    done;
                    eval (!npos + 1)
                end
                | ']' -> pos
                | _ -> pos
    in
    ignore (eval 0);
    Sys.time () -. start

let () =
    if (Sys.file_exists file_path) then
        code := sconcat (get_code file_path); (* Given argument is a filepath, then open-it *)
    else
        code := file_path; (* Given argument is brainfuck code, then execute-it *)
    Printf.printf "Executed in : %f seconds" (execute !code)
