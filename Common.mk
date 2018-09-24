#Compilers
NASM = nasm
GCC32 = i686-elf-gcc -c -m32 -ffreestanding
LD32 = i686-elf-ld -melf_i386 -T ../kernel/elf_i386.x -nostdlib -e Main -Ttext 0x10000
OBJCOPY32 = i686-elf-objcopy -j .text -j .data -j .rodata -j .bss -S -O binary

#Emulators
QEMU = qemu-system-i386
QEMU_OPTION = -L . -m 256 -hda $(Result) -localtime -M pc
BOCHS = bochs
BOCHSRC = bochsrc
BOCHS_OPTION = -q -f

#Sources
# This is for boot/Makefile.
Source_boot = boot.asm
Object_boot = boot
List_boot = boot.lst
# This is for kernel/Makefile
CMain_kernel = Main.o
CSource_kernel = $(notdir $(wildcard *.c))
CObject_kernel = $(subst Main.o, ,$(notdir $(patsubst %.c, %.o, $(CSource_kernel))))
Object_kernel = kernel.bin
# Temp & Result
tmp = ../$(Temp)
Temp = tmp
Result = OS.img