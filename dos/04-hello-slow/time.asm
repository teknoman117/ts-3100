    section .text align=4
    bits 16

    global get_centiseconds
    ; get current time
    ;  returns:
    ;   AX: time in centiseconds, rolls over every minute (0-5999)
get_centiseconds:
    mov ah, 0x2c
    int 21h
    ; ch = hours
    ; cl = minutes
    ; dh = seconds
    ; dl = centiseconds
    mov al, 100
    mul dh
    xor dh, dh
    add ax, dx
    ret

    global wait_for
    ; delay for a period of time
    ;  arguments:
    ;   SI: centiseconds to delay for
wait_for:
    call get_centiseconds
    mov bx, ax

    global wait_for_based
    ; delay for a period of time with a base time
    ;  arguments:
    ;   SI: centiseconds to delay for
    ;   BX: base time
wait_for_based:
    call get_centiseconds
    sub ax, bx
    jae .norollover
    add ax, 6000
.norollover:
    cmp ax, si
    jb wait_for_based
    ret
