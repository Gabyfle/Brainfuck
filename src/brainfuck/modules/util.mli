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

(*
    function sconcat
    concatenate every elements of a list. works only for strings elements
    list -> string
*)
let sconcat l =
    let str = ref "" in
    let rec concatenate l = 
        match l with
        | [] -> !str
        | s :: r -> str := String.concat "" [!str; s]; concatenate r
    in
    concatenate l
