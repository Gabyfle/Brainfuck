; Loop until the current memory case is equal to 0
; @author Gabriel Santamaria
; This file is a part of Brainfuck, a Brainfuck to x86 assembly compiler

loop_{{loop_number}}:
    mov ecx, [edx]

    {{loop_body}}

    jnz loop_{{loop_number}}
