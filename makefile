CC:=D:/i686-elf-tools-windows/bin/i686-elf-gcc.exe
# CC:=C:/Users/Wutpups/Desktop/OSDev/bin/i686-elf-tools-windows/bin/i686-elf-gcc.exe
CFLAGS:=-ffreestanding
CFLAGS_OPT:=-fauto-inc-dec -fbranch-count-reg -fcombine-stack-adjustments -fcompare-elim -fcprop-registers -fdce -fdefer-pop -fdelayed-branch -fdse -fforward-propagate -fguess-branch-probability -fif-conversion -fif-conversion2 -finline-functions-called-once -fvect-cost-model=cheap -fipa-profile -fipa-pure-const -fipa-reference -fmerge-constants -fmove-loop-invariants -fomit-frame-pointer -freorder-blocks -fshrink-wrap -fshrink-wrap-separate -fsplit-wide-types -fssa-backprop -fssa-phiopt -ftree-bit-ccp -ftree-ccp -ftree-ch -ftree-coalesce-vars -ftree-copy-prop -ftree-dce -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre -ftree-phiprop -ftree-pta -ftree-scev-cprop -ftree-sink -ftree-slsr -ftree-sra -ftree-ter -funit-at-a-time -falign-functions -falign-jumps -falign-labels -falign-loops -fcaller-saves -fcode-hoisting -fcrossjumping -fcse-follow-jumps -fcse-skip-blocks -fdelete-null-pointer-checks -fdevirtualize -fdevirtualize-speculatively -fexpensive-optimizations -fgcse -fgcse-lm -fhoist-adjacent-loads -finline-functions -finline-small-functions -findirect-inlining -fipa-bit-cp -fipa-cp -fipa-icf -fipa-ra -fipa-sra -fipa-vrp -fisolate-erroneous-paths-dereference -flra-remat -foptimize-sibling-calls -foptimize-strlen -fpartial-inlining -fpeephole2 -freorder-blocks-algorithm=stc -freorder-blocks-and-partition -freorder-functions -frerun-cse-after-loop -fschedule-insns -fschedule-insns2 -fsched-interblock -fsched-spec -fstore-merging -fstrict-aliasing -fthread-jumps -ftree-builtin-call-dce -ftree-loop-vectorize -ftree-pre -ftree-slp-vectorize -ftree-switch-conversion -ftree-tail-merge -ftree-vrp -fgcse-after-reload -fipa-cp-clone -floop-interchange -floop-unroll-and-jam -fpeel-loops -fpredictive-commoning -fsplit-loops -fsplit-paths -ftree-loop-distribution -ftree-partial-pre -funswitch-loops -fvect-cost-model=dynamic -ffreestanding
CFLAGS_DEBUG:=-ffreestanding -g

AS:=D:/NASM/nasm.exe
# AS:=C:/Users/Wutpups/Desktop/OSDev/bin/nasm-2.16.01-win64/nasm-2.16.01/nasm.exe

LD:=D:/i686-elf-tools-windows/bin/i686-elf-ld.exe
# LD:=C:/Users/Wutpups/Desktop/OSDev/bin/i686-elf-tools-windows/bin/i686-elf-ld.exe

DD:=dd
# DD:=C:/Users/Wutpups/Desktop/OSDev/bin/dd.exe

BIN_DIR:=bin

# Bootloader variables
BL_DIR:=bootloader
BL_STAGE_1_DIR:=stage1
BL_STAGE_2_DIR:=stage2
BL_STAGE_1_SRC:=bootloader_stage_1.asm
BL_STAGE_2_SRC:=bootloader_stage_2.asm

# Kernel variables
KERNEL_DIR:=kernel
KERNEL_SRC:=$(KERNEL_DIR)/kernel.c $(KERNEL_DIR)/kernel_entry.asm

# Libc variables
LIBC_DIR:=libc
LIBC_SRC:=$(LIBC_DIR)/stdlowlevel.c $(LIBC_DIR)/stdserialio.c $(LIBC_DIR)/stdmem.c $(LIBC_DIR)/stddraw.c $(LIBC_DIR)/stdmath.c

qemu: os-image
	qemu-system-i386 -device virtio-gpu -hda os-image.img

os-image: bootloader kernel
	$(DD) if=/dev/zero of=os-image.img bs=512 count=2880
	$(DD) if=$(BIN_DIR)/bootloader_stage_1.bin of=os-image.img bs=512 count=1 conv=notrunc
	$(DD) if=$(BIN_DIR)/bootloader_stage_2.bin of=os-image.img bs=512 seek=1 conv=notrunc
	
	$(DD) if=$(BIN_DIR)/kernel.bin of=os-image.img bs=512 seek=3 conv=notrunc

bootloader: $(BL_DIR)/$(BL_STAGE_1_DIR)/$(BL_STAGE_1_SRC) $(BL_DIR)/$(BL_STAGE_2_DIR)/$(BL_STAGE_2_SRC)
	$(AS) -f bin $(BL_DIR)/$(BL_STAGE_1_DIR)/bootloader_stage_1.asm -o $(BIN_DIR)/bootloader_stage_1.bin
	$(AS) -f bin $(BL_DIR)/$(BL_STAGE_2_DIR)/bootloader_stage_2.asm -o $(BIN_DIR)/bootloader_stage_2.bin

kernel: $(KERNEL_SRC) libc
	$(AS) $(KERNEL_DIR)/kernel_entry.asm -f elf -o $(BIN_DIR)/kernel_entry.o
	$(CC) $(CFLAGS) -c $(KERNEL_DIR)/kernel.c -o $(BIN_DIR)/kernel.o
	$(LD) -o $(BIN_DIR)/kernel.bin -Ttext 0x2000 $(BIN_DIR)/kernel_entry.o $(BIN_DIR)/kernel.o $(BIN_DIR)/stdmem.o $(BIN_DIR)/stdserialio.o $(BIN_DIR)/stdlowlevel.o $(BIN_DIR)/stddraw.o $(BIN_DIR)/stdmath.o --oformat binary

libc: $(LIBC_SRC)
	$(CC) $(CFLAGS) -c $(LIBC_DIR)/stdmem.c -o $(BIN_DIR)/stdmem.o
	$(CC) $(CFLAGS) -c $(LIBC_DIR)/stdserialio.c -o $(BIN_DIR)/stdserialio.o
	$(CC) $(CFLAGS) -c $(LIBC_DIR)/stdlowlevel.c -o $(BIN_DIR)/stdlowlevel.o
	$(CC) $(CFLAGS) -c $(LIBC_DIR)/stddraw.c -o $(BIN_DIR)/stddraw.o
	$(CC) $(CFLAGS) -c $(LIBC_DIR)/stdmath.c -o $(BIN_DIR)/stdmath.o

clean:
	del /q "$(BIN_DIR)\*.o"
	del /q "$(BIN_DIR)\*.bin"