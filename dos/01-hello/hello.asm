    bits 16
    org 100h
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

    ; somehow exit the program
exit:
    xor al, al
    mov ah, 0x4c
    int 21h

    ; message data
message: db 'Hello, world!', 10, 13
message_length: equ $ - message

