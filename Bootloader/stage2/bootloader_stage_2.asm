[org 0x1100]
[bits 16]
section .text
    mov bx, STATUS_STAGE_2_ENTRY_MSG
    call serial_print_string


    ; Set VBE mode 1024x768, 16bit color depth and enable LFB
    call vbe_set_mode

    mov ax, 'j'
    call serial_print_char

    ; Load Kernel
    mov bx, KERNEL_OFFSET
    mov cl, 0x04
    mov dh, 20
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov bx, STATUS_STAGE_2_KERNEL_LOADED_MSG
    call serial_print_string

    ; switch to protected mode
    call switch_to_pm

    cli
    hlt

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

        pop es

        ret

    set_vbe_mode_error:
        mov bx, VBE_SET_MODE_ERROR
        call serial_print_string
        cli
        hlt

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

    ; load DH sectors to ES:BX from drive DL
    disk_load:

        
        push dx ; Store DX on stack so later we can recall
        ; how many sectors were request to be read ,
        ; even if it is altered in the meantime
        mov ah, 0x02 ; BIOS read sector function
        mov al, dh ; Read DH sectors
        mov ch, 0x00 ; Select cylinder 0
        mov dh, 0x00 ; Select head 0
        int 0x13 ; BIOS interrupt
        jc disk_error ; Jump if error ( i.e. carry flag set )
        pop dx ; Restore DX from the stack
        cmp dh, al ; if AL ( sectors read ) != DH ( sectors expected )
        jne disk_error ; display error message
        ret

    disk_error:
        cli
        hlt
        jmp $

    switch_to_pm:
        ; Enable A20 Line
        call enable_A20

        mov ax, 'a'
        call serial_print_char

        call load_gdt

        mov ax, 'g'
        call serial_print_char

        cli
        mov eax, cr0
        or eax, 1
        mov cr0, eax

        jmp 0x08:BEGIN_PM
        

    ; https://wiki.osdev.org/A20_Line
    enable_A20:
        cli

        call get_a20_state
        cmp ax, 0
        jne enable_A20_exit
    
        call    a20wait
        mov     al,0xAD
        out     0x64,al
    
        call    a20wait
        mov     al,0xD0
        out     0x64,al
    
        call    a20wait2
        in      al,0x60
        push    eax
    
        call    a20wait
        mov     al,0xD1
        out     0x64,al
    
        call    a20wait
        pop     eax
        or      al,2
        out     0x60,al

        call    a20wait
        mov     al,0xAE
        out     0x64,al
    
        call    a20wait
        
        jmp enable_A20_exit
    
    a20wait:
        in      al,0x64
        test    al,2
        jnz     a20wait
        ret
    
    
    a20wait2:
        in      al,0x64
        test    al,1
        jz      a20wait2
        ret

    enable_A20_exit:
        sti
        ret

    ;	out:
    ;		ax - state (0 - disabled, 1 - enabled)
    get_a20_state:
        pushf
        push si
        push di
        push ds
        push es
        cli
    
        mov ax, 0x0000					;	0x0000:0x0500(0x00000500) -> ds:si
        mov ds, ax
        mov si, 0x0500
    
        not ax						;	0xffff:0x0510(0x00100500) -> es:di
        mov es, ax
        mov di, 0x0510
    
        mov al, [ds:si]					;	save old values
        mov byte [BufferBelowMB], al
        mov al, [es:di]
        mov byte [BufferOverMB], al
    
        mov ah, 1
        mov byte [ds:si], 0
        mov byte [es:di], 1
        mov al, [ds:si]
        cmp al, [es:di]					;	check byte at address 0x0500 != byte at address 0x100500
        jne .exit
        dec ah
    .exit:
        mov al, [BufferBelowMB]
        mov [ds:si], al
        mov al, [BufferOverMB]
        mov [es:di], al
        shr ax, 8					;	move result from ah to al register and clear ah
        sti
        pop es
        pop ds
        pop di
        pop si
        popf

        ret
 
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
        push bx

        mov ax, ' '
        call serial_print_char

        jmp serial_print_string_loop

    serial_print_string_loop:
        cmp byte [bx], 0
        je serial_print_string_end
        mov ax, [bx]
        call serial_print_char
        inc bx
        jmp serial_print_string_loop

    serial_print_string_end:
        mov ax, ','
        call serial_print_char

        pop bx
        pop ax
        ret
    
    load_gdt:
        cli				; clear interrupts
        pusha				; save registers
        lgdt 	[toc]			; load GDT into GDTR
        sti				; enable interrupts
        popa				; restore registers
        ret				; All done!


; DATA DECLARATIONS


[bits 32]
    ;   serial_print_char
    ;
    ;   Description: prints the character in ax to the serial0 console
    ;   Parameters: ax - the character to print
    ;   Return: none
    ;
    serial_print_char_32:
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
    serial_print_string_32:
        push ax
        push bx

        mov ax, ' '
        call serial_print_char_32

        jmp serial_print_string_loop_32

    serial_print_string_loop_32:
        cmp byte [bx], 0
        je serial_print_string_end_32
        mov ax, [bx]
        call serial_print_char_32
        inc bx
        jmp serial_print_string_loop_32

    serial_print_string_end_32:
        mov ax, ','
        call serial_print_char_32

        pop bx
        pop ax
        ret

    BEGIN_PM:
        
        mov		ax, 0x10		; set data segments to data selector (0x10)
        mov		ds, ax
        mov		ss, ax
        mov		es, ax

        mov bx, STATUS_STAGE_2_PM_MSG
        call serial_print_string_32

        mov bx, STATUS_STAGE_2_SEGMENT_SET_MSG
        call serial_print_string_32
       
        mov bx, STATUS_STAGE_2_EXIT_MSG
        call serial_print_string_32

        jmp KERNEL_OFFSET
        
        cli
        hlt


; DATA DECLARATIONS
section .data
    BOOT_DRIVE equ 0x1000
    LFB_START equ 0x400
    KERNEL_OFFSET equ 0x2000

    STATUS_STAGE_2_ENTRY_MSG: db '<Bootloader Stage 2>', 0
    STATUS_STAGE_2_EXIT_MSG: db '</Bootloader Stage 2>', 0
    STATUS_STAGE_2_KERNEL_LOADED_MSG: db 'Kernel loaded', 0
    STATUS_STAGE_2_PM_MSG: db 'Successfully switched to PM', 0
    STATUS_STAGE_2_SEGMENT_SET_MSG: db 'Segment registers set', 0

    BufferBelowMB:	db 0
    BufferOverMB:	db 0
    VBE_SET_MODE_ERROR: db 'VBE set mode error', 0
    VBE_SET_MODE_MODE_SUCCESS: db 'VBE mode set', 0

;*******************************************
; Global Descriptor Table (GDT)
;*******************************************
 
    gdt_data: 
        dd 0 				; null descriptor
        dd 0 
    
    ; gdt_code:				; code descriptor
        dw 0FFFFh 			; limit low
        dw 0 				; base low
        db 0 				; base middle
        db 10011010b 			; access
        db 11001111b 			; granularity
        db 0 				; base high
    
    ; gdt_data:				; data descriptor
        dw 0FFFFh 			; limit low (Same as code)
        dw 0 				; base low
        db 0 				; base middle
        db 10010010b 			; access
        db 11001111b 			; granularity
        db 0				; base high
    
    end_of_gdt:
    toc: 
        dw end_of_gdt - gdt_data - 1 	; limit (Size of GDT)
        dd gdt_data 			; base of GDT

section .bss
    vbe_mode_info_buffer resb 256