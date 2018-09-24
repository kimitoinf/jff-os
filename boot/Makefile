include ../Common.mk

all: build

build: $(Source_boot)
	$(NASM) -f bin -o $(tmp)/$(Object_boot) $< -l $(tmp)/$(List_boot)