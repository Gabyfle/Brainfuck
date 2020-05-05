; Decrementing pointer of a certain amount of byte
; @author Gabriel Santamaria
; This file is a part of Brainfuck, a Brainfuck to x86 assembly compiler

cmp [pointer], byte {{amount}} ; check if the value contained at the address of pointer less than amount
jl _error_OOB                  ; if yes then jump to _error_OOB
sub [pointer], byte {{amount}}

sub edx, {{amount}}
