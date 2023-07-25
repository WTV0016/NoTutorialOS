CC:=D:/i686-elf-tools-windows/bin/i686-elf-gcc.exe
CFLAGS:=-ffreestanding
CFLAGS_DEBUG:=-ffreestanding -g

AS:=D:/NASM/bin/nasm.exe
LD:=D:/i686-elf-tools-windows/bin/i686-elf-ld.exe

STAGE_1_DIR:=Stage1
STAGE_2_DIR:=Stage2
BSECT_SRC:=$(BSECT_DIR)/boot_sect.asm

LIBC_DIR:=libc
LIBC_SRC:= $(LIBC_DIR)/stdmem.c $(LIBC_DIR)/stdserial.c

BIN_DIR:=bin

bochs: os-image
	bochs

qemu: os-image
	qemu-system-i386 -hda ../os-image.img

os-image: bootloader
	dd if=/dev/zero of=../os-image.img bs=512 count=2880
	dd if=$(BIN_DIR)/bootloaderStage1.bin of=../os-image.img bs=512 count=1 conv=notrunc

bootloader: 
	nasm -f bin $(STAGE_1_DIR)/bootloaderStage1.asm -o $(BIN_DIR)/bootloaderStage1.bin

clean:
	del /q "$(BIN_DIR)\*.o"
	del /q "$(BIN_DIR)\*.bin"
