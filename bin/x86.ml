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
    | Set of int        (* directly sets the value the the cell *)
    | Loop of x86 list  (* List of x86 instructions *)
    | Write             (* sys_write *)
    | Read              (* sys_read *)

(*
    function translate
    translates an instruction into a x86 type
    Lexer.instruction list -> x86 list
*)
let rec translate (bf: Lexer.instruction list) (instr: x86 list)  = 
    match bf with
        | [] -> instr
        | Lexer.IPointer :: r -> translate r ([Point(1)] @ instr)
        | Lexer.DPointer :: r -> translate r ([Point(-1)] @ instr)
        | Lexer.IByte    :: r -> translate r ([Add(1)] @ instr)
        | Lexer.DByte    :: r -> translate r ([Add(-1)] @ instr)
        | Lexer.Out      :: r -> translate r ([Write] @ instr)
        | Lexer.In       :: r -> translate r ([Read] @ instr)
        | Lexer.Loop(s)  :: r -> begin
            let loop = (translate s []) in
            translate r ([Loop(loop)] @ instr)
        end
        | _ :: r -> translate r instr

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
        | Loop(l)  :: r -> begin
            match l with
                | Add(v) :: [] when v < 0 -> merge r ([Set(0)] @ merged)
                | _ -> merge r ([Loop(merge l [])] @ merged)            
        end
        | s :: r -> merge r ([s] @ merged)

(*
    function get_code
    gets the code of the assembly program
    string -> x86 list -> string
*)
let rec get_code (code: string) = function
    (**
        We add (byte) v to the value at the address which is in EDX
    *)
    | Add(v) :: r when v > 0 -> get_code (code ^ Printf.sprintf "add byte [edx], %d\n" v) r
    | Add(v) :: r when v < 0 -> get_code (code ^ Printf.sprintf "sub byte [edx], %d\n" (-v)) r
    (**
        We add (byte) v to EDX: thus, we're changing the cell we're working on
    *)
    | Point(v) :: r when v > 0 -> get_code (code ^ Printf.sprintf "add edx, byte %d\n" v) r
    | Point(v) :: r when v < 0 -> get_code (code ^ Printf.sprintf "sub edx, byte %d\n" (-v)) r
    (**
        We move the value (byte) v at the address which is in EDX (the cell we're working on)
    *)
    | Set(v) :: r -> get_code (code ^ Printf.sprintf "mov [edx], %d\n" v) r
    | Loop(l) :: r -> begin
        let seed = ((Random.int 50000) * (Random.int 50000) + (Random.int 50000)) in
        let id = Stdlib.string_of_int (Hashtbl.seeded_hash seed "loop") in
        let loop_code = Printf.sprintf "%s:\tcmp [edx], byte 0\n\tjz %s\t%s jmp %s%s:\n" ("s" ^ id) ("e" ^ id) (get_code "" l) ("s" ^ id) ("e" ^ id) in
        get_code (code ^ loop_code) r
    end
    (**
        Using system call (sys_write here) we're printing the value at the address which is in EDX
    *)
    | Write :: r -> get_code (code ^ "mov eax, SYS_WRITE\nmov ebx, 1\nmov ecx, edx\nmov edx, 1\nint 0x80\nmov edx, ecx\n") r
    (**
        Using system call (sys_read here) we're reading a value from stdin and we put this value into the cell we're working on
    *)
    | Read :: r -> get_code (code ^ "mov eax, SYS_READ\nmov ebx, 0\nmov ecx, edx\nmov edx, 1\nint 0x80\nmov edx, ecx\n") r
    | _ :: r -> get_code code r
    | [] -> code


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
            | Move(v) :: r -> begin
                convert r (code ^ "")
            end
            | Loop(l) :: r -> begin
                let content = convert l "" in
                let partial = read_replace "assembly/loop.asm" "{{loop_body}}" content in
                let regex = Str.regexp "{{loop_number}}" in
                let final = Str.global_replace regex (Stdlib.string_of_int ((List.length r) + (String.length content) + (Random.int 200) * ((Random.int 30000) mod (Random.int 30000)))) partial in
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


let gen_asm =
    ()