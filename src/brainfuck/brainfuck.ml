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
let code = ref "++++++++[>++++[>++>+++>+++>+<<<<-]>+>->+>>+[<]<-]>>.>>---.+++++++..+++.>.<<-.>.+++.------.--------.>+.>++."

(*
    function execute
    Execute the Brainfuck code from an already parsed string and returns the time it tooks
    instructions list -> int
*)
let execute (instructs: instructions list) =
    let start = (Sys.time ()) in (* for performances recording purpose *)
    let table = Array.make 4096 0 in
    let ptr = ref 0 in
    let rec eval instructs =
        match instructs with
            | [] -> ()
            | s :: r -> begin
                match s with
                    | IPointer -> incr ptr; eval r
                    | DPointer -> decr ptr; eval r
                    | IByte -> table.(!ptr) <- succ table.(!ptr); eval r
                    | DByte -> table.(!ptr) <- pred table.(!ptr); eval r
                    | Out -> Printf.printf "%c" (char_of_int table.(!ptr)); eval r
                    | In -> table.(!ptr) <- Scanf.scanf " %d" (fun x -> x); eval r
                    | Loop(l) -> 
                        while table.(!ptr) <> 0 do
                            eval l
                        done
            end
    in
    eval instructs;
    Sys.time () -. start

let () =
    if (Sys.file_exists file_path) then code := sconcat (get_code file_path);
    let program = parse !code in
    Printf.printf "Executed in : %f seconds" (execute program)
