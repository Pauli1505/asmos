[org 0x7c00]
[bits 16]

section .text

global main

main:
    cli
    jmp 0x0000:ZeroSeg  ; far jump to correct for BIOS putting us in the wrong segment
ZeroSeg:
    xor ax, ax
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, main
    cld
    sti

    ; Reset disk
    xor ax, ax
    mov bx, sTwo
    mov dl, 0x80
    int 0x13

    ; Load sectors from our disk
    mov dl, 0x80
    mov al, 2        ; sectors to read
    mov cl, 2        ; start sector
    mov bx, sTwo     ; offset
    ; es is already 0
    call readDisk

    ; Enable A20 line
    call enableA20

    call print_start
    call print_start0

    jmp $

%include "printf.asm"
%include "readDisk.asm"
%include "printh.asm"
%include "testA20.asm"
%include "enableA20.asm"

LOADING: db 'Loading...', 0x0a, 0x0d, 0
DISK_ERR_MSG: db 'Disk Reading Error!', 0x0a, 0x0d, 0
NO_A20: db 'A20 line: DISABLED!', 0x0a, 0x0d, 0
A20DONE: db 'A20 line: ENABLED!', 0x0a, 0x0d, 0
NO_LM: db 'LM (Long Mode): DISABLED!', 0x0a, 0x0d, 0
YES_LM: db 'LM (Long Mode): ENABLED!', 0x0a, 0x0d, 0
HELLO: db 'Hello, World!', 0x0a, 0x0d, 0

print_start:
    mov si, LOADING
    call printf

print_start0:
    mov si, HELLO
    call printf



times 2 db 0
dw 0xaa55

sTwo:
    ; Additional code for second sector loading and kernel setup...
    jmp $

%include "checklm.asm"
%include "gdt.asm"
