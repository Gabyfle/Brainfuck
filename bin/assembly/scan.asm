        mov eax, SYS_READ ; sys_read()
        mov ebx, 0        ; stdin
        mov ecx, edx      ; put the result in the pointed cell
        mov edx, 1        ; get just one byte

        ; reset EDX to the address of the current working cell
        mov edx, esp
        add edx, [pointer]
