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

;
;   int_to_string
;
;   Description: converts the int in ax to an integer
;   Parameters: ax - the integer
;   Return: bx - pointer to the converted integer
;
reverse_string:
    pusha              ; Preserve registers

    mov si, bx         ; Initialize SI with the original pointer (end of reversed string)
    mov al, 0          ; Null-termination character (ASCII 0)
    stosb              ; Terminate the string with a null-termination character

    dec si             ; Move SI back to the last character of the reversed string
    mov di, bx         ; Initialize DI with the pointer to the beginning of the reversed string

reverse_loop:
    cmp di, si         ; Check if the two pointers have met or crossed each other
    jae done           ; If DI >= SI, the entire string has been reversed, so we are done

    mov al, [di]       ; Load the character from the start of the reversed string
    mov ah, [si]       ; Load the character from the end of the reversed string
    mov [di], ah       ; Swap the characters
    mov [si], al

    inc di             ; Move DI forward (towards the end of the string)
    dec si             ; Move SI backward (towards the start of the string)
    jmp reverse_loop   ; Repeat the process for the next characters

done:
    popa               ; Restore registers
    ret                ; Return with BX pointing to the beginning of the newly reversed string (0-terminated)