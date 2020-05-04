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

# This function will just try to launch a command
function try ()
{
    local value=$1
    local err
    err="$(eval $value)" 1>&1 || {
        echo "[Compile.sh] An error occurred."
        echo "[Compile.sh] Warning, I'll give you the error very soon..."
        sleep 1
        echo "[Compile.sh] Ok, actually I have to... check... if I have my helmet..."
        sleep 1
        echo "[Compile.sh] Alright everything is O.K, here's the error:"
        echo "[Compile.sh] ERROR: ${err}"

        false

        exit 1
    }
}

# Basically change the directory to "src"
# $1 is the location of the Brainfuck's git repository
function go_to_src ()
{
    try "cd ${1}\"src\"" || echo "An error occurred while trying to look-up Brainfuck/src"
}

# Compile the given file
# $1 is the file name
function compile_module ()
{
    local file_names=$1
    for i in $file_names; do
        try "ocamlopt -c \"${i}.mli\""
        try "ocamlopt -c \"${i}.ml\""
    done
}

# Just compile 
function compile ()
{
    local dependencies=$1
    local modules=$2
    try "ocamlopt ${dependencies} -o \"brainfuck\" ${modules}"
}

function main ()
{
    local default=""
    if [ "$#" -ne 1 ]; then
        ${1:-$default}
        echo "[Compile.sh] OKay darling, you're already in the right folder"
    fi

    is_ocaml_installed
    if [ ! "$?" ]; then # check if ocamlopt is available to compile Brainfuck
        echo "[Compile.sh] Hoooo! No! \"ocamlopt\" isn't installed. Can't compile Brainfuck."
        echo "[Compile.sh] - Sorry mate."
        echo "[Compile.sh] Try to install OCaml using: 'apt install ocaml'"
        exit 1
    fi

    go_to_src $1

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

    echo "[Compile.sh] Compiling modules..."
    compile_module "${modules[*]}"
    echo "[Compile.sh] Compiling"
    sleep 1
    compile "brainfuck_c" "${dependencies[*]}" "${modules[*]}"
    echo "[Compile.sh] Ended."
    sleep 1
    echo "[Compile.sh] I hope everything was alright whith me. Please, buy me a coffee, I'm so tired helping people to compile all the day long..."
}

main $1
