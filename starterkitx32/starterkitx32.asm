; Filename starterkitx32.asm

;-------------------------------------------------------
; CHOOSE TO BE A HERO OR A VILLIAN 
;-------------------------------------------------------

;-------------------------------------------------------
; VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
; ADD ADDITIONAL VALIDATION VALUES AS REQUIRED
;-------------------------------------------------------
MIN_POTIONS EQU 1                       ; MIN NUMBER OF POTIONS
MAX_POTIONS EQU 9                       ; MAX NUMBER OF POTIONS
MIN_WEAPONS EQU 1                       ; MIN WEAPONS
MAX_WEAPONS EQU 3                       ; MAX WEAPONS
WIN_POINT   EQU 5                       ; POINTS ACCUMILATED ON WIN
LOSE_POINT  EQU 8                       ; POINTS DEDUCTED ON A LOSS

MAX_HEALTH  EQU 100                     ; Max Health
MIN_HEALTH  EQU 0                       ; Min Health
LOSE_HEALTH EQU 10                      ; POINTS DEDUCTED ON A LOSS

MINE_LOC    EQU 100                     ; USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP
                                        ; EXAMPLE FOR A HIT
SCORE_INIT  EQU 0                       ; Initialize Scroe at 0
SCORE_INC   EQU 100                     ; Score increment
SCORE_VAL   EQU 9900                    ; Last possible score value, after this set to 9999
MAX_SCORE   EQU 9999                    ; Max Score

STATUS_OK   EQU 0x00                    ; return status okay
SYS_EXIT    EQU 0x01                    ; system exit
SYS_KERNEL  EQU 0x80                    ; kernel call
SYS_READ    EQU 0x03                    ; System read
SYS_STDIN   EQU 0x02                    ; stdin
SYS_STDOUT  EQU 0x01                    ; stdout
SYS_WRITE   EQU 0x04                    ; System write

;-------------------------------------------------------
;--------------------Globals----------------------------
;-------------------------------------------------------
global _start                           ; Declared for linker this is declaring _start (entry point)

;-------------------------------------------------------
;--------------------Entry Point------------------------
;-------------------------------------------------------	
_start: ;linker entry point
    call    clear_screen                ; CLEARS THE SCREEN 
    call    initialize                  ; Initialize Game Data
    call    red_terminal                ; Red Terminal
    call    welcome                     ; Branch to Welcome Procedure
    call    continue                    ; Press anykey to continue
    call    clear_screen                ; CLEARS THE SCREEN 
    call    blue_terminal               ; Blue Terminal
    call    game_input                  ; Branch to Game Input Procedure
    call    continue                    ; Press anykey to continue 
    call    default_terminal            ; Default Terminal
    call    game                        ; Branch to Game Procedure
    call    flush                       ; Flush before exit
    call    system_exit                 ; Exit and Clean Up

;-------------------------------------------------------
;--------------------System Exit------------------------
;-------------------------------------------------------
system_exit:
    mov     ebx, STATUS_OK              ; return status 32 Bit Registerr
    mov     eax, SYS_EXIT               ; system call number (sys_exit) 32 Bit Register
    int     SYS_KERNEL                  ; call kernel, system call 32 bit System  

;-------------------------------------------------------
;-------------------Write to stdout---------------------
;-------------------------------------------------------
sys_write:
    mov     ebx, SYS_STDOUT             ; file descriptor (stdout) 32 Bit Register
    mov     eax, SYS_WRITE              ; system call number (sys_write) 32 Bit Register
    int     SYS_KERNEL                  ; call kernel, system call 32 bit System
    ret                                 ; return

;-------------------------------------------------------
;-------------------Read from stdin---------------------
;-------------------------------------------------------
sys_read:
    mov     ebx, SYS_STDIN              ; file descriptor (stdin) 32 Bit Register
    mov     eax, SYS_READ               ; system call number (sys_read) 32 Bit Register    
    int     SYS_KERNEL                  ; call kernel, system call 32 bit System
    ret                                 ; return

;-------------------------------------------------------
;---------------------Write ENDL------------------------
;-------------------------------------------------------
write_endl:
    mov     ecx, crlf                   ; message 32 Bit Register
    mov     edx, len_crlf               ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write
    ret                                 ; return

