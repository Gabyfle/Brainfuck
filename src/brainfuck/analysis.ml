(* 
    Brainfuck analysis
    analysis.ml


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
    Sementic analyser
    Find broken / unvalid code and report it

    Basically, it'll be looking for problems in loops
*)
let sementic (parsed: instructions list) =
    


(*
    Code optimizer
    Attempt to optimize brainfuck code before translating it into asmx86
*)
let optimize (parsed: instructions list) =
    (* TODO *)
