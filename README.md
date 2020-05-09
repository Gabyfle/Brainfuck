# Brainfuck
A Brainfuck compiler, written in **OCaml**

## Table of contents
- [Brainfuck](#brainfuck)
  * [What is "Brainfuck" ?](#what-is-brainfuck-)
  * [What is this ?](#what-is-this-)
  * [How to use it ?](#how-to-use-it-)
  * [Performances](#performances)
    + [Using `benchmarking.py`](#using-benchmarkingpy)
    + [Hello World!](#hello-world)
    + [Mandelbrot set](#mandelbrot-set)
    + [Pi](#pi)
  * [Compiling your Brainfuck code](#compiling-your-brainfuck-code)
    + [Brainfuck parameters](#brainfuck-parameters)
    + [Command line](#command-line)
  * [Compiling your assembly code](#compiling-your-assembly-code)
    + [Requirements](#requirements)
    + [Command line](#command-line-1)
  * [Parser feature](#parser-feature)
  * [Optimization](#optimization)
    + [Optimize redundant instruction (done)](#optimize-redundant-instruction-done)
    + [Optimize loops (todo)](#optimize-loops-todo)
    + [Optimize dead code (todo)](#optimize-dead-code-todo)
  * [Credits](#credits)
  * [License](#license)

## What is "Brainfuck" ?
<p style="text-align: justify;">Brainfuck is an esoteric programming language developed by Urban Müller in 1993. The first particularity of this language is that it contains only 8 instructions that allow, in theory, to create any program (it is said to be Turing-complete). For more information, visit the Wikipedia page of the Brainfuck language: <a href="https://en.wikipedia.org/wiki/Brainfuck">Brainfuck - Wikipedia</a></p>

## What is this ?
<p style="text-align: justify;">This repository contains a compiler written entirely in OCaml. The ultimate goal would be to be able to integrate the compiler into other projects so that he can use Brainfuck as he sees fit.</p>

## How to use it ?

(this hasn't been implemented yet)

Brainfuck is meant to be used in command line.

## Performances

All these records have been made on the same machine.

* CPU: Intel® Core™ i5-3340M CPU @ 2.70GHz × 4 
* Memory: 11,6 GiB

### Using `benchmarking.py`

This script isn't supposed to be used outside of this repository but if you want to use it, you can still, by launching this command:

```
python3 benchmarking.py -program <relative_path> -amount <amount_of_time>
```

Where `<relative_path>` is the relative path to the program you want to take the bench from and `<amount_of_time>` is the amount of time the script should reproduce the benchmarks (the bigger it is, the more accurate your result will be).

### Hello World!
* Code: [Hello World!](https://en.wikipedia.org/wiki/Brainfuck#Hello_World!)
* Compile time: 0.001737 seconds
* **Execution:**
  * Time (seconds): 0.00086
  * Memory usage (Mb): 27.099136

### Mandelbrot set
* Code: [Mandelbrot](https://github.com/erikdubbelboer/brainfuck-jit/blob/master/mandelbrot.bf)
* Compile time: 0.003110 seconds
* **Execution:**
  * Time (seconds): 1.44159
  * Memory usage (Mb): 27.11552

### Pi
* Code: [Pi](http://esoteric.sange.fi/brainfuck/bf-source/prog/yapi.b)

  **Notice:** Instead of computing only *15* decimals, we're computing *140*.

* Compile time: 0.001349 seconds
* **Execution:**
  * Time (seconds): 0.007801
  * Memory usage (Mb): 26.656768

## Compiling your Brainfuck code

### Brainfuck parameters
* **Input:** the first parameter that you have to pass to Brainfuck is the path to the file that contains the Brainfuck code to be compiled.
* **Optional**:
  * **-o `<filename>`:** this parameter is optional. If not set, the default output name of Brainfuck will be `<input>.asm` where `<input>` is the filename you gived in the first parameter.
  * **-opt:** If set, activate optimizations

### Command line

To compile a brainfuck code, simply launch this command in your Terminal:

```
brainfuck <bf_to_compile>
```

Where `<bf_to_compile>` is the path to the Brainfuck code you want to compile.
To activate optimizations, add the `-opt` optional parameter:

```
brainfuck <bf_to_compile> -opt
```

Finally, if you want to set a specific name to your compiled code file's name, use the `-o` optional parameter:

```
brainfuck <bf_to_compile> -o <file_name> -opt
```

## Compiling your assembly code

### Requirements
* [Netwide Assembler](https://www.nasm.us/)
* A device running a x86-32 or x86-64 architecture
* A POSIX operating system

### Command line
To compile the assembly code that Brainfuck produces, type the following in your Terminal :

```
nasm -felf32 <your_file>.asm
ld -melf_i386 <your_file>.o -o <program_name>
```

Then, to execute it, simply run:

```
./<program_name>
```

## Parser feature
This compiler includes a very simple parser that will detect broken *Brainfuck* code. Here is some examples of how does it tell you that you made a mistake :

* **Example 1 :** you forgot to close a loop

*Input :*
```brainfuck
++++++++++[>+++++++
```
*Output :*
```
Parser.Syntax_Error("No matching ']' found for '[' at char 11 in loop 1")
```

* **Example 2 :** you added a `]` that does not match any loop

*Input :*
```brainfuck
++++++++++>+++++++]
```
*Output :*
```
Parser.Syntax_Error("No matching '[' found for ']' at char 19")
```

## Optimization

This compiler tries to optimise the Brainfuck code that he compile.

### Optimize redundant instruction (done)

Very often in Brainfuck, we see sets of instructions that looks like :
```brainfuck
+++++++++

or

---------
```
Instead of translating it naively into 9 `add reg, 1` (respectively `sub`) assembly instructions, we can translate it into a single instruction that directly adds 9 to the cell. This type of optimization works exactly the same for `<` and `>`.

### Optimize loops (todo)
### Optimize dead code (todo)

## Credits
* Table of contents: <small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## License
All code in this repository is under the Apache 2.0 license, available at the following address: https://www.apache.org/licenses/LICENSE-2.0

_**&copy; Gabriel Santamaria, 2019**_
