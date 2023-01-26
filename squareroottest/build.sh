gcc testa.c -c -o testa.o
nasm -f elf64 testb.asm -o testb.o
gcc testa.o testb.o -o test
