    %include "time.inc"

    ; read only data
    section .rodata
message: db 'Hello, world!', 10, 13
message_length: equ $ - message
filename: db 'ipsum.txt', 0
filename_length: equ $ - filename - 1

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
    sub sp, 6

    ; open a file
    xor al, al
    mov ah, 0x3d
    mov dx, filename
    int 21h
    jc .fail
    mov [bp-2], ax

    ; base time for delayed printing
    call get_centiseconds
    mov di, ax
.loop:
    ; read some bytes from file
    mov ah, 0x3f
    mov bx, [bp-2]
    mov cx, 4
    lea dx, [bp-6]
    int 21h
    jc .fail
    test al, al
    jz .done

    ; write buffer to stdout
    mov cx, ax 
    mov ah, 0x40
    mov bx, 1
    int 21h

    ; wait for a period of time (200 ms)
    mov si, 20
    mov bx, di
    call wait_for_based

    ; advance di by 20 centiseconds
    add di, si
    cmp di, 6000
    jl .norollover
    sub di, 6000
.norollover:

    ; check if a character is in the input buffer
    mov ah, 0x0b
    int 21h
    test al, al
    jz .loop

    ; read character from input buffer
    mov ah, 0x08
    int 21h

    ; key pressed, exit the program
.done:
    mov bx, [bp-2]
    mov ah, 0x3e
    int 21h
    xor al, al
.fail:
    mov sp, bp
    pop bp
    ret
