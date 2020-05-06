        mov eax, SYS_READ ; sys_read()
        mov ebx, 0        ; stdin
        mov ecx, edx      ; put the result in the pointed cell
        mov edx, 1        ; get just one byte
        int 0x80          ; kernel interupt
        ; reset EDX to the address of the current working cell
        mov edx, ecx
