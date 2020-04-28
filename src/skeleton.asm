global _start

; System calls macros
; write to ebx
%define SYS_WRITE 4
; read from ebx
%define SYS_READ  3
; exit program
%define SYS_EXIT  1

; define the syscall keyword
%define syscall int 0x80

section .data
    pointer dw 0 ; this will be used to point to adresses in stack 

section .text
    _start:
        ; make sure all the registers are at 0
        xor eax, eax 
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx

        ; {{here comes the brainfuck program}}

        mov eax, SYS_EXIT ; sys_exit
        syscall

    ; Indicates that program ended with error
    exit_error:
        mov eax, SYS_EXIT
        mov ebx, 1
        syscall

    ;'''''''''''''''';
    ;   PROCEDURES   ;
    ;________________;

    ; Prints the pointed character to STDOUT
    print:
        mov eax, SYS_WRITE ; sys_write
        mov ebx, 1 ; stdout
        call ptr_address
        lea ecx, [edx] ; print value from adress ESP + pointer
        mov edx, 1 ; just a character
        syscall

        ret

    ; Reads a character from STDIN and puts it in the pointed cell
    read: ; reads a character from stdin
        mov eax, SYS_READ ; sys_read
        mov ebx, 0 ; stdin
        call ptr_address
        lea ecx, [edx] ; put the result in at the adress ESP + pointer
        mov edx, 1 ; just one character
        syscall

        ret

    ; Points to the next memory cell
    next:
        add [pointer], dword 1 ; we add one to our memory address indicator

        ret

    ; Points to the previous memory cell
    prev:
        cmp [pointer], dword 0 ; check if the value contained at the address of pointer is equal to 0
        je exit_error ; if yes then jump to exit_error
        sub [pointer], dword 1 ; substract one to our memory adress indicator

        ret

    ; Increment the current cell's value
    incr:
        call ptr_address
        add [edx], dword 1 ; we add one to the value pointed by EBP + pointer

        ret

    ; Decrement the current cell's value
    decr:
        call ptr_address
        sub [edx], dword 1 ; we substract one the the value pointer by EBP + pointer

        ret

    ; Computes the pointer address into EDX
    ptr_address:
        mov edx, esp
        add edx, [pointer]

        ret
