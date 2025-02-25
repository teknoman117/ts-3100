    extern main

    extern __bss_start
    extern __bss_size_words

    ; entry point
    section .init align=4
    bits 16
entry:
    jmp start

    ; runtime startup code
    section .text align=4
    bits 16
start:
    ; zero .bss data
    mov di, __bss_start
    mov cx, __bss_size_words
    xor ax, ax
    rep stosw

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
