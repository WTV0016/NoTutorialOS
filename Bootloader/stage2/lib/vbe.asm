[bits 16]
; CODE
vbe_set_mode:
    ; Set the mode
	push es
	mov ax, 0x4F02
	mov bx, 0x0117
	or bx, 0x4000			; enable LFB
	mov di, 0			; not sure if some BIOSes need this... anyway it doesn't hurt
	int 0x10

    cmp ax, 0x004F
    jne set_vbe_mode_error

    xor ax, ax
    mov es, ax

    mov ax, 0x4F01
    mov cx, 0x0117
    mov di, vbe_mode_info_buffer
    int 0x10

    cmp ax, 0x004F
    jne set_vbe_mode_error


    ; Load the LFB address into SI (assuming you obtained it previously)
    mov si, word [es:di+40]    ; Lower 16 bits
    mov bx, word [es:di+42]  ; Upper 16 bits

    ; Store the first word (16 bits) of the LFB address at 0x400
    mov [LFB_START], si
    ; Store the second word (16 bits) of the LFB address at 0x402
    mov [LFB_START+2], bx

    mov bx, VBE_SET_MODE_MODE_SUCCESS
    call serial_print_string

    ret

set_vbe_mode_error:
    mov bx, VBE_SET_MODE_ERROR
    call serial_print_string
    cli
    hlt

; DATA DECLARATIONS
VBE_SET_MODE_ERROR: db 'VBE set mode error', 0
VBE_SET_MODE_MODE_SUCCESS: db 'VBE mode set', 0

vbe_mode_info_buffer resb 256