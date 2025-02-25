PROJECT_NAME = destroy
OUTPUT_FORMAT = binary
PROJECT_BINARY = ${PROJECT_NAME}.com

NASM = nasm
LD = ld
OBJCOPY = objcopy
OBJDUMP = objdump

NASMFLAGS = -f elf32
LDFLAGS = -T ${PROJECT_NAME}.ld -m elf_i386

SRCS = main.asm rt.asm
OBJS = $(SRCS:.asm=.o)

# "make" will output these targets
all: ${PROJECT_BINARY} ${PROJECT_NAME}.lst

# Rule to convert ASM files to Object files
%.o: %.asm
	$(NASM) ${NASMFLAGS} -o $@ $<

# Produce binary from ELF file
${PROJECT_BINARY}: ${PROJECT_NAME}.elf
	$(OBJCOPY) -O ${OUTPUT_FORMAT} ${PROJECT_NAME}.elf ${PROJECT_BINARY}

# Produce list file from linked ELF
${PROJECT_NAME}.lst: ${PROJECT_NAME}.elf
	$(OBJDUMP) -M i8086 -D ${PROJECT_NAME}.elf > ${PROJECT_NAME}.lst

# Produce linked ELF from objects
${PROJECT_NAME}.elf: ${OBJS}
	$(LD) ${LDFLAGS} -o ${PROJECT_NAME}.elf ${OBJS}

# Cleanup build artifacts
clean:
	rm -f ${PROJECT_BINARY} ${PROJECT_NAME}.lst ${PROJECT_NAME}.elf ${OBJS}
