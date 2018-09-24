include Common.mk

.PHONY: all prepare build run-qemu run-bochs run-bfe clean

all: build

prepare:
	mkdir -p $(Temp)

build: prepare
	make -C boot
	make -C kernel
	make -C tools
	tmp/Aligntool $(Result) $(Temp)/$(Object_boot) $(Temp)/$(Object_kernel)

run-qemu: build
	$(QEMU) $(QEMU_OPTION)

run-bochs: build
	$(BOCHS) $(BOCHS_OPTION) $(BOCHSRC)

clean:
	rm -rf $(Temp)
	rm -rf $(Result)