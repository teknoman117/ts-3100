SECTIONS
{
    . = (1 << 32) - 8192;
    .text : {
        *(.text);
    }

    . = (1 << 32) - 16;
    .reset : {
        *(.reset);
    }
}
