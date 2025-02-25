    extern main

    ; entry point
    section .init align=4
    bits 16
entry:
    jmp start

    ; runtime startup code
    section .text align=4
    bits 16
start:
    ; set up ctrl+c handler
    mov al, 0x23
    mov ah, 0x25
    mov dx, exit
    int 21h

    ; main program code
    call main
exit:
    mov ah, 0x4c
    int 21h

ctrlc_handler:
    xor al, al
    jmp exit
