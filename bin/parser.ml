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

open Lexer

exception Syntax_Error of string

(*
    Parser
    Find broken / unvalid code and report it

    Basically, it'll be looking for problems in loops
*)
let parse (code: instruction list) =    
    let char_count = ref 1 in
    let loop_count = ref 0 in

    let rec validate_loop (loop: instruction list) =
        match loop with
            | LEnd :: [] -> true
            | _ :: [] -> false
            | [] -> false
            | _ :: r -> validate_loop r            
    in
    let rec parser (parsed: instruction list) (in_loop: bool) =
        match parsed with
            | Loop(s) :: r -> begin
                Stdlib.incr loop_count;
                if (not (validate_loop s)) then
                    raise (Syntax_Error ("No matching ']' found for '[' at char " ^ (Stdlib.string_of_int !char_count) ^ " in loop " ^ (Stdlib.string_of_int !loop_count)))
                else
                    parser s true; (* parse what's inside the loop and then continue parsing *)
                    parser r false
            end
            | LEnd :: r -> begin
                match r with
                    | _ :: _ -> raise (Syntax_Error ("No matching '[' found for ']' at char " ^ (Stdlib.string_of_int !char_count)))
                    | [] -> begin
                        if (not in_loop) then
                            raise (Syntax_Error ("No matching '[' found for ']' at char " ^ (Stdlib.string_of_int !char_count)))
                        else
                            Stdlib.incr char_count
                    end
            end
            | _ :: r -> begin
                Stdlib.incr char_count;
                parser r in_loop
            end
            | [] -> ()
    in
    ignore (parser code false);
    code
