;
;   serial_print_char
;
;   Description: prints the character in ax to the serial0 console
;   Parameters: ax - the character to print
;   Return: none
;
serial_print_char:
    push dx

    mov dx, 0x3F8
    out dx, ax

    pop dx

    ret
;
;   serial_print_string
;
;   Description: prints the 0 terminated string pointed to by bx to the serial0 console
;   Parameters: bx - pointer to the string
;   Return: none
;
serial_print_string:
    push ax
    jmp serial_print_string_loop

serial_print_string_loop:
    cmp byte [bx], 0
    je serial_print_string_end
    mov ax, [bx]
    call serial_print_char
    inc bx
    jmp serial_print_string_loop

serial_print_string_end:
    pop ax
    ret