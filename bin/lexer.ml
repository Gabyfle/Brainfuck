(* 
    Brainfuck lexer
    lexer.ml


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
type instruction =
    | IPointer                    (* Incrementing pointer *)
    | DPointer                    (* Decrementing pointer *)
    | IByte                       (* Incrementing pointer the byte at the pointer *)
    | DByte                       (* Decrementing pointer the byte at the pointer *)
    | Out                         (* Printing the byte at the pointer *)
    | In                          (* Get one byte at the pointer *)
    | LStart                      (* Starting point of the loop *)
    | LEnd                        (* Ending point of the loop *)
    | Loop of instruction list    (* A loop *)
(* List of Brainfuck instructions, everything else is ignored *)
let intrc = [ '+'; '-'; '<'; '>'; '['; ']'; ','; '.' ]

(*
    function type_to_str
    transform a type list into a char instruction
    instructions list -> string
*)
let rec type_to_str (instr: instruction list) = 
    let str = ref "" in
    let tokenize (instr: instruction) =
        match instr with
            | IPointer -> str := !str ^ ">"
            | DPointer -> str := !str ^ "<"
            | IByte    -> str := !str ^ "+"
            | DByte    -> str := !str ^ "-"
            | Out      -> str := !str ^ "."
            | In       -> str := !str ^ ","
            | LStart   -> str := !str ^ "["
            | LEnd     -> str := !str ^ "]"
            | Loop(l)  -> str := !str ^ ("[" ^ (type_to_str l) ^ "]")
    in
    match instr with
        | [] -> !str
        | s :: r -> (tokenize s); type_to_str (r)

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
        | '[' -> LStart
        | ']' -> LEnd
        | k -> Printf.printf "%c" k; raise (Invalid_argument "invalid instruction")

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
    function lexer
    convert a brainfuck string into a list of instructions
    string -> instructions list
*)
let lexer (code: string) =
    let estring = Util.explode (clear_code code) in (* exploded string *)
    let rec real_length (length: int) = function
            | [] -> length
            | Loop(l) :: r -> real_length (length + (real_length 0 l)) r
            | _ :: r -> real_length (length + 1) r
    in
    let rec tokenizer (cl: char list) (program: instruction list) =
        match cl with
            | [] -> program
            | s :: r -> begin
                match s with
                    | c when c = '[' ->
                        let loop = (tokenizer r []) in
                        let ncl = Util.trimi r (real_length 0 loop) in
                        tokenizer ncl (Util.tappend program [Loop(Util.tappend [(char_to_type c)] loop)])
                    | c when c = ']' -> Util.tappend program [(char_to_type c)] (* if this is not present, it'll be reported at the analysis *)
                    | c -> tokenizer r (Util.tappend program [(char_to_type c)])
            end
    in
    tokenizer estring []
