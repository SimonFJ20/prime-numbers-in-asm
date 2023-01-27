
all: program example

program: primes.o
	ld $^ -o $@

%.o: %.asm
	nasm -f elf64 $<

example: example.o
	gcc $^ -o $@ -lm

%.o: %.c
	gcc $< -c -o $@

clean:
	$(RM) *.o program example

