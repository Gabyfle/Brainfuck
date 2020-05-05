(* 
    Util functions
    util.mli


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

(* Util functions module *)
(*
    function get_code
    gets code from a file
    string -> string list
*)
let get_code (file: string) =
    let lines = ref [] in
    let io = open_in file in
    try
        while true; do
            lines := input_line io :: !lines
        done; !lines
    with End_of_file ->
        close_in io;
        List.rev !lines

(*
    function sconcat
    Concat a string list into a string
    string list -> string
*)
let sconcat (l: string list) =
    let str = ref "" in
    let rec concatenate l = 
        match l with
        | [] -> !str
        | s :: r -> str := String.concat "" [!str; s]; concatenate r
    in
    concatenate l

(*
    function trimi
    Trim the first n elements of a list
    'a list -> int -> 'a list
*)
let rec trimi list n = match list, n with
    | l, 0 -> l
    | [], n when n > 0 -> raise Not_found
    | s :: r, n -> trimi r (n - 1)

(*
    function findi_from
    Finds the first occurence of needle from start in list and return its position
    'a list -> int -> 'a -> int
*)
let findi_from (lst: 'a list) (start: int) (needle: 'a) =
    let nlst = (trimi lst start) in (* A new list derived from list but starting at list.(start) (so length(nlist) = length(list) - start) *)
    let index = ref 0 in
    let rec find l needle =
        match l with
            | [] -> raise Not_found
            | s :: r when s = needle -> !index
            | s :: r -> incr index; find r needle
    in
    find nlst needle

(*
    function explode
    Explode a string into a list of chars
    string -> char list
*)
let explode string =
    let rec xpld i list =
        if i < 0 then list
        else xpld (i - 1) (string.[i] :: list)
    in
    xpld ((String.length string) - 1) []
