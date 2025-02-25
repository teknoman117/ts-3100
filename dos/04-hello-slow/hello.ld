SECTIONS
{
    /* .COM executable entry point is 0x100 */
    . = 0x100;
    .init : {
        *(.init);
    }

    .text : {
        *(.text);
    }

    . = ALIGN(4);
    .rodata : {
        *(.rodata);
    }
}
