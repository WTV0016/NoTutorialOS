[org 0x7c00]

; Stack Setup
mov bp, STACK_POSITION
mov sp, bp

mov bx, STATUS_STAGE_1_ENTRY_MSG
call serial_print_string

mov bx, STATUS_STAGE_1_STACK_SETUP_MSG
call serial_print_string

mov [BOOT_DRIVE], dl

mov bx, STATUS_STAGE_1_BOOT_DRIVE_SAVED_MSG
call serial_print_string

mov bx, STAGE_2_OFFSET ; Set -up parameters for our disk_load routine , so
mov cl, 0x02 ; Start reading from second sector
mov dh, 5 ; that we load the first 5 sectors ( excluding
mov dl, [BOOT_DRIVE] ; the boot sector ) from the boot disk ( i.e. our
call disk_load ; stage 2 code ) to address STAGE_2_OFFSET

mov bx, STATUS_STAGE_1_STAGE_2_LOADED_MSG
call serial_print_string

mov bx, STATUS_STAGE_1_EXIT_MSG
call serial_print_string

call STAGE_2_OFFSET

cli
hlt

; DATA DECLERATIONS
BOOT_DRIVE equ 0x1000
STAGE_2_OFFSET equ 0x1100
STACK_POSITION equ 0x8000

; Status Messages
STATUS_STAGE_1_ENTRY_MSG: db '<Bootloader Stage 1>', 0
STATUS_STAGE_1_EXIT_MSG: db '</Bootloader Stage 1>', 0
STATUS_STAGE_1_BOOT_DRIVE_SAVED_MSG: db ' Boot Drive Saved ', 0
STATUS_STAGE_1_STACK_SETUP_MSG: db ' Stack Setup ', 0
STATUS_STAGE_1_STAGE_2_LOADED_MSG: db ' Stage 2 Loaded ', 0

; INCLUDES
%include "bootloader/stage1/lib/serial_io.asm"
%include "bootloader/stage1/lib/disk_io.asm"

; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55 