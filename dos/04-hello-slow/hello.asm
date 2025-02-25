    %include "time.inc"

    ; read only data
    section .rodata
message: db 'Hello, world!', 10, 13
message_length: equ $ - message

    ; code
    section .text align=4
    bits 16
    global main
    ; main function of the program
    ;  returns
    ;   AL: status code
main:
    call get_centiseconds
    mov di, ax
.loop:
    ; somehow write a message to the console
    ; handle 0 - stdin
    ; handle 1 - stdout
    ; handle 2 - stderr
    mov ah, 0x40
    mov bx, 1
    mov cx, message_length
    mov dx, message
    int 21h

    ; wait for a period of time
    mov si, 20
    mov bx, di
    call wait_for_based

    ; advance di by 20 centiseconds
    add di, si
    cmp di, 6000
    jb .norollover
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
    xor al, al
    ret
