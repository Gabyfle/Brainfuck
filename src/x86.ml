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
        | IPointer :: r -> instr_to_x86 r ([Point(1)] @ instr)
        | DPointer :: r -> instr_to_x86 r ([Point(-1)] @ instr)
        | IByte    :: r -> instr_to_x86 r ([Add(1)] @ instr)
        | DByte    :: r -> instr_to_x86 r ([Add(-1)] @ instr)
        | Out      :: r -> instr_to_x86 r ([Write] @ instr)
        | In       :: r -> instr_to_x86 r ([Read] @ instr)
        | Loop(s)  :: r -> begin
            let loop = (instr_to_x86 s []) in
            instr_to_x86 r (x86.Loop(loop) @ instr)
        end
        | _ :: r -> instr_to_x86 r instr

(*
    function merge
    merges similar expressions that follow one another into a single
    x86 list -> x86 list
*)
let rec merge (instr: x86 list) (merged: x86 list) =
    match instr with
        | [] -> merged
        | Point(v) :: r -> begin
            match merged with
                | Point(w) :: t -> merge r (Point(v + w) @ merged)
                | _ -> merge r ([Point(v)] @ merged)
        end
        | Add(v)   :: r -> begin
            match merged with
                | Add(w) :: t -> merge r ([Add(v + w)] @ merged)
                | _ -> merge r ([Add(v)] @ merged)
        end
        | Loop(l)  :: r -> merge r ((merge l []) @ merged)

(*
    function x86_to_str
    translate x86 type elements to actual x86 code
    x86 -> str

let rec x86_to_str (instr: x86) =
    match instr with
        | Point(v) -> begin
            
        end
        | Add(v) -> begin

        end
    TODO: read from files in /assembly/
*)