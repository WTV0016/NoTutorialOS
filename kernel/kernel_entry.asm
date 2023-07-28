[bits 32]
[extern kernel_main]

push dx
push ax

mov ax, 'k'
mov dx, 0x3F8
out dx, ax

pop ax
pop dx

call kernel_main

cli
hlt