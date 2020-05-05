        mov eax, SYS_WRITE ; sys_write()
        mov ebx, 1         ; stdout
        mov ecx, edx       ; print value from the address contained in EDX
        mov edx, 1         ; print just one char

        ; reset EDX to the address of the current working cell
        mov edx, esp
        add edx, [pointer]
