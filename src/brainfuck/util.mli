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
val get_code : string -> string list
val sconcat : string list -> string
val trimi : 'a list -> int -> 'a list
val findi_from : 'a list -> int -> 'a -> int
val explode : string -> char list
val is_list : 'a -> bool
val lst_length : 'a list -> int