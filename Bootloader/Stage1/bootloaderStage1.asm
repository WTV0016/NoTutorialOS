[org 0x7c00]

; DATA DECLERATIONS
BOOT_DRIVE equ 0x1000
STAGE_2_OFFSET equ 0x1100
STACK_POSITION equ 0x8000

HELLO_MSG: db 'Hello World!', 0
HELLO_MSG2: db 'Hello World!2', 0

; Stack Setup
mov bp, STACK_POSITION
mov sp, bp

mov bx, HELLO_MSG
call serial_print_string

mov bx, HELLO_MSG2
call vga_text_print_string

mov ax, 900
call int_to_string
call vga_text_print_string

cli
hlt

; INCLUDES
%include "Stage1/lib/serialIO.asm"
%include "Stage1/lib/vgaTextIO.asm"
%include "Stage1/lib/stdtypes.asm"

; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55 