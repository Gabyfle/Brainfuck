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

let () =
    if (file_exists file_path) then code := Util.sconcat (Util.get_code file_path);

    let execute code =
        let start = (times ()).tms_utime in
        let array = Array.make max_int 0 in
        let ptr = ref 0 in
        let eval c =
            match c with
                | IPointer -> ptr := succ !ptr
                | DPointer -> ptr := pred !ptr
                | IByte -> array.(!ptr) <- (succ !ptr)
                | DByte -> array.(!ptr) <- (pred !ptr)
                | Out -> Printf.printf "%c" (array.(!ptr))
                | In -> array.(!ptr) <- Scanf.scanf " %d" (fun x -> x)
    (* TODO *)