;-------------------------------------------------------
;----------------Initialize SUBROUTINE------------------
;-------------------------------------------------------
initialize:
    xor     eax, eax                    ; clear eax accumulator register
    mov     eax, SCORE_INIT             ; Moves 0 to Score
    mov     [score], eax                ; Initialize score at 0

    xor     eax, eax                    ; clear eax accumulator register
    mov     eax, MAX_HEALTH             ; Moves 100 to Health
    mov     [health], eax               ; Initialize score at 0
    ret

;-------------------------------------------------------
;-------------------WELCOME SUBROUTINE------------------
;-------------------------------------------------------
welcome:
    call    write_endl                  ; write ENDL
    mov     ecx, welcome_msg            ; message 32 Bit Register
    mov     edx, len_welcome_msg        ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write  
    call    write_endl                  ; write ENDL
    call    write_continue              ; call continue
    ret                                 ; return

;-------------------------------------------------------
;---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
;-------------------------------------------------------    
game_input:
    call    decorate                    ; Decorate screen
    call    potions_input               ; BRANCH TO POTION INPUT SUBROUTINE
    call    decorate                    ; Decorate screen
    call    weapons_input               ; BRANCH TO WEAPONSS INPUT SUBROUTINE
    call    write_endl                  ; write ENDL
    call    decorate                    ; Decorate screen
    call    write_continue              ; call continue msg
    ret                                 ; return

;-------------------------------------------------------
;-----------------POTIONS INVENTORY---------------------
; NUMBER OF POTIONS TO BE USED IN A QUEST 
;------------------------------------------------------- 
potions_input:
    call    write_endl                  ; write ENDL
    mov     ecx, potion_msg             ; message 32 Bit Register
    mov     edx, len_potion_msg         ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write    
    call    write_endl                  ; write ENDL
    mov     ecx, potions_msg            ; message 32 Bit Register
    mov     edx, len_potions_msg        ; message length see length equ 32 Bit Register
    call    write_endl                  ; write ENDL
    call    sys_write                   ; call sys_write    
    ret

;-------------------------------------------------------
;-------------------------WEAPONS-----------------------
; NUMBER OF WEAPONS
;*-------------------------------------------------------   
weapons_input:
    call    write_endl                  ; write ENDL
    mov     ecx, weapons_msg            ; message 32 Bit Register
    mov     edx, len_weapons_msg        ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret

;-------------------------------------------------------
;-------------------GAME SUBROUTINE---------------------
;-------------------------------------------------------
game:
    call    gameloop                    ; BRANCH TO GAMELOOP SUBROUTINE
    ret                                 ; RETURN FROM GAME: SUBROUTINE

;-------------------------------------------------------
;----------------GAMELOOP (MAIN LOOP)-------------------
;------------------------------------------------------- 
gameloop:
    call    clear_screen                ; CLEARS THE SCREEN 
    call    decorate                    ; Decorate screen
    call    update                      ; BRANCH TO UPDATE GAME SUBROUTINE 
    call    decorate                    ; Decorate screen
    call    draw                        ; BRANCH TO DRAW SCREEN SUBROUTINE
    call    decorate                    ; Decorate screen
    call    gameplay                    ; BRANCH TO GAMEPLAY SCREEN SUBROUTINE
    call    decorate                    ; Decorate screen
    call    green_terminal              ; Green Terminal
    call    hud                         ; BRANCH TO DISPLAY HUD SUBROUTINE
    call    default_terminal            ; Default Terminal
    call    decorate                    ; Decorate screen
    call    collision                   ; BRANCH TO COLLISION SUBROUTINE
    call    decorate                    ; Decorate screen
    call    replay                      ; BRANCH TO REPLAY GAME SUBROUTINE
    ret                                 ; RETURN FROM GAMELOOP: SUBROUTINE

;-------------------------------------------------------
;----------------UPDATE QUEST PROGRESS------------------
;  COMPLETE QUEST
;------------------------------------------------------- 
update:
    call    write_endl                  ; write ENDL
    mov     ecx, update_msg             ; message 32 Bit Register
    mov     edx, len_update_msg         ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL

    call    .update_score               ; update score    
    call    .update_health              ; update health 

    ret                                 ; RETURN FROM UPDATE: SUBROUTINE

.update_score:
    xor     eax, eax                    ; clear eax accumulator register
    mov     eax, [score]                ; fetch score
   
    mov     ecx, eax                    ; move to ecx for comparison
    cmp     ecx, SCORE_VAL              ; Check is score is less than SCORE_VAL
    jl      .set_score                  ; set score 
.set_score_max:    
    mov     eax, MAX_SCORE              ; set score to MAX_SCORE
    mov     [score], eax                ; update score
    jmp     .end_update_score           ; goto end or procedure
