    ; read only data
    section .rodata
message: db 'Hello, world!', 10, 13
message_length: equ $ - message

    ; code
    section .text
    bits 16
    org 100h

    ; set up ctrl+c handler
    mov al, 0x23
    mov ah, 0x25
    mov dx, exit
    int 21h

main:
    ; somehow write a message to the console
    ; handle 0 - stdin
    ; handle 1 - stdout
    ; handle 2 - stderr
    mov ah, 0x40
    mov bx, 1
    mov cx, message_length
    mov dx, message
    int 21h

    ; check if a character is in the input buffer
    mov ah, 0x0b
    int 21h
    test al, al
    jz main

    ; read character from input buffer
    mov ah, 0x08
    int 21h

    ; key pressed, exit the program
exit:
    xor al, al
    mov ah, 0x4c
    int 21h
