(* 
    Instructions to x86 traductor
    x86.ml


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

(*
    function instr_to_x86
    translates an instruction into a x86 type
    instruction list -> x86 list
*)
let rec instr_to_x86 (bf: instruction list) (instr: x86 list)  = 
    match bf with
        | []            -> instr
        | IPointer :: r -> instr_to_x86 r (instr @ Point(1))
        | DPointer :: r -> instr_to_x86 r (instr @ Point(-1))
        | IByte    :: r -> instr_to_x86 r (instr @ Add(1))
        | DByte    :: r -> instr_to_x86 r (instr @ Add(-1))
        | Out      :: r -> instr_to_x86 r (instr @ Add(1))
        | In       :: r -> instr_to_x86 r (instr @ Read)
        | Loop(s)  :: r -> begin
            let loop = (instr_to_x86 s []) in
            instr_to_x86 r (instr @ x86.Loop(loop))
        end
        | _ :: r -> instr_to_x86 r instr

(*
    function merge
    merges similar expressions that follow one another into a single
    x86 list -> x86 list
*)
let rec merge (instr: x86 list) =
    () (* TODO *)