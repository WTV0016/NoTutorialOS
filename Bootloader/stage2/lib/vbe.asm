; Parameters:   es:di - pointer to vesa info block
check_vbe_support:
    pusha

    mov ax, 0x4F00
    int 0x10

    cmp ax, 0x004F
    jne check_vbe_support_error

    cmp byte [es:di], 'V'
    jne check_vbe_support_error
    cmp byte [es:di+1], 'E'
    jne check_vbe_support_error
    cmp byte [es:di+2], 'S'
    jne check_vbe_support_error    
    cmp byte [es:di+3], 'A'
    jne check_vbe_support_error


    cmp word [es:di+4], 0x0300
    jne check_vbe_support_error

    popa

    mov bx, VBE_SUPPORT_SUCCESS
    call serial_print_string

    mov bx, word [es:di + 0x0E]   ; Load the segment part (BX) of the far pointer
    mov es, bx                    ; Set ES to the segment part

    mov bx, word [es:di + 0x10]   ; Load the offset part (BX) of the far pointer
    mov di, bx
    ret

check_vbe_support_error:
    mov bx, VBE_SUPPORT_ERROR
    call serial_print_string

    cli
    hlt
    jmp $

; Parameters:   es:di - pointer to vesa info block
; Return: none
check_vbe_modes:
    pusha
    dec di
    jmp check_vbe_modes_loop

check_vbe_modes_loop:
    inc di
    mov cx, word [es:di]

    cmp cx, 0xFFFF
    je check_vbe_modes_end

    push es
    push di

    ; Configure VESA graphics mode
    mov ax, 0x0            ; AX = 0x0000 (null segment)
    mov es, ax             ; Set ES = 0x0000, pointing to the data segment (e.g., .bss)

    ; Load the offset of vbe_info_block into DI
    lea di, [vbe_mode_info_block]

    mov ax, 0x4F01
    int 0x10

    mov al, 0b00011001
    test [es:di], al
    jz check_vbe_modes_loop

    cmp word [es:di + 18], 1024
    jne check_vbe_modes_loop
    cmp word [es:di + 20], 768
    jne check_vbe_modes_loop

    cmp byte [es:di + 25], 16
    jne check_vbe_modes_loop

    mov [LFB_START], qword [es:di + 40]

    pop di
    pop es

check_vbe_modes_end:
    popa
    ret