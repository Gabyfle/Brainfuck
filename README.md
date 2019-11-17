# Brainfuck
A Brainfuck interpreter and compiler, written in **OCaml**

## What is "Brainfuck" ?
<p style="text-align: justify;">Brainfuck is an esoteric programming language developed by Urban Müller in 1993. The first particularity of this language is that it contains only 8 instructions that allow, in theory, to create any program (it is said to be Turing-complete). For more information, visit the Wikipedia page of the Brainfuck language: <a href="https://en.wikipedia.org/wiki/Brainfuck">Brainfuck - Wikipedia</a></p>

## What is this ?
<p style="text-align: justify;">This repository contains an interpreter written entirely in OCaml as well as a compiler. The ultimate goal would be to be able to integrate the interpreter into other projects so that he can use Brainfuck as he sees fit.</p>

## Performances
- [hello.bf](https://gist.github.com/minikomi/3998533) : less than a second
- [mandelbrot.bf](https://github.com/frerich/brainfuck/blob/master/samples/mandelbrot.bf) : 527.4900 seconds
- [squares.bf](https://github.com/frerich/brainfuck/blob/master/samples/squares.b) : 0.108000 seconds
- [golden_ratio.bf](https://github.com/fabianishere/brainfuck/blob/master/examples/math/golden-ratio.bf) : 4.334000 seconds

## License
All code in this repository is under the Apache 2.0 license, available at the following address: https://www.apache.org/licenses/LICENSE-2.0

_**&copy; Gabriel Santamaria, 2019**_
