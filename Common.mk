#Compilers
NASM = nasm
GCC32 = x86_64-elf-gcc -c -m32 -ffreestanding
LD32 = x86_64-elf-ld -melf_i386 -T ../kernel/elf_i386.x -nostdlib -e Main -Ttext 0x10000
OBJCOPY32 = x86_64-elf-objcopy -j .text -j .data -j .rodata -j .bss -S -O binary

#Emulators
QEMU = qemu-system-i386
QEMU_OPTION = -L . -m 256 -hda $(Result) -localtime -M pc
BOCHS = bochs
BOCHSRC = bochsrc
BOCHS_OPTION = -q -f

#Sources
# This is for boot/Makefile.
Source_boot = boot.asm
Object_boot = boot.bin
List_boot = boot.lst
# This is for kernel/Makefile
CMain_kernel = Main.o
CSource_kernel = $(notdir $(wildcard ../kernel/*.c))
CObject_kernel = $(subst Main.o, ,$(notdir $(patsubst %.c, %.o, $(CSource_kernel))))
AsmSource_kernel = $(notdir $(wildcard ../kernel/*.asm))
AsmObject_kernel = $(notdir $(patsubst %.asm, %.o, $(AsmSource_kernel)))
Object_kernel = kernel.bin
# Temp & Result
tmp = ../$(Temp)
Temp = tmp
Result = OS.img