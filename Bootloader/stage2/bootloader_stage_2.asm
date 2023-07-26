[org 0x1100]

mov bx, STATUS_STAGE_2_ENTRY_MSG
call serial_print_string

; Configure VESA graphics mode
mov ax, 0x0            ; AX = 0x0000 (null segment)
mov es, ax             ; Set ES = 0x0000, pointing to the data segment (e.g., .bss)

; Load the offset of vbe_info_block into DI
lea di, [vbe_info_block]

call check_vbe_support

mov bx, STATUS_STAGE_2_EXIT_MSG
call serial_print_string

cli
hlt

; DATA DECLARATIONS
BOOT_DRIVE equ 0x1000
LFB_START equ 0x400

STATUS_STAGE_2_ENTRY_MSG: db '<Bootloader Stage 2>', 0
STATUS_STAGE_2_EXIT_MSG: db '</Bootloader Stage 2>', 0

VBE_SIG: db 'VBE2'
VESA_SIG: db 'VESA'
VBE_VERSION: db 0x02
VBE_SUPPORT_ERROR: db 'VBE not supported', 0
VBE_SUPPORT_SUCCESS: db 'VBE supported', 0
vbe_info_block resb 512
vbe_mode_info_block resb 256

; INCLUDES
%include "bootloader/stage2/lib/serial_io.asm"
%include "bootloader/stage2/lib/disk_io.asm"
%include "bootloader/stage2/lib/types.asm"
%include "bootloader/stage2/lib/vbe.asm"