    %include "registers.inc"

    ; read only data
    section .rodata
message: db 'Are you really, really sure you want to destroy the BIOS?', 13, 10
         db 'Press Y if so...', 13, 10
message_length: equ $ - message
abort: db 'Aborted.', 13, 10
abort_length: equ $ - abort
filename: db 'cmos.bin', 0
filename_length: equ $ - filename - 1

    ; zero'd data
    section .bss
cmosdata: resb 114
cmosdata_length: equ $ - cmosdata

    ; code
    section .text align=4
    bits 16
    global main
    ; main function of the program
    ;  returns
    ;   AL: status code
main:
    ; create stack frame
    push bp
    mov bp, sp

    ; open a file
    xor al, al
    mov ah, 0x3d
    mov dx, filename
    int 21h
    jc .fail

    ; read some bytes from file
    mov bx, ax
    mov ah, 0x3f
    mov cx, cmosdata_length
    mov dx, cmosdata
    int 21h
    jc .fail_opened
    cmp ax, cx
    jne .fail_opened

    ; close file
    mov ah, 0x3e
    int 21h

    ; write buffer to stdout
    mov cx, message_length
    mov dx, message
    mov ah, 0x40
    mov bx, 1
    int 21h

    ; read character from input buffer
    mov ah, 0x08
    int 21h
    cmp al, 'Y'
    jne .fail

    ; destroy the bios by writing poisoned cmos data
    mov di, 0x0e
    mov si, cmosdata
    mov cx, cmosdata_length
    cli
.write_cmos:
    mov ax, di
    inc di
    out 0x70, al
    lodsb
    out 0x71, al
    loop .write_cmos

    ; cause the cpu to reset
.reset_cpu:
    mov dx, WDTRLDH
    mov ax, 1
    out dx, ax
    mov dx, WDTRLDL
    xor ax, ax
    out dx, ax
    mov dx, WDTCLR
    mov ax, 0xf01e
    out dx, ax
    mov ax, 0x0fe1
    out dx, ax

    ; wait for cpu to reset in ~2.6 ms
.loop:
    jmp .loop

.fail_opened:
    mov ah, 0x3e
    int 21h
.fail:
    mov cx, abort_length
    mov dx, abort
    mov ah, 0x40
    mov bx, 1
    int 21h
    mov sp, bp
    pop bp
    ret
