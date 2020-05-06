        loop_{{loop_number}}:
            mov ecx, [edx]
            cmp ecx, 0
            jz end_loop_{{loop_number}}

                {{loop_body}}

            jmp loop_{{loop_number}}
        end_loop_{{loop_number}}:
