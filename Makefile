
program: primes.o
	ld $^ -o $@

%.o: %.nasm
	nasm -f elf64 $<

example: example.o
	gcc $^ -o $@ -lm

%.o: %.c
	gcc $< -o $@

clean:
	$(RM) *.o program

