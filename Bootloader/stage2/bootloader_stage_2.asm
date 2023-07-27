[org 0x1100]
[bits 16]

mov bx, STATUS_STAGE_2_ENTRY_MSG
call serial_print_string

; Set VBE mode 1024x768, 16bit color depth and enable LFB
call vbe_set_mode

; Load Kernel
mov bx, KERNEL_OFFSET ; Set -up parameters for our disk_load routine , so
mov cl, 0x06 ; Start reading from 6th sector
mov dh, 15 ; that we load sectors 6 to 15
mov dl, [BOOT_DRIVE] ; from the boot disk ( i.e. our
call disk_load ; stage 2 code ) to address KERNEL_OFFSET

; 

mov bx, STATUS_STAGE_2_EXIT_MSG
call serial_print_string

cli
hlt

; DATA DECLARATIONS
BOOT_DRIVE equ 0x1000
LFB_START equ 0x400
KERNEL_OFFSET equ 0x2000

STATUS_STAGE_2_ENTRY_MSG: db '<Bootloader Stage 2>', 0
STATUS_STAGE_2_EXIT_MSG: db '</Bootloader Stage 2>', 0

; INCLUDES
%include "bootloader/stage2/lib/serial_io.asm"
%include "bootloader/stage2/lib/disk_io.asm"
%include "bootloader/stage2/lib/types.asm"
%include "bootloader/stage2/lib/vbe.asm"