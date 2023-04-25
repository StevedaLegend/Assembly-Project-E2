EXECUTABLE=IntegratingCandASM

all:
	nasm -f elf add.asm -o add.o -l starter.lst
	gcc -m32 -c main.c
	gcc -m32 main.o add.o -o $(EXECUTABLE)
	./$(EXECUTABLE)

#Clean folder
clean:
	rm -rf *o *.lst $(EXECUTABLE)