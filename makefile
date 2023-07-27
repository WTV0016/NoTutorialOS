CC:=D:/i686-elf-tools-windows/bin/i686-elf-g++.exe
CFLAGS:=-ffreestanding
CFLAGS_DEBUG:=-ffreestanding -g

AS:=D:/NASM/bin/nasm.exe
LD:=D:/i686-elf-tools-windows/bin/i686-elf-ld.exe

BIN_DIR:=bin

# Bootloader variables
BL_DIR:=bootloader
BL_STAGE_1_DIR:=stage1
BL_STAGE_2_DIR:=stage2
BL_STAGE_1_SRC:=bootloader_stage_1.asm
BL_STAGE_2_SRC:=bootloader_stage_2.asm

bochs: os-image
	bochs

qemu: os-image
	qemu-system-i386 -hda os-image.img

os-image: bootloader
	dd if=/dev/zero of=os-image.img bs=512 count=2880
	dd if=$(BIN_DIR)/bootloader_stage_1.bin of=os-image.img bs=512 count=1 conv=notrunc
	dd if=$(BIN_DIR)/bootloader_stage_2.bin of=os-image.img bs=512 seek=1 conv=notrunc
	
#	dd if=$(BIN_DIR)/kernel.bin of=os-image.img bs=512 seek=5 conv=notrunc

bootloader: $(BL_DIR)/$(BL_STAGE_1_DIR)/$(BL_STAGE_1_SRC) $(BL_DIR)/$(BL_STAGE_2_DIR)/$(BL_STAGE_2_SRC)
	nasm -f bin $(BL_DIR)/$(BL_STAGE_1_DIR)/bootloader_stage_1.asm -o $(BIN_DIR)/bootloader_stage_1.bin
	nasm -f bin $(BL_DIR)/$(BL_STAGE_2_DIR)/bootloader_stage_2.asm -o $(BIN_DIR)/bootloader_stage_2.bin

clean:
	del /q "$(BIN_DIR)\*.o"
	del /q "$(BIN_DIR)\*.bin"
