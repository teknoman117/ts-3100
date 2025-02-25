NASM = nasm
NASMFLAGS = -f bin

SRCS = hello.asm
OBJS = $(SRCS:.asm=.com)

# "make" will output these targets
all: ${OBJS}

# Rule to convert ASM files to COM files
%.com: %.asm
	$(NASM) ${NASMFLAGS} -o $@ $<

# Cleanup build artifacts
clean:
	rm -f ${OBJS}
