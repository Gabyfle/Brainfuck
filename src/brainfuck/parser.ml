(* 
    Brainfuck parser
    parser.ml


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

(* Parser module *)
(* List of Brainfuck instructions, everything else is ignored *)
let instructions = [ '+'; '-'; '<'; '>'; '['; ']'; ','; '.' ]

(*
    function clear_code
    clear code from every comments
    string -> string
*)
let clear_code code =
    let str = ref "" in
    let is_instruction element =
        if List.mem element instructions then str := !str ^ (Char.escaped element)
    in
    String.iter is_instruction code;
    !str
