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
    | IPointer  (* Incrementing pointer *)
    | DPointer  (* Decrementing pointer *)
    | IByte     (* Incrementing pointer the byte at the pointer *)
    | DByte     (* Decrementing pointer the byte at the pointer *)
    | Out       (* Printing the byte at the pointer *)
    | In        (* Get one byte at the pointer *)
    | SLoop     (* Starts looping *)
    | ELoop     (* Ends looping *)
(* List of Brainfuck instructions, everything else is ignored *)
let intrc = [ '+'; '-'; '<'; '>'; '['; ']'; ','; '.' ]

(*
    function type_to_char
    transform a type into a char instruction
    instructions -> char
*)
let type_to_char t = 
    match t with
    | IPointer -> '>'
    | DPointer -> '<'
    | IByte    -> '+'
    | DByte    -> '-'
    | Out      -> '.'
    | In       -> ','
    | SLoop    -> '['
    | ELoop    -> ']'

(*
    function char_to_type
    transform a brainfuck char into a type
    char -> instruction
*)
let char_to_type c =
    match c with
    | '>' -> IPointer
    | '<' -> DPointer
    | '+' -> IByte
    | '-' -> DByte
    | '.' -> Out
    | ',' -> In
    | '[' -> SLoop
    | ']' -> ELoop
    | _ -> raise (Invalid_argument "invalid instruction")

(*
    function clear_code
    clear code from every comments
    string -> string
*)
let clear_code code =
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
let parse code = 
    let program = ref [] in
    let parser chr =
        program := !program @ [(char_to_type chr)]
    in
    String.iter parser code;
    !program
