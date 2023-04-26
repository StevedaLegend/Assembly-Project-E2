global add

section .data
section .text
add:
    mov   eax, [esp+4]      ; argument 1 offset by 4 bytes (size of interger), first 4 bytes current instruction
    add   eax, [esp+8]      ; argument 2 offset by 4 bytes (size of interger)
    add   eax, [esp+12]
    ret