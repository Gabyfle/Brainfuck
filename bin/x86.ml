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

open Parser

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
    x86 list -> Lexer.instruction list -> x86 list
*)
let rec translate (instr: x86 list) = function
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
    | Write :: r -> get_code (code ^ "mov eax, 4\nmov ebx, 1\nmov ecx, edx\nmov edx, 1\nint 0x80\nmov edx, ecx\n") r
    (**
        Using system call (sys_read here) we're reading a value from stdin and we put this value into the cell we're working on
    *)
    | Read :: r -> get_code (code ^ "mov eax, 3\nmov ebx, 0\nmov ecx, edx\nmov edx, 1\nint 0x80\nmov edx, ecx\n") r
    | _ :: r -> get_code code r
    | [] -> code


(*
    function gen_asm
    generate the assembly code given the Lexer representation
    Lexer.instruction -> string
*)
let gen_asm (instr: Lexer.instruction list) (opt: bool) =
    Random.self_init ();
    let intermediate = translate instr in
    if (opt) then intermediate = merge intermediate;
    let code = get_code "" intermediate in

    let cell_number = celln instr in
    let header = Printf.sprintf "global _start\nsection .data\n\tprogram times %s db 0\nsection .text\n\t_start:\n\t\tmov edx, program" cell_number in

    Printf.sprintf "%s\n%s\nmov eax, 1\nmov ebx, 0\nint 0x80\n" header code