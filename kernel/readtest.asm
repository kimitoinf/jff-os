[org 0x00]
[bits 16]
section .text
jmp 0x1000:Start
sectorcount: dw 0x0000
totalsectorcount equ 1024

Start:
	mov ax, cs
	mov ds, ax
	mov ax, 0xb800
	mov es, ax
	%assign i 0
	%rep totalsectorcount
		%assign i i+1
		mov ax, 2
		mul word[sectorcount]
		mov si, ax
		mov byte[es:si], '0'+(i % 10)
		inc word[sectorcount]
		%if i == totalsectorcount
			jmp $
		%else
			jmp (0x1000 + i * 0x20):0x0000
		%endif
		times (512 - ($ - $$) % 512) db 0x00
	%endrep