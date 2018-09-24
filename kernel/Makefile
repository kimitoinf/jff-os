include ../Common.mk

all: $(tmp)/$(Object_kernel)

$(tmp)/$(Object_kernel): CDependency $(tmp)/kernel.elf
	$(OBJCOPY32) $(tmp)/kernel.elf $@

%.o: ../kernel/%.c
	cd $(tmp)
	$(GCC32) -c $<
	cd ../kernel

CDependency:
	$(GCC32) -MM $(CSource_kernel) > $(tmp)/CDependency.dep

$(tmp)/kernel.elf: $(CMain_kernel) $(CObject_kernel)
	$(LD32) -o $@ $^

ifeq ($(tmp)/CDependency.dep, $(wildcard CDependency.dep))
include $(tmp)/CDependency.dep
endif