    ; registers
P1LTC: equ 0xf862
P1DIR: equ 0xf864

    ; initial entry point
    section .text
    bits 16
_boot:
    cli
    ; Enable expanded I/O space of Intel386(tm) EX processor for peripheral initialization.
    mov ax, 0x8000
    out 0x23, al
    xchg al, ah
    out 0x22, al
    out 0x22, ax

    ; led pin to output
    mov dx, P1DIR
    in al, dx
    and al, 0xbf
    out dx, al

    ; turn led off
    mov dx, P1LTC
    in al, dx
    or al, 0x40
    out dx, al
.spin:
    hlt
    jmp .spin

    ; reset vector
    section .reset
    bits 16
_reset:
    jmp _boot
    times 16 - ($ - $$) db 0

