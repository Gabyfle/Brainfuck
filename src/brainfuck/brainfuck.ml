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

let file_path = Sys.argv.(1) (* 1st argument in the command line have to be the filepath *)
let code = ref file_path

let execute (code: string) =
    let start = (times ()).tms_utime in (* for performances recording purpose *)
    let table = Array.make max_int 0 in
    let ptr = ref 0 in
    let rec eval pos =
        match instructs.(pos) with
            | IPointer -> ptr := incr ptr; eval (pos + 1)
            | DPointer -> ptr := decr ptr; eval (pos + 1)
            | IByte -> table.(!ptr) <- (incr ptr); eval (pos + 1)
            | DByte -> table.(!ptr) <- (decr ptr); eval (pos + 1)
            | Out -> Printf.printf "%c" (table.(!ptr)); eval (pos + 1)
            | In -> table.(!ptr) <- Scanf.scanf " %d" (fun x -> x); eval (pos + 1)
            | SLoop ->
                if table.(!ptr) = 0 then
                    eval (pos + 1)
                else begin
                    
                    while table.(!ptr) != 0 do
                        eval 
                    done
                end
            | ELoop ->
                if table.(!ptr) = 0 then
                    eval (pos + 1)
                else
                    () (* do nothing *)
    in
    eval 
                    

let () =
    if (Sys.file_exists file_path) then code := Util.sconcat (Util.get_code file_path);