.set_score:
    add     eax, SCORE_INC              ; increment score by SCORE_INC per round
    mov     [score], eax                ; update score
    jmp     .end_update_score           ; goto end or procedure
.end_update_score:
    ret                                 ; return
    
.update_health:
    xor     eax, eax                    ; clear eax accumulator register
    mov     eax, [health]               ; fetch health
    
    mov     ecx, eax
    cmp     ecx, LOSE_HEALTH            ; Check is health remaining is greater than LOSE_HEALTH
    jge     .set_health                 ; set health
.set_health_zero:    
    mov     eax, MIN_HEALTH             ; set health to 0
    mov     [health], eax               ; update health
    jmp     .end_update_health          ; goto end or procedure
.set_health:
    sub     eax, LOSE_HEALTH            ; decrement health by 10 per round (TODO Change GSM when Health reached 0)
    mov     [health], eax               ; update health
    jmp     .end_update_health          ; goto end or procedure
.end_update_health:
    ret                                 ; return

;-------------------------------------------------------
;-----------------DRAW QUEST UPDATES--------------------
; DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
; QUEST
;------------------------------------------------------- 
draw:
    call    write_endl                  ; write ENDL
    mov     ecx, draw_msg               ; message 32 Bit Register
    mov     edx, len_draw_msg           ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret                                 ; RETURN FROM DRAW: SUBROUTINE

;-------------------------------------------------------
;---GAME PLAY (QUEST PROGRESS)--------------------------
;------------------------------------------------------- 
gameplay:
    call    write_endl                  ; write ENDL
    mov     ecx, gameplay_msg           ; message 32 Bit Register
    mov     edx, len_gameplay_msg       ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret                                 ; RETURN FROM DRAW: SUBROUTINE

;-------------------------------------------------------
;------------HEADS UP DISPLAY (SCORE & \HEALTH)---------
; RETRIEVES THE SCORE FROM MEMORY LOCATION
; RETRIEVES THE HEALTH FROM MEMORY LOCATION
;-------------------------------------------------------   
hud:
    call    .hud_score                  ; print score
    call    .hud_health                 ; print health
    ret                                 ; RETURN FROM HUD: SUBROUTINE

.hud_score:
    call    write_endl                  ; write ENDL
    mov     ecx, score_msg              ; message 32 Bit Register
    mov     edx, len_score_msg          ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   

    mov     eax, [score]                ; Pass number to eax
    mov     esi, buffer                 ; Size of Buffer
    
    call    int_to_string               ; Call int_to_string

    mov     ecx, eax                    ; Result in eax, pass to ecx to print                 
    mov     edx, 0x4                    ; message length see length equ 32 Bit Register

    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret                                 ; return

.hud_health:
    mov     ecx, health_msg             ; message 32 Bit Register
    mov     edx, len_health_msg         ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   

    mov     eax, [health]               ; Pass number to eax
    mov     esi, buffer                 ; Size of Buffer
    
    call    int_to_string               ; Call int_to_string

    mov     ecx, eax                    ; Result in eax, pass to ecx to print                 
    mov     edx, 0x4                    ; message length see length equ 32 Bit Register

    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret


;-------------------------------------------------------
;----------------------Continue-------------------------
;-------------------------------------------------------
write_continue:
    call    write_endl                  ; write ENDL
    mov     ecx, continue_msg           ; message 32 Bit Register
    mov     edx, len_continue_msg       ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write  
    ret                                 ; return
;-------------------------------------------------------
;------------------------REPLAY-------------------------
;-------------------------------------------------------
replay:
    call    write_endl                  ; write ENDL
    mov     ecx, replay_msg             ; message 32 Bit Register
    mov     edx, len_replay_msg         ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write
    mov     ecx, action                 ; move input to action  
    mov     edx, 1                      ; size of input
    call    sys_read                    ; call sys_read
    mov     ebx, ecx                    ; move to compare input
    cmp     byte [ebx], 0x30            ; compare value in register with 0x30 Hex ASCII for 0
    jne     gameloop                    ; jump tp gameloop if not equals 0
    call    write_endl                  ; write ENDL
    ret                                 ; RETURN FROM REPLAY: SUBROUTINE

