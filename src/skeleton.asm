global _start

; System calls macros
; write to ebx
%define SYS_WRITE 4
; read from ebx
%define SYS_READ  3
; exit program
%define SYS_EXIT  1

section .data
    ptr dd 0 ; this will be used to point to adresses in stack 

section .text
    _start:
        ; make sure all the registers are at 0
        xor eax, eax 
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx

        ; here comes the brainfuck program

        mov eax, SYS_EXIT ; sys_exit
        syscall

    ; Prints the pointed character to STDOUT
    print:
        mov eax, SYS_WRITE ; sys_write
        mov ebx, 1 ; stdout
        mov edx, 1 ; just a character
        lea ecx, [esp + ptr] ; print value from adress ESP + PTR
        syscall

        ret
    
    ; Reads a character from STDIN and puts it in the pointed cell
    read: ; reads a character from stdin
        mov eax, SYS_READ ; sys_read
        mov ebx, 0 ; stdin
        mov edx, 1 ; just one character
        lea ecx, [esp + ptr] ; put the result in at the adress ESP + PTR
        syscall

        ret

    ; Points to the next memory cell
    next:
        add [ptr], 1 ; we add one to our memory address indicator

        ret
    
    ; Points to the previous memory cell
    prev:
        cmp [ptr], 0 ; check if the value contained at the address of ptr is equal to 0
        je exit_error ; if yes then jump to exit_error
        sub [ptr], 1 ; substract one to our memory adress indicator

        ret

    ; Increment the current cell's value
    incr:
        add [esp + ptr], 1 ; we add one to the value pointed by EBP + ptr

        ret

    ; Decrement the current cell's value
    decr:
        sub [esp + ptr], 1 ; we substract one the the value pointer by EBP + ptr

        ret

    ; Indicates that program ended with error
    exit_error:
        mov eax, SYS_EXIT
        mov ebx, 1
        syscall
