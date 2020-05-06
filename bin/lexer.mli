(* 
    Brainfuck lexer
    lexer.mli


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
    | Loop of instruction list   (* A loop *)
val intrc : char list
val type_to_str : instruction list -> string
val char_to_type : char -> instruction
val clear_code : string -> string
val tokenize : string -> instruction list
