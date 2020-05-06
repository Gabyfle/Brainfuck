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

type x86 =
    | Add of int        (* + (1) or - (-1) *)
    | Point of int      (* > (1) or < (-1) *)
    | Loop of x86 list  (* List of x86 instructions *)
    | Write             (* sys_write *)
    | Read              (* sys_read *)

(*
    function instr_to_x86
    translates an instruction into a x86 type
    Lexer.instruction list -> x86 list
*)
let rec instr_to_x86 (bf: Lexer.instruction list) (instr: x86 list)  = 
    match bf with
        | [] -> instr
        | Lexer.IPointer :: r -> instr_to_x86 r ([Point(1)] @ instr)
        | Lexer.DPointer :: r -> instr_to_x86 r ([Point(-1)] @ instr)
        | Lexer.IByte    :: r -> instr_to_x86 r ([Add(1)] @ instr)
        | Lexer.DByte    :: r -> instr_to_x86 r ([Add(-1)] @ instr)
        | Lexer.Out      :: r -> instr_to_x86 r ([Write] @ instr)
        | Lexer.In       :: r -> instr_to_x86 r ([Read] @ instr)
        | Lexer.Loop(s)  :: r -> begin
            let loop = (instr_to_x86 s []) in
            instr_to_x86 r ([Loop(loop)] @ instr)
        end
        | _ :: r -> instr_to_x86 r instr

(*
    function merge
    merges similar expressions that follow one another into a single
    x86 list -> x86 list -> x86 list
*)
let rec merge (instr: x86 list) (merged: x86 list) =
    match instr with
        | [] -> merged
        | Point(v) :: r -> begin
            match merged with
                | Point(w) :: t -> merge r ([Point(v + w)] @ t)
                | t -> merge r ([Point(v)] @ t)
        end
        | Add(v)   :: r -> begin
            match merged with
                | Add(w) :: t -> merge r ([Add(v + w)] @ t)
                | t -> merge r ([Add(v)] @ t)
        end
        | Loop(l)  :: r -> merge r ([Loop(merge l [])] @ merged)
        | s :: r -> merge r ([s] @ merged)

(*
    function x86_to_str
    translate x86 type elements to actual x86 code
    x86 -> str
*)
let x86_to_str (instr: x86 list) =
    Random.self_init ();
    (* replace a certain pattern by a value using regex *)
    let read_replace (file: string) (pattern: string) (replace: string) =
        let asm = Stdlib.open_in file in
        let code = Stdlib.really_input_string asm (Stdlib.in_channel_length asm) in
        let reg = Str.regexp pattern in
        Stdlib.close_in asm;
        Str.global_replace reg replace code
    in
    (* converts x86 assembly object type into real assembly code *)
    let rec convert (assembly: x86 list) (code: string) = 
        match assembly with
            | Point(v) :: r -> begin
                if v == 0 then convert r code
                else if v > 0 then
                    convert r (code ^ (read_replace "assembly/next.asm" "{{amount}}" (Stdlib.string_of_int v)))
                else
                    convert r (code ^ (read_replace "assembly/prev.asm" "{{amount}}" (Stdlib.string_of_int (-v))))
            end
            | Add(v) :: r -> begin
                if v == 0 then convert r code
                else if v > 0 then
                    convert r (code ^ (read_replace "assembly/incr.asm" "{{amount}}" (Stdlib.string_of_int v)))
                else
                    convert r (code ^ (read_replace "assembly/decr.asm" "{{amount}}" (Stdlib.string_of_int (-v))))
            end
            | Loop(l) :: r -> begin
                let content = convert l "" in
                let partial = read_replace "assembly/loop.asm" "{{loop_body}}" content in
                let regex = Str.regexp "{{loop_number}}" in
                let final = Str.global_replace regex (Stdlib.string_of_int ((List.length r) + (String.length content) + 2 * (Random.int 30000) * (Random.int 30000))) partial in
                convert r (code ^ final)
            end
            | Write :: r -> begin
                let asm = Stdlib.open_in "assembly/print.asm" in
                let full = (Stdlib.really_input_string asm (Stdlib.in_channel_length asm)) in
                Stdlib.close_in asm;
                convert r (code ^ "\n" ^ full)
            end
            | Read :: r -> begin
                let asm = Stdlib.open_in "assembly/scan.asm" in
                let full = (Stdlib.really_input_string asm (Stdlib.in_channel_length asm)) in
                Stdlib.close_in asm;
                convert r (code ^ "\n" ^ full)
            end
            | [] -> code
    in
    convert instr ""
