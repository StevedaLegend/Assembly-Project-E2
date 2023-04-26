EXECUTABLE=IntegratingCandASM

all:
	nasm -f elf add.asm -o add.o -l starter.lst
	nasm -f elf multiply.asm -o multiply.o -l mul.lst
	gcc -m32 -c main.c
	gcc -m32 main.o add.o multiply.o -o $(EXECUTABLE)
	./$(EXECUTABLE)

#Clean folder
clean:
	rm -rf *o *.lst $(EXECUTABLE)