;-------------------------------------------------------
;------------------SCREEN DECORATION--------------------
;-------------------------------------------------------
decorate:
    call    write_endl                  ; write ENDL
    mov     ecx, loop_msg               ; message 32 Bit Register
    mov     edx, len_loop_msg           ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write
    call    write_endl                  ; write ENDL
    ret                                 ; RETURN FROM DECORATE: SUBROUTINE

;-------------------------------------------------------
;---------------Collision Detection (Attacked)----------
; This procedure is used for collision detection
;-------------------------------------------------------
collision:
    xor     ebx, ebx                    ; clear ebx
    mov     ebx, MINE_LOC               ; move ordinace location into ebx
    cmp     ebx, 0x64                   ; compare value in register with 0x64 100,ebx IS( X == 100)?
	jne     collision_miss              ; COLLISION_MISS IF X IS NOT EQUAL TO 100, OTHERWISW HIT
collision_hit:
    call    write_endl                  ; write ENDL
    mov     ecx, hit_msg                ; message 32 Bit Register
    mov     edx, len_hit_msg            ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret                                 ; RETURN FROM COLLISION: SUBROUTINE

collision_miss:
    call    write_endl                  ; write ENDL
    mov     ecx, miss_msg               ; message 32 Bit Register
    mov     edx, len_miss_msg           ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write   
    call    write_endl                  ; write ENDL
    ret                                 ; RETURN FROM COLLISION: SUBROUTINE   

;-------------------------------------------------------
;----Convert Number into Printable String---------------
; Step through each digit and display
;-------------------------------------------------------
int_to_string:
    add     esi, 9                      ; 0-9 Bytes    
    mov     byte [esi], 0               ; String terminator
    
    mov     ebx, 10                     ; Move 10 (divide each digit by 10)

.next_digit:
    xor     edx, edx                    ; clear edx register
    div     ebx                         ; eax /= 10
    add     dl, '0'                     ; Convert the remainder to ASCII 
    dec     esi                         ; Store characters in reverse order
    mov     [esi], dl                   ; Move DL register to ESI
    test    eax, eax                    ; Perform a bitwise AND on two operands                   
    jnz     .next_digit                 ; Repeat until eax == 0
    mov     eax, esi                    ; Memory address of first Digit
    ret

;-------------------------------------------------------
;------------------CLEAR SCREEN-------------------------
;-------------------------------------------------------
clear_screen:
    mov     ecx, clear_escape           ; Terminal control string
    mov     edx, len_clear_escape       ; clear_escape message length
    call    sys_write                   ; call sys_write
    ret

;-------------------------------------------------------
;------------------CONTINUE-----------------------------
;-------------------------------------------------------
continue:
    mov     ecx, anykey                 ; move input to anykey  
    mov     edx, 1                      ; size of input
    call    sys_read                    ; call sys_read
    ret                                 ; return

;-------------------------------------------------------
;------------------Flush Line Feed----------------------
;-------------------------------------------------------
flush:
    mov     ecx, flush_buffer           ; message 32 Bit Register
    mov     edx, len_flush_buffer       ; message length see length equ 32 Bit Register
    call    sys_read                    ; call sys_read
    cmp     byte [ecx + edx - 1], 0xA   ; cmp line feed
    jne     flush                       ; loop again
    ret                                 ; return

;-------------------------------------------------------
;------------------Default Terminal---------------------
;-------------------------------------------------------
default_terminal:
    mov     ecx, terminal_default       ; message 32 Bit Register
    mov     edx, len_terminal_default   ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write 
    call    write_endl                  ; write ENDL
    ret                                 ; return  

;-------------------------------------------------------
;---------------------Red Terminal----------------------
;-------------------------------------------------------
red_terminal:
    mov     ecx, terminal_red           ; message 32 Bit Register
    mov     edx, len_terminal_red       ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write 
    call    write_endl                  ; write ENDL
    ret                                 ; return
;-------------------------------------------------------
;--------------------Green Terminal---------------------
;-------------------------------------------------------
green_terminal: 
    mov     ecx, terminal_green         ; message 32 Bit Register
    mov     edx, len_terminal_green     ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write 
    call    write_endl                  ; write ENDL
    ret                                 ; return
;-------------------------------------------------------
;--------------------Blue Terminal----------------------
;-------------------------------------------------------
blue_terminal:
    mov     ecx, terminal_blue          ; message 32 Bit Register
    mov     edx, len_terminal_blue      ; message length see length equ 32 Bit Register
    call    sys_write                   ; call sys_write 
    call    write_endl                  ; write ENDL
    ret                                 ; return 

