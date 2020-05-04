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

open Pervasives
open Str

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

    ! THIS FUNCTION HASN'T BEEN TESTED YET !
*)
let x86_to_str (instr: x86 list) = 
    (* replace a certain pattern by a value using regex *)
    let read_replace (file: str) (pattern: str) (replace: str) =
        let file = Pervasives.open_in file in
        let code = Pervasives.really_input_string file (Pervasives.in_channel_length file) in
        let reg = Str.regexp pattern in
        Pervasives.close_in file;
        Str.global_replace pattern replace code
    in
    (* converts x86 assembly object type into real assembly code *)
    let rec convert (assembly: x86 list) (code: str) = function
        | Point(v) :: r -> begin
            if v == 0 then ""
            if v > 0 then
                convert code ^ (read_replace "assembly/next.asm" "({{amount}})" (string_of_int v))
            else
                convert code ^ (read_replace "assembly/prev.asm" "({{amount}})" (string_of_int v))
        end
        | Add(v) :: r -> begin
            if v == 0 then ""
            if v > 0 then
                convert r code ^ (read_replace "assembly/incr.asm" "({{amount}})" (string_of_int v))
            else
                convert r code ^ (read_replace "assembly/decr.asm" "({{amount}})" (string_of_int v))
        end
        | Loop(l) :: r -> begin
            let content = convert l in
            let partial = read_replace "assembly/loop.asm" "{{loop_body}}" content in
            let regex = Str.regexp "{{loop_number}}" in
            let final = Str.global_replace regex Unix.time partial in

            convert r code ^ final
        end
    in
    convert instr
