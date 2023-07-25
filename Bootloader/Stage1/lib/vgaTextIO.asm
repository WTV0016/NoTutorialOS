;
;   vga_text_print_char
;
;   Description: prints the character in ah to the screen
;   Parameters: ah - the character to print
;   Return: none
;
vga_text_print_char:
    push ax

    mov ah, 0x0E
    int 0x10

    pop ax
    ret

;
;   vga_text_print_string
;
;   Description: prints 0 terminated string pointed to by bx to the screen
;   Parameters: bx - pointer to the string
;   Return: none
;
vga_text_print_string:
    push ax
    jmp vga_text_print_string_loop

vga_text_print_string_loop:
    cmp byte [bx], 0
    je vga_text_print_string_end
    mov al, [bx]
    call vga_text_print_char
    inc bx
    jmp vga_text_print_string_loop

vga_text_print_string_end:
    pop ax
    ret