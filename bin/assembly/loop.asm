        loop_{{loop_number}}:
            mov ecx, [edx]
            cmp ecx, 0
            je end_loop_{{loop_number}}

                {{loop_body}}

            jmp loop_{{loop_number}}
        end_loop_{{loop_number}}:
