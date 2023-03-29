; Filename starter.asm

; GLOBALS
global _start ;Declared for linker this is declaring _start (entry point)

; TEXT SECTION
section	.text
_start:	                                 ;linker entry point
   mov	rdx,  msg_length                 ;message length see length equ 64 Bit Register

   mov	rsi,  message                    ;message 64 Bit Register

   mov	rdi,  0x1                        ;file descriptor (stdout) 64 Bit Register

   mov	rax,  0x1                        ;system call number (sys_write) 64 Bit Register

   syscall                                ;call kernel 64 bit System
	
   mov	rax,  0x3c                       ;system call number (sys_exit) 64 Bit Register

   mov   rdi,  0x0                        ;return status 64 Bit Register

   syscall                                ;call kernel 64 bit System

; DATA SECTION
section	.data

message db 'Hello, x64 assembly!', 0xA    ;string to be printed
msg_length equ $-message                  ;length of the string
