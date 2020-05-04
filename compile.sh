#!/usr/bin/env bash
# @author Gabriel Santamaria

#
# This whole script is just a little snippet for me to compile Brainfuck an easy way
#

# Checks whether or not OCaml is installed
function is_ocaml_installed ()
{
    if command -v ocamlopt > /dev/null 2>&1; then
        true
    else
        false
    fi
}

# Basically change the directory to "src"
# $1 is the location of the Brainfuck's git repository
function go_to_src ()
{
    cd "$1" . "/src" || echo "An error occurred while trying to look-up Brainfuck/src"
}

# Compile the given file
# $1 is the file name
function compile_module ()
{
    local file_names=$1
    for i in $file_names; do
        ocamlopt -c "$i" . ".mli"
        ocamlopt -c "$i" . ".ml"
    done
}

# Just compile 
function compile ()
{
    local dependencies=$1
    local modules=$2
    ocamlopt dependencies -o "brainfuck" modules
}

function main ()
{
    if [ ! "$(is_ocaml_installed)" ]; then # check if ocamlopt is available to compile Brainfuck
        echo "ocamlopt isn't installed. Can't compile Brainfuck. Sorry mate."
        exit 1
    fi

    go_to_src "$1"

    modules=(
        "util"
        "tokenizer"
        "parser"
        "x86"
    )

    dependencies=(
        "unix"
        "str"
    )

    echo "Compiling modules..."
    compile_module "${modules[*]}"
    echo "Compiling"
    compile "brainfuck_c" "${dependencies[*]}" "${modules[*]}"
    echo "Ended."
}

main
