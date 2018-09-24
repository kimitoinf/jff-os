[org 0x7C00]
[bits 16]

section .text
Readsectors: dw 0 ; set automatically

Main16:
	mov byte[Bootdrive], DL
	mov AX, 0x0000
	mov DS, AX
	mov AH, 0x00
	mov DL, byte[Bootdrive]
	int 0x13
	jc Error
	mov DI, word[Readsectors]
	.ReadLBA:
		cmp DI, 0
		je .Next
		dec DI
		mov AX, 0x00
		mov DS, AX
		mov SI, DAP
		mov AH, 0x42
		mov DL, byte[Bootdrive]
		int 0x13
		jc .ReadCHS
		inc dword[DAP.LBA]
		add word[DAP.Address], 0x0020
		jmp .ReadLBA
	.ReadCHS:
		mov AH, 0x08
		mov DL, byte[Bootdrive]
		int 0x13
		jc Error
		and CL, 0x3F
		mov byte[Sectors], CL
		mov byte[Heads], DH
		mov byte[Tracks], CH
		mov SI, 0x1000
		mov ES, SI
		mov BX, 0x0000
		mov DI, word[Readsectors]
		.Loop:
			cmp DI, 0
			je .Next
			dec DI
			mov AH, 0x02
			mov AL, 0x01
			mov CL, byte[CurrentSector]
			mov DH, byte[CurrentHead]
			mov CH, byte[CurrentTrack]
			mov DL, byte[Bootdrive]
			int 0x13
			jc Error
			add SI, 0x0020
			mov ES, SI
			mov AL, byte[CurrentSector]
			cmp AL, byte[Sectors]
			inc AL
			mov byte[CurrentSector], AL
			jb .Loop
			mov byte[CurrentSector], 0x01
			mov AL, byte[CurrentHead]
			cmp AL, byte[Heads]
			inc byte[CurrentHead]
			jb .Loop
			mov byte[CurrentHead], 0x00
			inc byte[CurrentTrack]
			jmp .Loop
	.Next:
		in AL, 0x92
		or AL, 0x02
		and AL, 0xFE
		out 0x92, AL
		cli
		lgdt [GDTR]
		mov EAX, CR0
		or EAX, 1
		mov CR0, EAX
		jmp dword Code:Main32

Error:
	jmp $

DAP:
			db 0x10
			db 0x00
			dw 1
			dw 0x0000
.Address: 	dw 0x1000
.LBA:		dd 1
			dd 0

Sectors: db 0x00
Heads: db 0x00
Tracks: db 0x00
CurrentSector: db 0x02
CurrentHead: db 0x00
CurrentTrack: db 0x00
Bootdrive: db 0x00

[bits 32]
Main32:
	mov AX, Data
	mov ES, AX
	mov DS, AX
	mov FS, AX
	mov GS, AX
	mov SS, AX
	mov ESP, 0xFFFE
	mov EBP, 0xFFFE
	
	jmp dword Code:0x10000

GDTR:
	dw GDTEND - GDT - 1
	dd (GDT - $$ + 0x7C00)

GDT:
	Null equ 0x00
		dw 0x0000
		dw 0x0000
		db 0x00
		db 0x00
		db 0x00
		db 0x00
	Code equ 0x08
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x9A
		db 0xCF
		db 0x00
	Data equ 0x10
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x92
		db 0xCF
		db 0x00
GDTEND:

times 510 - ($ - $$) db 0x00
db 0x55
db 0xAA