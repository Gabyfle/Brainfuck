; Print cell byte to the standard output stream
; @author Gabriel Santamaria
; This file is a part of Brainfuck, a Brainfuck to x86 assembly compiler

mov eax, SYS_WRITE ; sys_write()
mov ebx, 1         ; stdout
mov ecx, edx       ; print value from the address contained in EDX
mov edx, 1         ; print just one char

; reset EDX to the address of the current working cell
mov edx, esp
add edx, [pointer]
