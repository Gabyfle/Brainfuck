        mov eax, SYS_WRITE ; sys_write()
        mov ebx, 1         ; stdout
        mov ecx, edx       ; print value from the address contained in EDX
        mov edx, 1         ; print just one char
        int 0x80           ; kernel interupt
        ; reset EDX to the address of the current working cell
        mov edx, ecx

