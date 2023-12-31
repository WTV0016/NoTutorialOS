; load DH sectors to ES:BX from drive DL
; cl - start sector
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