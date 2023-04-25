global mul

section .data
section .text
mul:
    mov   eax, [esp+4]      ; argument 1 offset by 4 bytes (size of interger), first 4 bytes current instruction
    mul   dword [esp+6]      ; argument 2 offset by 4 bytes (size of interger)
    mul   dword [esp+2]
    ret