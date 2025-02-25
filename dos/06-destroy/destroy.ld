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

    . = ALIGN(4);
    __bss_start = .;
    .bss (NOLOAD) : {
        *(.bss);
    }
    __bss_end = .;
    __bss_size_words = SIZEOF(.bss) >> 1;
}
