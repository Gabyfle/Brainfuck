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
(* Enumeration of Brainfuck instructions, everything else is ignored *)
type instructions =
    | IPointer                    (* Incrementing pointer *)
    | DPointer                    (* Decrementing pointer *)
    | IByte                       (* Incrementing pointer the byte at the pointer *)
    | DByte                       (* Decrementing pointer the byte at the pointer *)
    | Out                         (* Printing the byte at the pointer *)
    | In                          (* Get one byte at the pointer *)
    | Loop of instructions list   (* A loop *)
(* List of Brainfuck instructions, everything else is ignored *)
let intrc = [ '+'; '-'; '<'; '>'; '['; ']'; ','; '.' ]

(*
    function type_to_str
    transform a type list into a char instruction
    instructions list -> string
*)
let rec type_to_str (instr: instructions list) = 
    let str = ref "" in
    let rec parse (instr: instructions) =
        match instr with
            | IPointer -> str := !str ^ ">"
            | DPointer -> str := !str ^ "<"
            | IByte    -> str := !str ^ "+"
            | DByte    -> str := !str ^ "-"
            | Out      -> str := !str ^ "."
            | In       -> str := !str ^ ","
            | Loop(l)  -> str := !str ^ ("[" ^ (type_to_str l) ^ "]")
    in
    match instr with
        | [] -> !str
        | s :: r -> (parse s); type_to_str (r)

(*
    function char_to_type
    transform a brainfuck char into a type
    char -> instructions
*)
let char_to_type (c: char) =
    match c with
        | '>' -> IPointer
        | '<' -> DPointer
        | '+' -> IByte
        | '-' -> DByte
        | '.' -> Out
        | ',' -> In
        | _ -> raise (Invalid_argument "invalid instruction")

(*
    function clear_code
    clear code from every comments
    string -> string
*)
let clear_code (code: string) =
    let str = ref "" in
    let is_instruction element =
        if List.mem element intrc then str := !str ^ (Char.escaped element)
    in
    String.iter is_instruction code;
    !str

(*
    function parse
    convert a brainfuck string into a list of instructions
    string -> instructions list
*)
let parse (code: string) =
    let estring = (Util.explode code) in (* exploded string *)
    let rec parser (cl: char list) (program: instructions list) =
        match cl with
            | [] -> program
            | s :: r -> begin
                match s with
                    | c when c = '[' -> 
                        let loop = (parser r []) in
                        let ncl = Util.trimi r (List.length loop) in
                        parser ncl (program @ loop)
                    | c when c = ']' -> program
                    | _ -> parser r program
            end
    in
    parser estring []
