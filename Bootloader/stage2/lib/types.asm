;
;   int_to_string
;
;   Description: converts the int in ax to an integer
;   Parameters: ax - the integer
;   Return: bx - pointer to the converted integer
;
int_to_string:
    push bx
    jmp int_to_string_loop

int_to_string_loop:
    push bx

    mov dx, 0            ; Clear DX (since it's the upper half of the dividend)
    mov bx, 10    ; Load divisor into BX

    ; Perform division (AX:DX / BX)
    div bx               ; Quotient will be in AX, remainder (modulo) will be in DX

    pop bx

    cmp ax, 0
    je int_to_string_end

    add dx, '0'
    mov [bx], dx
    inc bx

    jmp int_to_string_loop

int_to_string_end:
    add dx, '0'
    mov [bx], dx

    pop bx
    ret