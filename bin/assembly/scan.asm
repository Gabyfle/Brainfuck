; Get a single byte from the standard input stream
; @author Gabriel Santamaria
; This file is a part of Brainfuck, a Brainfuck to x86 assembly compiler

mov eax, SYS_READ ; sys_read()
mov ebx, 0        ; stdin
mov ecx, edx      ; put the result in the pointed cell
mov edx, 1        ; get just one byte

; reset EDX to the address of the current working cell
mov edx, esp
add edx, [pointer]
