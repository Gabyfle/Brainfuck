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
let get_code file =
    let lines = ref [] in
    let io = open_in file in
    try
        while true; do
            lines := input_line io :: !lines
        done; !lines
    with End_of_file ->
        close_in io;
        List.rev !lines
