include ../Common.mk

all: $(Object_kernel)

$(Object_kernel): CDependency kernel.elf
	$(OBJCOPY32) $(tmp)/kernel.elf $@

%.o: ../kernel/%.c
	$(GCC32) $<

%.o: ../kernel/%.asm
	$(NASM) -o $@ $<

CDependency:
	$(GCC32) -MM ../kernel/$(CSource_kernel) > CDependency.dep

kernel.elf: $(CMain_kernel) $(CObject_kernel) $(AsmObject_kernel)
	$(LD32) -o $@ $^

ifeq (CDependency.dep, $(wildcard CDependency.dep))
include CDependency.dep
endif