(* 
    Instructions to x86 traductor
    x86.mli


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

type x86 =
    | Add of int        (* + (1) or - (-1) *)
    | Point of int      (* > (1) or < (-1) *)
    | Set of int        (* directly sets the value the the cell *)
    | Loop of x86 list  (* List of x86 instructions *)
    | Write             (* sys_write *)
    | Read              (* sys_read *)

val translate : x86 list -> instruction list -> x86 list
val merge : x86 list -> x86 list -> x86 list
val get_code : string -> x86 list -> string
val gen_asm : instruction list -> bool -> string