;-------------------------------------------------------
;---------------------Section BSS-----------------------
;-------------------------------------------------------    
section .bss
    counter resb 1                      ; reserve a byte of memory for counter
    action  resb 1                      ; reserve a byte of memory for action
    anykey  resb 1                      ; reserve a byte of memory for anykey
    score   resb 4                      ; reserve a byte of memory for score
    health  resb 4                      ; reserve a byte of memory for health
    number  resb 4                      ; reserve a byte of memory for buffer atoi
    buffer  resb 4                      ; reserve a byte of memory for buffer atoi
    flush_buffer        resb 1              ; flush buffer
    len_flush_buffer    equ $-flush_buffer  ; flush buffer length   
    row     resb 1                      ; reserve a byte or memory for row
    col     resb 1                      ; reserve a byte or memory for column
                         

;-------------------------------------------------------
;---------------------Section Data----------------------
;-------------------------------------------------------    
section .data

; Clear screen terminal escape sequence
clear_escape        db   27,"[H",27,"[2J"               ; see https://opensource.com/article/19/9/linux-terminal-colors
len_clear_escape    equ  $-clear_escape                 ; clear_escape message length
terminal_default    db   27,"[39m",27,"[49m"            ; Terminal default colors
len_terminal_default  equ  $-terminal_default           ; terminal_default message length
terminal_red        db   27,"[31m"                      ; Red Text
len_terminal_red    equ  $-terminal_red                 ; terminal_red message length

terminal_green      db   27,"[32m", 27,"[47m"           ; Green Text
len_terminal_green  equ  $-terminal_green               ; terminal_green message length
terminal_blue       db   27,"[34m"                      ; Blue Text
len_terminal_blue   equ  $-terminal_blue                ; cleterminal_blue message length

; Welcome Message Splash Screen
welcome_msg         db  '************************************************************'
                    db  $0D,$0A
                    db  'STRATEGY GAMES SUCH AS ZORK, AVALON, OR RABBITS VS PLUMBERS'
                    db  $0D,$0A
                    db  '************************************************************'
                    db  $0D,$0A
len_welcome_msg     equ $-welcome_msg                   ; welcome_msg message length

; Continue Message 
continue_msg        db  'Press any key to continue........'
                    db  $0D,$0A
len_continue_msg     equ $-continue_msg                 ; continue_msg message length

; Game play messages
potion_msg          db  'POTION ....'
                    db  $0D,$0A
                    db  'ENTER POTION : ',0
len_potion_msg      equ $-potion_msg                    ; potion_msg message length

potions_msg         db  'NUMBER OF POTIONS : ',0
len_potions_msg     equ $-potions_msg                   ; potions_msg message length

weapons_msg         db  'EACH QUEST NEED AT LEAST 2 WEAPONS'
                    db  $0D,$0A
                    db  'MINIMUM REQUIREMENT IS 2 '
                    db  'i.e SWORD X 1 AND SPEER X 1.'
                    db  $0D,$0A
                    db  'ENTER # OF WEAPONS : ',0
len_weapons_msg     equ $-weapons_msg                   ; weapons_msg message length

gameplay_msg        db  'ADD GAMEPLAY !'                ; gameplay_msg
len_gameplay_msg    equ $-gameplay_msg                  ; gameplay_msg message length

update_msg          db  'UPDATE GAMEPLAY !'             ; update_msg
len_update_msg      equ $-update_msg                    ; update_msg message length     

draw_msg            db  'DRAW SCREEN !'                 ; draw_msg
len_draw_msg        equ $-draw_msg                      ; draw_msg message length     

hit_msg             db  'STRIKE!'                       ; hit_msg
len_hit_msg         equ $-hit_msg                       ; hit_msg message length     

miss_msg            db  'MISS!'                         ; miss_msg
len_miss_msg        equ $-miss_msg                      ; miss_msg message length     

loop_msg            times 60 db  '.'                             ; loop_msg
len_loop_msg        equ $-loop_msg                      ; loop_msg message length     

replay_msg          db  'ENTER 0 TO QUIT '
                    db  'ANY OTHER NUMBER TO REPLAY : '
len_replay_msg      equ $-replay_msg                    ; replay_msg message length     

score_msg           db  'SCORE : '
len_score_msg       equ $-score_msg                     ; score message length

health_msg          db  'Health : '
len_health_msg      equ $-health_msg                    ; health message length  
 
crlf                db $0D,$0A                          ; carraige return line feed
len_crlf            equ $-crlf                          ; length crlf