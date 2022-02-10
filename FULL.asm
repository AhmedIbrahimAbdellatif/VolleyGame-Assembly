
;AUTHORS:[AHMED IBRAHIM][ANOUD EMAD][AHMED MOHAMMED][MAHMOUD EZZAT]
;[PHASE 1] [MICRO-1 PROJECT]

.MODEL SMALL 
;----------------
.STACK 64
;----------------
.DATA
;----------------
;MAIN MENU VARIABLES
MSG1 DB 'LEVEL 1'
MSG2 DB 'LEVEL 2'
MSG3 DB 'EXIT'
CHOICE DB 1
F1 DB "           %/"
F2 DB "           @@&@.",'$'
F3 DB "            @//@&*@",'$'
F4 DB "          & @///@@/@",'$'
F5 DB "          @@@/*//&//@",'$'
F6 DB "          &///..////@@",'$'
F7 DB "       @(@////.../**/@.",'$'
F8 DB "      %@////.....*../@@",'$'
F9 DB "      @@//.,......../@@",'$'
F10 DB "      ,@//........./(@,",'$'
F11 DB "       #@@//,...,//@@@",'$'
F12 DB "         @@@@@@@@@@@",'$'
F13 DB "             ,,.",'$'
LOOPNUM DB 1
TRANSNUMB DB 0
COUNTDOWN DB '1'
COUNTDOWN_MSG DB 'GO'
;----------------
;THROWBALL VARIABLES
CENTER_X DW ?
CENTER_Y DW ?
INITIAL_X DW 635
INITIAL_Y DW 470
X_COORDINATE DW ?  ;ON SCREEN
Y_COORDINATE DW ?  ;ON SCREEN
CURRENT_X DW ?
CURRENT_Y DW ?
CURRENT_X_SQUARED DW ?
CURRENT_Y_SQUARED DW ?
RADIUS_LENGTH DW 60
RADIUS_SQUARED DW 3600
COMPARISON_VAL DW ?
X_DRAW_BALL DW ?
Y_DRAW_BALL DW ?
PLAYER DW 1
NO_BOUNCE DB 0
CHECKER DW ?
ZIGZAG_COUNTER DB 0
;----------------
;BASKET VARIABLES
basketX1 dw   457
basketX2 dw   163
;----------------
;SCORE VARIBALES
score1 dw 5
score2 dw 5 
;----------------
;SCORE BAR VARIABLES
Name1Mess db 'first player:$'
Name2Mess db 'second player:$'
Player1_name db 30,?,30 dup('$') 
Player2_name db 30,?,30 dup('$') 
;----------------
;FLAGS
ENDGAME DB 0
THROW_FLAG DB 0
P1UP DB 0
P2UP DB 0
WINNER DB 'WINNER IS ','$'
SHOT_TYPE_FLAG DB 1 
;WINNER DB 'PLAYER ',1,' WINS','$'
;----------------
;----------------
FrameX    dw  149
FrameY    dw  199
Color1    db  1
Color2    db  1
;----------------
;----------------
;power ups 
SpeedPlayer1 db 1   ;freeze=0  normal=1  fast=2  
SpeedPlayer2 db 1


PowerUpType dw ?
TimeToPower dw 0
PowerUpX dw ?
PowerUpY dw 15 

PowerUpFall dw 0  
PUFALLCHANGED DB 0
 
RandomPU dw ?
RandomLoc1 dw ?
RandomLoc2 dw ?

PPUTurn dw 2	 
;----------------
CURRENT_TIME DB ?
START_TIME DB ?                
POWERUP_COUNTER DB 0
;----------------
RECEIVED_VALUE DW ?
SEND_VALUE DW ?
SENT_CHAT_REQUEST DW 0
RECEIVED_CHAT_REQUEST DW 0
SENT_GAME_REQUEST DW 0
RECEIVED_GAME_REQUEST DW 0
MY_PLAYER DB 0	
CHAT_REQ_MSG DB 'YOU RECEIVED A CHAT REQUEST!','$'
GAME_REQ_MSG DB 'YOU RECEIVED A GAME REQUEST!','$'
LEVEL DB 0
;-------------------
;CHAT
sentence db 51 DUP ('$')    
count dw 0
upperX db 0
upperY db 0
lowerX db 0
lowerY db 13  
;---------
INSENTENCE db 51 DUP ('$')    
INCOUNT dw 0
INUPPERX db 0
INUPPERY db 24
INLOWERX db 0
INLOWERY db 27
RECEIVED_INCHAT_REQUEST DB 0
SENT_INCHAT_REQUEST DB 0 
;------------------
.CODE
MAIN PROC FAR
     MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX
    
    ;-------------------------------------------------- 
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H ;80 X 30
    INT 10H
    
    MOV AX,0
    MOV BX,0
    MOV CX,0
    MOV DX,0
    
    TO_RESTART:
    
    CALL REINITIALIZE
    CALL INITIALIZE_COM    
    CALL DETERMINE_PLAYER 
    
    CMP MY_PLAYER,2
    JE GO_TO_LEVEL
    
    
    MOV BL,2
    MAIN_MENU: 
    
    MOV AX,0
    MOV BX,0
    MOV CX,0
    MOV DX,0
    CALL MAIN_MENU_PROC
    
    GO_TO_LEVEL:
    CMP LEVEL,1     ;CHECK IF LEVEL 1 WAS CHOOSEN
    JE  LEVEL1
    CMP LEVEL,2     ;CHECK IF LEVEL 2 WAS CHOOSEN
    JE  LEVEL2       ;EXIT 
    MOV DX,0019H       ;SET CURSOR FOR FIREBALL
    JMP EXIT         ;LEVEL 2
    
    JMP AFTER_ASSIST
    
    LEVEL1:
    CALL LEVEL1_PROC 
    JMP TO_RESTART
    
    ASSIST_EXIT:
     
    JMP EXIT
    
    ASSIST_MAIN_MENU: 
    CALL REINITIALIZE 
    JMP MAIN_MENU
    
    
    
    AFTER_ASSIST:
    ;--------------------------------------------------
    ;--------------------------------------------------
    ;--------------------------------------------------
    ;--------------------------------------------------
    ;LEVEL2
    LEVEL2:
    ;--------------------------------------------------
    CALL LEVEL2_PROC 
    JMP TO_RESTART
    ;-----------------------
    ; END OF LEVEL TWO
    ;--------------------------------------------------
    ;--------------------------------------------------
    ;--------------------------------------------------
    ;--------------------------------------------------
    
    
    EXIT:
    MOV AH,0
    MOV AL,12H ;80 X 30
    INT 10H
    MOV BL,2
     
    MOV AH,4CH
    INT 21H
    ;--------------------------------------------------
MAIN ENDP
;---------------------------------------
LEVEL2_PROC PROC
     
    ;--------------------------------------------------
    MOV RADIUS_LENGTH,160
    MOV RADIUS_SQUARED,25600
    MOV CHECKER,113
    MOV INITIAL_Y,274
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H         
    INT 10H
	
    ;--------------------------------------------------
    CALL DRAW_GUI
    ;-----------------------
    CALL GET_TIME
    MOV AL,CURRENT_TIME
    MOV START_TIME,AL  
    
    LEVEL2_LOOP:
    
    CMP SENT_INCHAT_REQUEST,1
    JNE CONT_P1_L2
    CMP RECEIVED_INCHAT_REQUEST,1
    JNE CONT_P1_L2
    CALL INGAME_CHAT
    CONT_P1_L2:
    CALL POWERUPMOVEMENT
    CMP  PLAYER,1
    JNE  P2UP_CHECK_L2
    CMP  P1UP,3
    JE   ZIGZAG_SHOT_L2
    JMP  NORMAL_SHOT_L2
    P2UP_CHECK_L2:
    CMP  P2UP,3
    JE   ZIGZAG_SHOT_L2
    NORMAL_SHOT_L2:
    CMP SHOT_TYPE_FLAG,1
    JNE THROW_HALF_SHOT_L2
    CALL LONG_SHOT            ;NB THROW_BALL CHECKS IF A BALL IS ALREADY THROWN
    
    JMP AFTER_ZIGZAG_L2
    THROW_HALF_SHOT_L2:
    CALL HALF_SHOT
    JMP AFTER_ZIGZAG_L2 
    ZIGZAG_SHOT_L2:
    CALL THROW_ZIGZAG          ;NB THROW_ZIGZAG CHECKS IF A BALL IS ALREADY THROWN
    AFTER_ZIGZAG_L2:
    END_ROUND_COND_L2:
    CMP Y_COORDINATE,275       ;END ROUND CONDITION
    JNE  CHECK_NET_L2
    CALL SCOREUPDATE           ;CALC THE ROUND SCORE
    MOV Y_COORDINATE,274
    JMP  CONTINUE_LOOP1_LEVEL2
    
    ;ASSIST_MAIN_MENU2:
    ;JMP ASSIST_MAIN_MENU
    
    CHECK_NET_L2:
    CMP Y_COORDINATE,234
    JB  CONTINUE_LOOP1_LEVEL2
    CALL SCORE_LEVEL2
   
    CMP ENDGAME,1              ;ENDGAME FLAG
    JE ASSIST3_EXIT_L2
    
    ;-----------------------
    CONTINUE_LOOP1_LEVEL2:  
    
    CMP MY_PLAYER,1
    JNE ASSIST_PLAYER2_ACTIONS_L2
    
    MOV AH,1                   ;CHECK KEY PRESS
    INT 16H 
    JNZ PLAYER1_SENDING_KEYS_L2
    MOV RECEIVED_VALUE,0
    CALL RECEIVE_DATA
    CMP RECEIVED_VALUE,0
    JE ASSIST5_LEVEL2_LOOP
    ;-----------------------
    ;PLAYER 1 
    MOV AX,RECEIVED_VALUE
    CMP AL,'1'
    JNE CONT_REC_CHECK_L2
    MOV RECEIVED_INCHAT_REQUEST,1
    ASSIST5_LEVEL2_LOOP:
    JMP ASSIST4_LEVEL2_LOOP
    CONT_REC_CHECK_L2:
    CMP AL,'A'                 ;IF A
    JE ASSIST2_PLAYER2_LEFT1_L2
    CMP AL,'a'                 ;IF a
    JE ASSIST2_PLAYER2_LEFT1_L2
    CMP AL,'D'                 ;IF D
    JE ASSIST2_PLAYER2_RIGHT1_L2
    CMP AL,'d'                 ;IF d
    JE ASSIST2_PLAYER2_RIGHT1_L2
    CMP THROW_FLAG,1
    JE ASSIST4_LEVEL2_LOOP
    CMP PLAYER,1
    JE ASSIST4_LEVEL2_LOOP
    CMP AL,'W'                 ;IF W
    JE ASSIST2_PLAYER2_LONG_SHOT
    CMP AL,'w'                 ;IF w
    JE ASSIST2_PLAYER2_LONG_SHOT
    CMP AL,20H                 ;IF SPACE
    JE ASSIST2_PLAYER2_HALF_SHOT
    CMP AL,1BH               ;ESC
    JE  ASSIST3_EXIT_L2
    JMP ASSIST4_LEVEL2_LOOP
    ASSIST_PLAYER2_ACTIONS_L2:
    JMP PLAYER2_ACTIONS_L2
    ;-----------------
    
    ASSIST2_PLAYER2_HALF_SHOT:
    JMP ASSIST_PLAYER2_HALF_SHOT
    ASSIST2_PLAYER2_RIGHT1_L2:
    JMP PLAYER2_RIGHT1_L2
    ASSIST3_EXIT_L2:
    JMP ASSIST2_EXIT_L2 
    
    
    PLAYER1_SENDING_KEYS_L2:
    MOV SEND_VALUE,0
    MOV AH,0
    INT 16H
    MOV SEND_VALUE,AX
    CMP AL,1BH
    JE ASSIST2_EXIT_L2           
    CMP AL,'1'
    JNE S0_L2
    MOV SENT_INCHAT_REQUEST,1
    CALL SEND_DATA
    JMP ASSIST4_LEVEL2_LOOP
    S0_L2:
    CMP AL,'A'                 ;IF A 
    JNE S1_L2
    CALL SEND_DATA        
    JMP KEY_ACTION1_L2
    ASSIST2_PLAYER2_LEFT1_L2:
    JMP PLAYER2_LEFT1_L2
    S1_L2:
    CMP AL,'a'                 ;IF a  
    JNE S2_L2
    CALL SEND_DATA                
    JMP KEY_ACTION1_L2
    ASSIST2_PLAYER2_LONG_SHOT:
    JMP ASSIST_PLAYER2_LONG_SHOT 
    ASSIST4_LEVEL2_LOOP:
    JMP LEVEL2_LOOP
    S2_L2:
    CMP AL,'D'                 ;IF D   
    JNE S3_L2
    CALL SEND_DATA               
    JMP KEY_ACTION1_L2
    S3_L2:
    CMP AL,'d'                 ;IF d 
    JNE S4_L2
    CALL SEND_DATA             
    JMP KEY_ACTION1_L2
    S4_L2:
    CMP PLAYER,2
    JE ASSIST4_LEVEL2_LOOP
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN DON'T THROW ANOTHER ONE
    JE ASSIST4_LEVEL2_LOOP
    CMP AL,20H                 ;IF SPACE
    JNE S5_L2
    MOV AH,0
    MOV SEND_VALUE,AX
    CALL SEND_DATA
    MOV THROW_FLAG,1
    JMP KEY_ACTION1_L2 
    
    S5_L2:
    CMP AL,'W'                 ;IF W
    JNE S6_L2
    CALL SEND_DATA
    MOV THROW_FLAG,1
    JMP KEY_ACTION1_L2
    ASSIST2_EXIT_L2:
    JMP ASSIST_EXIT_L2
    S6_L2:
    CMP AL,'w'                 ;IF w
    JNE ASSIST4_LEVEL2_LOOP
    CALL SEND_DATA
    MOV THROW_FLAG,1
                    
    KEY_ACTION1_L2: 
    CMP AL,20H
    JE  ASSIST2_PLAYER1_HALF_SHOT 
    CMP AL,'A'                 ;IF A 
    JE  ASSIST2_PLAYER1_LEFT1_L2
    CMP AL,'a'                 ;IF a  
    JE  ASSIST2_PLAYER1_LEFT1_L2
    CMP AL,'D'                 ;IF D   
    JE  ASSIST2_PLAYER1_RIGHT1_L2
    CMP AL,'d'                 ;IF d 
    JE  ASSIST2_PLAYER1_RIGHT1_L2
    CMP AL,'W'                 ;IF W
    JE  ASSIST2_PLAYER1_LONG_SHOT
    CMP AL,'w'                 ;IF w
    JE  ASSIST2_PLAYER1_LONG_SHOT
    
    ;------------------------ 
    ;PLAYER2
    
    PLAYER2_ACTIONS_L2:
    MOV SEND_VALUE,0
    MOV AH,1                   ;CHECK KEY PRESS
    INT 16H 
    JNZ PLAYER2_SENDING_KEYS_L2
    MOV RECEIVED_VALUE,0
    CALL RECEIVE_DATA
    CMP RECEIVED_VALUE,0
    JE ASSIST6_LEVEL2_LOOP
    
    
    ;PLAYER 2     
    MOV AX,RECEIVED_VALUE
    CMP AL,'1'
    JNE CONT2_REC_CHECK_L2
    MOV RECEIVED_INCHAT_REQUEST,1
    JMP ASSIST3_LEVEL2_LOOP  
    
    ASSIST2_PLAYER1_HALF_SHOT:
    JMP ASSIST_PLAYER1_HALF_SHOT 
    ASSIST2_PLAYER1_LONG_SHOT:
    JMP ASSIST_PLAYER1_LONG_SHOT
    ASSIST2_PLAYER1_LEFT1_L2:
    JMP ASSIST_PLAYER1_LEFT1_L2
    ASSIST2_PLAYER1_RIGHT1_L2:
    JMP ASSIST_PLAYER1_RIGHT1_L2 
    ASSIST6_LEVEL2_LOOP:
    JMP LEVEL2_LOOP
    
    CONT2_REC_CHECK_L2:  
    CMP AL,1
    JE ASSIST_PLAYER2_SET_PUFALL
    CMP AL,'A'                 ;IF A
    JE ASSIST_PLAYER1_LEFT1_L2
    CMP AL,'a'                 ;IF a
    JE ASSIST_PLAYER1_LEFT1_L2
    CMP AL,'D'                 ;IF D
    JE ASSIST_PLAYER1_RIGHT1_L2
    CMP AL,'d'                 ;IF d
    JE ASSIST_PLAYER1_RIGHT1_L2
    CMP THROW_FLAG,1
    JE ASSIST3_LEVEL2_LOOP
    CMP PLAYER,2
    JE ASSIST3_LEVEL2_LOOP 
    CMP AL,20H
    JE ASSIST_PLAYER1_HALF_SHOT
    CMP AL,'W'                 ;IF W
    JE ASSIST_PLAYER1_LONG_SHOT
    CMP AL,'w'                 ;IF w
    JE ASSIST_PLAYER1_LONG_SHOT
    CMP AL,1BH               ;ESC
    JE  ASSIST_EXIT_L2

    
    
    
    PLAYER2_SENDING_KEYS_L2: 
    MOV SEND_VALUE,0
    MOV AH,0
    INT 16H
    MOV SEND_VALUE,AX
    CMP AX,011BH
    JE ASSIST_EXIT_L2
    CMP AL,'1'
    JNE S01_L2
    MOV SENT_INCHAT_REQUEST,1
    CALL SEND_DATA
    JMP ASSIST3_LEVEL2_LOOP
    S01_L2: 
    CMP AL,'A'                 ;IF A 
    JNE S7_L2
    CALL SEND_DATA        
    JMP KEY_ACTION2_L2
    ;-------------------------  
    
    ASSIST_PLAYER2_SET_PUFALL:
    JMP PLAYER2_SET_PUFALL
    ASSIST_PLAYER1_LEFT1_L2:
    JMP PLAYER1_LEFT1_L2
    ASSIST_PLAYER1_RIGHT1_L2:
    JMP PLAYER1_RIGHT1_L2
    ASSIST3_LEVEL2_LOOP:
    JMP ASSIST2_LEVEL2_LOOP
    ASSIST_EXIT_L2:
    JMP EXIT_L2 
    ASSIST_PLAYER1_LONG_SHOT:
    JMP PLAYER1_LONG_SHOT
    ASSIST_PLAYER1_HALF_SHOT:
    JMP PLAYER1_HALF_SHOT
    ASSIST_PLAYER2_LONG_SHOT:
    JMP PLAYER2_LONG_SHOT
    ;-------------------------
    S7_L2:
    CMP AL,'a'                 ;IF a  
    JNE S8_L2
    CALL SEND_DATA                
    JMP KEY_ACTION2_L2
    S8_L2:
    CMP AL,'D'                 ;IF D   
    JNE S9_L2
    CALL SEND_DATA               
    JMP KEY_ACTION2_L2
    S9_L2:
    CMP AL,'d'                 ;IF d 
    JNE S10_L2
    CALL SEND_DATA             
    JMP KEY_ACTION2_L2
    S10_L2:
    CMP PLAYER,1
    JE ASSIST3_LEVEL2_LOOP
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN DON'T THROW ANOTHER ONE
    JE ASSIST3_LEVEL2_LOOP  
    CMP AL,20H                 ;IF SPACE
    JNE S11_L2
    MOV AH,0
    MOV SEND_VALUE,AX
    CALL SEND_DATA
    MOV THROW_FLAG,1
    JMP KEY_ACTION2_L2
    S11_L2: 
    CMP AL,'W'                 ;IF W
    JNE S12_L2
    CALL SEND_DATA
    MOV THROW_FLAG,1
    JMP KEY_ACTION2_L2
    S12_L2:
    CMP AL,'w'                 ;IF w
    JNE ASSIST3_LEVEL2_LOOP
    CALL SEND_DATA
    MOV THROW_FLAG,1
                    
    KEY_ACTION2_L2:  
    CMP AL,'A'                 ;IF A 
    JE  PLAYER2_LEFT1_L2
    CMP AL,'a'                 ;IF a  
    JE  PLAYER2_LEFT1_L2
    CMP AL,'D'                 ;IF D   
    JE  PLAYER2_RIGHT1_L2
    CMP AL,'d'                 ;IF d 
    JE  PLAYER2_RIGHT1_L2
    CMP AL,'W'                 ;IF W
    JE  PLAYER2_LONG_SHOT
    CMP AL,'w'                 ;IF w
    JE  PLAYER2_LONG_SHOT
    CMP AL,20H                 ;IF SPACE
    JE  ASSIST_PLAYER2_HALF_SHOT      
    
    ;----------------------- 
    ASSIST_LEVEL2_LOOP:
    JMP LEVEL2_LOOP     
    
    ;------------------------
     
    ;------------------------
    PLAYER2_SET_PUFALL:
    MOV PUFALLCHANGED,1
    MOV POWERUPFALL,1
    JMP ASSIST_LEVEL2_LOOP
    PLAYER1_RIGHT1_L2:
    CALL MOVEBASKET1RIGHT      ;MOVE PLAYER 1 RIGHT
    JMP ASSIST_LEVEL2_LOOP
    PLAYER1_LEFT1_L2:
    CALL MOVEBASKET1LEFT       ;MOVE PLAYER 1 LEFT
    JMP ASSIST_LEVEL2_LOOP
    PLAYER2_LEFT1_L2:
    CALL MOVEBASKET2LEFT       ;MOVE PLAYER 2 LEFT
    JMP ASSIST_LEVEL2_LOOP
    PLAYER2_RIGHT1_L2:
    CALL MOVEBASKET2RIGHT      ;MOVE PLAYRE 2 RIGHT
    JMP ASSIST_LEVEL2_LOOP 
    ASSIST_PLAYER2_HALF_SHOT:
    JMP PLAYER2_HALF_SHOT
    ;------------------------
    
    PLAYER1_LONG_SHOT:
    CMP PLAYER,1               ;THROW BALL PLAYER 1
    JNE ASSIST_LEVEL2_LOOP
    MOV AX,BASKETX1            ;INITIALIZE BALL X COORDINATE
    ADD AX,20
    MOV INITIAL_X,AX
    CALL LONG_SHOT_INIT
    MOV THROW_FLAG,1           ;SET THE THROW FLAG
    MOV SHOT_TYPE_FLAG,1
    MOV ZIGZAG_COUNTER,0       ;RESET THE ZIGZAG COUNTER
    JMP ASSIST_LEVEL2_LOOP            ;RETURN BACK TO THE LEVEL LOOP
    ;------------------------
    PLAYER2_LONG_SHOT:             
    ;SAME AS PLAYER1_THROW WITH A CHANGE IN THE MAPPING PROCESS
    CMP PLAYER,2
    JNE ASSIST_LEVEL2_LOOP
    MOV AX,BASKETX2
    ADD AX,20
    MOV INITIAL_X,AX
    CALL LONG_SHOT_INIT
    MOV THROW_FLAG,1
    MOV SHOT_TYPE_FLAG,1
    MOV ZIGZAG_COUNTER,0
    JMP ASSIST_LEVEL2_LOOP
    ;------------------------
    PLAYER1_HALF_SHOT:
    CMP PLAYER,1               ;THROW BALL PLAYER 1
    JNE ASSIST_LEVEL2_LOOP
    MOV AX,BASKETX1            ;INITIALIZE BALL X COORDINATE
    ADD AX,20
    MOV INITIAL_X,AX
    CALL HALF_SHOT_INIT
    MOV THROW_FLAG,1           ;SET THE THROW FLAG
    MOV SHOT_TYPE_FLAG,2
    MOV ZIGZAG_COUNTER,0       ;RESET THE ZIGZAG COUNTER
    ASSIST2_LEVEL2_LOOP:
    JMP ASSIST_LEVEL2_LOOP            ;RETURN BACK TO THE LEVEL LOOP
    ;-----------------------
    PLAYER2_HALF_SHOT:             
    ;SAME AS PLAYER1_THROW WITH A CHANGE IN THE MAPPING PROCESS
    CMP PLAYER,2
    JNE ASSIST2_LEVEL2_LOOP
    MOV AX,BASKETX2
    ADD AX,20
    MOV INITIAL_X,AX
    CALL HALF_SHOT_INIT
    MOV THROW_FLAG,1
    MOV SHOT_TYPE_FLAG,2
    MOV ZIGZAG_COUNTER,0
    JMP ASSIST_LEVEL2_LOOP
    ;-----------------------
    ; END OF LEVEL TWO
    
    EXIT_L2:
    MOV SEND_VALUE,1BH
    CALL SEND_DATA
    MOV SEND_VALUE,0
    MOV AH,0
    MOV AL,12H
    INT 10H  
     
    RET
LEVEL2_PROC ENDP
;------------------------------------------
INGAME_CHAT proc 
 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI   

MOV INCOUNT,0
MOV INUPPERX,0
MOV INUPPERY,24
MOV INLOWERX,0
MOV INLOWERY,27

mov bl,0    
mov ah,6       ; function 6
mov al,00        ; scroll by 1 line    
mov bh,0Fh       ; normal video attribute       
mov ch,24       ; upper left Y
mov cl,0        ; upper left X
mov dh,26     ; lower right Y
mov dl,79      ; lower right X 
int 10h

mov bh,01h       ; normal video attribute       
mov ch,27       ; upper left Y
mov cl,0        ; upper left X
mov dh,29     ; lower right Y
mov dl,79      ; lower right X 
int 10h


INCHATLOOP:

;check received
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	 	in al , dx 
  		test al , 1
  		JZ INCHK                                    ;Not Ready
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx

		cmp al,27          ;check if esc
        je ASSIST_INENDCHAT 
        cmp al,13          ;check if enter
        je INRECEIVEDENTER
 
  		mov ah,02	;set cursor
		mov bh,00
		mov dl,INLOWERX
		mov dh,INLOWERY
		int 10h


        mov ah,09   ;lower display
        mov bh,00
        mov bl,0FFh
        mov cx,1
        Int 10h
		
		inc INLOWERX
		jmp INCHK		
        
        INRECEIVEDENTER:
        
		cmp INLOWERY,29
		jne INNORMALINC2
		mov INLOWERX,0
        
        mov bl,0
		mov ah,6       ; function 6     
		mov al,01
		mov bh,01h       ; normal video attribute       
        mov ch,27       ; upper left Y
        mov cl,0        ; upper left X
        mov dh,29     ; lower right Y
        mov dl,79      ; lower right X 
        int 10h                       
        
		jmp INDONE2
		INNORMALINC2:
		mov INLOWERX,0
		inc INLOWERY
		INDONE2:

        jmp INCHK 
        
        ASSIST_INESCPRESSED:
        jmp INESCPRESSED
 		ASSIST_INENDCHAT:
        jmp INENDCHAT 
        ASSIST_INCHATLOOP:
        jmp INCHATLOOP 
        
		INCHK:
;---

mov ah,01h
int 16h
jz ASSIST_INCHATLOOP 

mov ah,00h	;get key pressed
int 16h

cmp al,27         ;check if esc
je ASSIST_INESCPRESSED
cmp ax,1C0Dh      ;check if enter
je INSENDING 
cmp ax,0E08h      ;check if backspace
jne INNORMALCHAR  
cmp INCOUNT,0       ;if no chars return
je ASSIST_INCHATLOOP  
dec INCOUNT 
mov si,INCOUNT
mov INSENTENCE[si],'$' 
;------- 
dec INUPPERX
mov ah,02	;set cursor
mov bh,00
mov dl,INUPPERX
mov dh,INUPPERY
int 10h

mov al,0DBh
mov ah,09   ;backspace lower display
mov bh,00
mov bl,0Fh
mov cx,1
Int 10h  

;-------
jmp ASSIST_INCHATLOOP
INNORMALCHAR:
mov si,INCOUNT
mov INSENTENCE[si],al 
;----
mov ah,02	;set cursor
mov bh,00
mov dl,INUPPERX
mov dh,INUPPERY
int 10h

mov ah,09   ;lower display
mov bh,00
mov bl,0FFh
mov cx,1
Int 10h

inc INUPPERX
;----
inc INCOUNT
cmp  INCOUNT,50     ;if reached 50 send by itself
jne ASSIST_INCHATLOOP

INSENDING: 
mov si,INCOUNT
mov INSENTENCE[si],13

cmp INUPPERY,26
jne INNORMALINC1
mov INUPPERX,0   

mov bl,0
mov ah,6
mov al,01
mov bh,0Fh       ; normal video attribute       
mov ch,24       ; upper left Y
mov cl,0        ; upper left X
mov dh,26     ; lower right Y
mov dl,79      ; lower right X 
int 10h

jmp INDONE1
INNORMALINC1:
mov INUPPERX,0
inc INUPPERY
INDONE1:
 
        
;send
;Check that Transmitter Holding Register is Empty 

        lea si,INSENTENCE
        add INCOUNT,1 
        jmp INSENDINGLOOP
        
INESCPRESSED: mov INSENTENCE[0],al 
            lea si,INSENTENCE
            
INSENDINGLOOP:        
		mov dx , 3FDH			; Line Status Register
INAGAIN:In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ INAGAIN                        ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H			; Transmit data register
  		mov  al, [si]
  		mov byte ptr [si],'$'
  		out dx , al
        cmp al,27
		je INENDCHAT
		inc si
		sub INCOUNT,1
		jnz INSENDINGLOOP
		jmp ASSIST_INCHATLOOP
		INENDCHAT:
		mov INCOUNT,0 
	
	CALL DRAW_GUI
	MOV SENT_INCHAT_REQUEST,0
	MOV RECEIVED_INCHAT_REQUEST,0	
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
		
ret
INGAME_CHAT endp

DETERMINE_PLAYER PROC
    
    CHECK_ACTION:
    CMP SENT_CHAT_REQUEST,1            ;check if both sent chat request
    JNE CHECK_GAME_REQ
    CMP RECEIVED_CHAT_REQUEST,1
    JNE CHECK_GAME_REQ
    MOV AH,0
    MOV AL,3H
    INT 10H
    CALL CHAT
    MOV AH,0
    MOV AL,12H
    INT 10H
    
    CHECK_GAME_REQ:                    ;check if both sent game request
    CMP SENT_GAME_REQUEST,1
    JNE CHECK_COM
    CMP RECEIVED_GAME_REQUEST,1
    JNE CHECK_COM
    JMP FINISH_DP
    
    
    CHECK_COM:
    MOV SEND_VALUE,0
    CALL RECEIVE_DATA 
    CMP RECEIVED_VALUE,31H             ;if received 1 set received_chat_request flag
    JNE MENU_OPTION2
    MOV RECEIVED_CHAT_REQUEST,1
    MOV RECEIVED_GAME_REQUEST,0
    MOV AH,2
    MOV BX,0
    MOV DH,14
    MOV DL,25
    INT 10H
    LEA DX,CHAT_REQ_MSG
    MOV AH,9
    INT 21H
    MENU_OPTION2:
    CMP RECEIVED_VALUE,32H             ;if received 2 set received_game_request flag
    JNE CHECK_SEND
    MOV RECEIVED_GAME_REQUEST,1
    MOV RECEIVED_CHAT_REQUEST,0
    MOV AH,2 
    MOV BX,0
    MOV DH,14
    MOV DL,25
    INT 10H
    LEA DX,GAME_REQ_MSG
    MOV AH,9
    INT 21H
    
    JMP CHECK_SEND
    ASSIST_CHECK_ACTION:
    JMP CHECK_ACTION
    
    CHECK_SEND:
    MOV RECEIVED_VALUE,0
    MOV AH,1
    INT 16H
    JZ ASSIST_CHECK_ACTION
    MOV AH,0
    INT 16H
    MOV AH,0
    MOV SEND_VALUE,AX
    CMP SEND_VALUE,31H
    JNE MENU_OPTION3
    MOV SENT_CHAT_REQUEST,1
    MOV SENT_GAME_REQUEST,0
    CALL SEND_DATA                      ;sending chat request
    MENU_OPTION3:                       
    CMP SEND_VALUE,32H
    JNE ASSIST_CHECK_ACTION
    MOV SENT_GAME_REQUEST,1
    MOV SENT_CHAT_REQUEST,0
    CALL SEND_DATA                      ;sending game request
    CMP RECEIVED_GAME_REQUEST,1
    JE MY_PLAYER_2
    MOV MY_PLAYER,1
    JMP CHECK_ACTION
    MY_PLAYER_2:
    MOV MY_PLAYER,2
    JMP CHECK_ACTION
    
    FINISH_DP:
    
    MOV RECEIVED_VALUE,0
    CMP MY_PLAYER,2       ;CHECK PLAYER 2 OR 1
    JNE ASSIST_ALLOW  
    
    STATIC_SCREEN1:                     ;frezing player
    CALL RECEIVE_DATA
    CMP RECEIVED_VALUE,0
    JE STATIC_SCREEN1 
    MOV AL,BYTE PTR RECEIVED_VALUE
    MOV RECEIVED_VALUE,0 
    MOV LEVEL,AL
    CMP AL,3
    JE ASSIST_ALLOW 
    ;--------------------
    
    JMP STATIC_SCREEN4
    ASSIST_ALLOW:
    JMP ALLOW
    
    ;--------------------
    ;RECEIVE player1 name
    STATIC_SCREEN4:                      ;frezing player
    CALL RECEIVE_DATA 
    CMP RECEIVED_VALUE,0 
    JE STATIC_SCREEN4  
    MOV CH,0
    MOV CL,BYTE PTR RECEIVED_VALUE
    MOV PLAYER1_NAME[1],CL
    MOV RECEIVED_VALUE,0
    
    LEA SI,PLAYER1_NAME[2]
    RECEIVING_PLAYER1NAME:
    CALL RECEIVE_DATA
    CMP RECEIVED_VALUE,0
    JE RECEIVING_PLAYER1NAME 
    MOV AL,BYTE PTR RECEIVED_VALUE
    MOV [SI],AL
    MOV RECEIVED_VALUE,0
    INC SI
    LOOP RECEIVING_PLAYER1NAME 
    
    CALL PLAYERNAMES
    
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H
    INT 10H 
    
    STATIC_SCREEN:                       ;frezing player
    CALL RECEIVE_DATA 
    CMP RECEIVED_VALUE,0 
    JE STATIC_SCREEN 
    MOV AL,BYTE PTR RECEIVED_VALUE
    MOV COLOR1,AL
    MOV RECEIVED_VALUE,0 
    
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H
    INT 10H 
    call ChooseBasket2Color    ;CHOOSING BASKET2 COLOR
	MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H
    INT 10H
    
    MOV AL,COLOR2
    MOV BYTE PTR SEND_VALUE,AL
    CALL SEND_DATA
    
    ALLOW:
    MOV SENT_GAME_REQUEST,0
    MOV SENT_CHAT_REQUEST,0
    MOV RECEIVED_GAME_REQUEST,0
    MOV RECEIVED_CHAT_REQUEST,0
    MOV SEND_VALUE,0
    MOV RECEIVED_VALUE,0 
    MOV AH,0
    MOV AL,12H
    INT 10H
    RET
DETERMINE_PLAYER ENDP    

RECEIVE_DATA PROC  
    PUSH AX
    PUSH BX
    PUSH DX 
       MOV BX,0
    ;Check that Data is Ready
	mov dx , 3FDH		; Line Status Register
	in aX , dx 
  	test aX , 1
  	JZ CHK1                                    ;Not Ready
 ;If Ready read the VALUE in Receive data register
  	mov dx , 03F8H
  	in aX , dx 
  	mov RECEIVED_VALUE , aX
    CHK1:  
    
    POP DX
    POP BX      
    POP AX
    RET
RECEIVE_DATA ENDP

SEND_DATA PROC           
    ;Check that Transmitter Holding Register is Empty 
    PUSH BX
    PUSH AX
    PUSH DX 
        MOV BX,0
		mov dx , 3FDH		; Line Status Register
AGAIN1:  In aX , dx 			;Read Line Status
  		test aX , 00100000b
  		JZ AGAIN1                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  aX,SEND_VALUE
  		out dx , aX  
  		
    POP DX
    POP AX
    POP BX

    RET 
SEND_DATA ENDP    
;---------------------------------------
;CHAT PROCEDURES:
initialize_com proc
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX

;Set Divisor Latch Access Bit
mov dx,3fbh 			; Line Control Register
mov al,10000000b		;Set Divisor Latch Access Bit
out dx,al				;Out it
;Set LSB byte of the Baud Rate Divisor Latch register.
mov dx,3f8h			
mov al,0ch			
out dx,al	
;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
out dx,al
;Set port configuration
mov dx,3fbh
mov al,00011011b
;0:Access to Receiver buffer, Transmitter buffer
;0:Set Break disabled
;011:Even Parity
;0:One Stop Bit
;11:8bits
out dx,al 
    
    MOV RECEIVED_VALUE,0
    MOV SEND_VALUE,0
    MOV SENT_CHAT_REQUEST,0
    MOV RECEIVED_CHAT_REQUEST,0
    MOV SENT_GAME_REQUEST,0
    MOV RECEIVED_GAME_REQUEST,0
    MOV MY_PLAYER,0	
    MOV LEVEL,0
    
    POP DX
    POP CX
    POP BX
    POP AX

ret
initialize_com endp

;---------------------------------------

chat proc 
     
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH SI
    
MOV count,0
MOV upperX,0
MOV upperY,0
MOV lowerX,0
MOV lowerY,13
MOV SENT_CHAT_REQUEST,0
MOV RECEIVED_CHAT_REQUEST,0
MOV SENT_GAME_REQUEST,0
MOV RECEIVED_GAME_REQUEST,0

MOV AH,2
MOV DX,0
INT 10H
     
mov ah,6       ; function 6
mov al,00        ; scroll by 1 line    
mov bh,0Fh       ; normal video attribute       
mov ch,0       ; upper left Y
mov cl,0        ; upper left X
mov dh,12     ; lower right Y
mov dl,79      ; lower right X 
int 10h

mov bh,1Fh       ; normal video attribute       
mov ch,13       ; upper left Y
mov cl,0        ; upper left X
mov dh,24     ; lower right Y
mov dl,79      ; lower right X 
int 10h


chatloop:

;check received
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	 	in al , dx 
  		test al , 1
  		JZ CHK                                    ;Not Ready
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx

		cmp al,27          ;check if esc
        je assist_endchat 
        cmp al,13          ;check if enter
        je receivedenter
 
  		mov ah,02	;set cursor
		mov bh,00
		mov dl,lowerX
		mov dh,lowerY
		int 10h

        
		mov ah,09   ;display
		mov bh,00
		mov bl,1Fh
		mov cx,1
		Int 10h
		
		inc lowerX
		jmp CHK		
        
        receivedenter:
        
		cmp lowerY,24
		jne normalinc2
		mov lowerX,0

		mov ah,6       ; function 6
		mov al,01        ; scroll by 1 line    
		mov bh,1Fh       ; normal video attribute       
		mov ch,13       ; upper left Y
		mov cl,0        ; upper left X
		mov dh,24     ; lower right Y
		mov dl,79      ; lower right X 
		int 10h

		jmp done2
		normalinc2:
		mov lowerX,0
		inc lowerY
		done2:

        jmp CHK 
        
        assist_escpressed:
        jmp escpressed
 		assist_endchat:
        jmp endchat 
        assist_chatloop:
        jmp chatloop 
        
		CHK:
;---

mov ah,01h
int 16h
jz assist_chatloop 

mov ah,00h	;get key pressed
int 16h

cmp al,27         ;check if esc
je assist_escpressed
cmp ax,1C0Dh      ;check if enter
je sending 
cmp ax,0E08h      ;check if backspace
jne normalchar  
cmp count,0       ;if no chars return
je assist_chatloop  
dec count 
mov si,count
mov sentence[si],'$' 
;------- 
dec upperX
mov ah,02	;set cursor
mov bh,00
mov dl,upperX
mov dh,upperY
int 10h

mov al,30h
mov ah,09     ;display
mov bh,00
mov bl,00h
mov cx,1
Int 10h  

;-------
jmp assist_chatloop
normalchar:
mov si,count
mov sentence[si],al 
;----
mov ah,02	;set cursor
mov bh,00
mov dl,upperX
mov dh,upperY
int 10h

mov ah,09     ;display
mov bh,00
mov bl,0Fh
mov cx,1
Int 10h

inc upperX
;----
inc count
cmp  count,50     ;if reached 50 send by itself
jne assist_chatloop

sending: 
mov si,count
mov sentence[si],13

cmp upperY,12
jne normalinc1
mov upperX,0

mov ah,6       ; function 6
mov al,01        ; scroll by 1 line    
mov bh,0Fh       ; normal video attribute       
mov ch,0       ; upper left Y
mov cl,0        ; upper left X
mov dh,12     ; lower right Y
mov dl,79      ; lower right X 
int 10h

jmp done1
normalinc1:
mov upperX,0
inc upperY
done1:
 
        
;send
;Check that Transmitter Holding Register is Empty 

        lea si,sentence
        add count,1 
        jmp sendingloop
        
escpressed: mov sentence[0],al 
            lea si,sentence
            
sendingloop:        
		mov dx , 3FDH			; Line Status Register
AGAIN:  In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAIN                        ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H			; Transmit data register
  		mov  al, [si]
  		mov byte ptr [si],'$'
  		out dx , al
        cmp al,27
		je endchat
		inc si
		sub count,1
		jnz sendingloop
		jmp assist_chatloop
		endchat:
		mov count,0
		
		MOV AH,0
        MOV AL,12H
        INT 10H 
               
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
ret
chat endp

;---------------------------------------
MAIN_MENU_PROC PROC
    
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
    
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H ;80 X 30
    INT 10H
    
    MOV CHECKER,42
    ;--------------------------------------------------
    CALL CHOOSE        ;DISPLAY LEVELS AND EXIT CHOICES
    ;--------------------------------------------------
    MOV BL,4
    MOV DX,0019H
    CALL DRAW_FIREBALL              
    ;-------------------------------------------------- 
    MOV X_DRAW_BALL,635;INITIALIZING THE BOUNCING BALL
    MOV Y_DRAW_BALL,470
    ;--------------------------------------------------
    
    
    CHECK: 
    ;-------------------------------------------------- 
    
    PUSH DX            ;BOUNCE THE BALL IN A ZIGZAG MOTION
    CALL DELETEBALL
    POP DX
    CALL ZIGZAG
    PUSH DX
    CALL DRAWBALL
    POP DX                 
    ;--------------------------------------------------
    CONTINUE_LOOP:
    CMP [LOOPNUM],1    ;CHANGING COLORS OF THE FIREBALL WITH EVERY ITERATION
    JNZ LOPTION2       
    MOV BL,4           ;COLOR ATTRIBUTE
    INC LOOPNUM
    JMP FIREBALL
    LOPTION2:
    CMP [LOOPNUM],2
    JNZ LOPTION3
    MOV BL,0EH         ;COLOR ATTRIBUTE
    INC LOOPNUM
    JMP FIREBALL
    LOPTION3:
    MOV BL,5           ;COLOR ATTRIBUTE
    MOV [LOOPNUM],1    ;RETURN BACK TO OPTION 1
    ;--------------------------------------------------
    FIREBALL:          ;DRAW FIREBALL
    PUSH CX            ;PUSH REGITSERS TO SAVE THEIR VALUES
    PUSH DX
    PUSH AX
    MOV CX,07H         ;DELAY
    MOV DX,0A120H
    MOV AX,8600H
    INT 15H
    MOV DX,0019H       ;SET CURSOR FOR FIRE BALL
    CALL DRAW_FIREBALL ;CALL THE DRAWING PROC
    POP AX
    POP DX
    POP CX
    ;--------------------------------------------------
    MOV AH,1           ;GETTING KEY PRESS
    INT 16H
    JZ CHECK           ;IF NO KEY RETURN BACK TO DRAWING FIRE BALL WITH ANOTHER COLOR
    MOV AH,0
    INT 16H  
    
    ;--------------------------------------------------
    CMP AX,5000H       ;IF THE PRESSED KEY IS THE DOWN ARROW
    JNZ OPTION2        ;OPTION1 DOWN
    INC [CHOICE]       ;INCREMENT THE CHOICE VARIABLE
    JMP MOVING
    OPTION2:           ;IF NOT DOWN CHECK IF IT WAS UP ARROW
    CMP AX,4800H       ;OPTION2 UP
    JNZ OPTION3
    DEC [CHOICE]       ;DECREMENT THE CHOICE VARIABLE
    JMP MOVING
    OPTION3:           ;IF NOT UP CHECK IF IT WAS ENTER
    CMP AX,1C0DH
    JNZ CHECK
    ;--------------------------------------------------
       
    MOV DX,0019H       ;SET CURSOR FOR FIREBALL
    JMP TRANSITION     ;LEVEL 1
    
    ;--------------------------------------------------
    MOVING:            ;MOVING BETWEEN LEVELS AND EXIT
    CMP [CHOICE],0     
    JNZ OPTION4
    ADD [CHOICE],3     ;ADJUSTING THE CHOICE VARIABLE
    JMP PRINT
    OPTION4:
    CMP [CHOICE],4
    JNZ PRINT
    SUB [CHOICE],3     ;ADJUSTING THE CHOICE VARIABLE
    ;--------------------------------------------------
    PRINT:             ;PRINTING THE CHOICES WITH THE CHOICE IN GREEN
    CALL CHOOSE
    JMP CHECK          ;RETURN BACK TO THE BEGINING OF LOOP
    ;--------------------------------------------------
    
    TRANSITION:        ;TRANSISTION1 BETWEEN MENU AND START OF LEVEL
    CMP CHOICE,3
    JE ASSIST_OUT_MENU
    INC TRANSNUMB
    ;----------------
    PUSH DX
    CALL DELETEBALL
    POP DX
    ;----------------
    MOV BL,0
    PUSH DX
    CALL DRAW_FIREBALL
    POP DX
    ;----------------
    INC DH             ;MOVING THE FIREBALL DOWN
    PUSH DX
    MOV BL,4
    CALL DRAW_FIREBALL
    POP DX
    ;----------------
    PUSH CX
    PUSH DX
    PUSH AX
    MOV CX,07H         ;DELAY
    MOV DX,0A120H
    MOV AX,8600H
    INT 15H
    POP AX
    POP DX
    POP CX
    ;----------------
    CMP TRANSNUMB,7
    JNZ TRANSITION 
    ;--------------------------------------------------
    JMP TRANSITION2
     
    ASSIST_OUT_MENU:
    MOV AL,CHOICE
    MOV LEVEL,AL
    MOV SEND_VALUE,AX
    CALL SEND_DATA
    JMP OUT_MENU
    ;--------------------------------------------------
    TRANSITION2:      ;TRANSITION2 
    MOV BL,0
    
    CALL TRANSN       ;COUNTDOWN
    CMP COUNTDOWN,'4' ;FROM 1 TO 3
    JNE TRANSITION2
    
    CALL TRANSN_CONTINUED
    
    ;--------------------------------- 
    MOV AL,CHOICE
    MOV LEVEL,AL
    MOV BYTE PTR SEND_VALUE,AL
    CALL SEND_DATA 
    
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H
    INT 10H
    CALL PlayerNames   
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H
    INT 10H
    
    ;get player2 name
    STATIC_SCREEN3:
    CALL RECEIVE_DATA 
    CMP RECEIVED_VALUE,0 
    JE STATIC_SCREEN3  
    MOV CH,0
    MOV CL,BYTE PTR RECEIVED_VALUE
    MOV PLAYER2_NAME[1],CL
    MOV RECEIVED_VALUE,0
    
    LEA SI,PLAYER2_NAME[2]
    RECEIVING_PLAYER2NAME:
    CALL RECEIVE_DATA 
    CMP RECEIVED_VALUE,0
    JE RECEIVING_PLAYER2NAME
    MOV AL,BYTE PTR RECEIVED_VALUE
    MOV [SI],AL
    MOV RECEIVED_VALUE,0 
    INC SI
    LOOP RECEIVING_PLAYER2NAME
    
    
	;-------------------------------------------------
	call ChooseBasket1Color    ;CHOOSING BASKET1 COLORS
	MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H
    INT 10H 
    
    MOV AL,COLOR1
    MOV BYTE PTR SEND_VALUE,AL
    CALL SEND_DATA
	
	;static screen for player1 
	 
	STATIC_SCREEN2:
    CALL RECEIVE_DATA 
    CMP RECEIVED_VALUE,0 
    JE STATIC_SCREEN2 
    MOV AL,BYTE PTR RECEIVED_VALUE
    MOV COLOR2,AL
    MOV RECEIVED_VALUE,0
    
    OUT_MENU: 
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
MAIN_MENU_PROC ENDP
;---------------------------------------
LEVEL1_PROC PROC
    MOV RADIUS_LENGTH,160
    MOV RADIUS_SQUARED,25600
    MOV CHECKER,113
    MOV INITIAL_Y,274
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H         
    INT 10H
    
    CALL DRAW_GUI
    ;-----------------------
    LEVEL1_LOOP:
    CMP SENT_INCHAT_REQUEST,1
    JNE CONT_P1_L1
    CMP RECEIVED_INCHAT_REQUEST,1
    JNE CONT_P1_L1
    CALL INGAME_CHAT
    CONT_P1_L1:
    CMP  PLAYER,1
    JNE  P2UP_CHECK1
    CMP  P1UP,3
    JE   ZIGZAG_SHOT1
    JMP  NORMAL_SHOT1
    P2UP_CHECK1:
    CMP  P2UP,3
    JE   ZIGZAG_SHOT1
    NORMAL_SHOT1:
    CALL THROW_BALL            ;NB THROW_BALL CHECKS IF A BALL IS ALREADY THROWN
    JMP AFTER_ZIGZAG1 
    ZIGZAG_SHOT1:
    CALL THROW_ZIGZAG          ;NB THROW_ZIGZAG CHECKS IF A BALL IS ALREADY THROWN
    AFTER_ZIGZAG1:
    CMP Y_COORDINATE,275       ;END ROUND CONDITION
    JNE  CONTINUE_LOOP1_LEVEL1
    CALL SCOREUPDATE           ;CALC THE ROUND SCORE
    MOV Y_COORDINATE,274       ;RESET THE BALL Y POSITION
    CMP ENDGAME,1              ;ENDGAME FLAG
    JE ASSIST1_EXITT
    ;-----------------------
    CONTINUE_LOOP1_LEVEL1:
    
    CMP MY_PLAYER,1
    JNE ASSIST_PLAYER2_ACTIONS
    
    MOV AH,1                   ;CHECK KEY PRESS
    INT 16H 
    JNZ PLAYER1_SENDING_KEYS
    MOV RECEIVED_VALUE,0
    CALL RECEIVE_DATA
    CMP RECEIVED_VALUE,0
    JE LEVEL1_LOOP
    
    ;-----------------------
    ;PLAYER 1 
    MOV AX,RECEIVED_VALUE
    CMP AL,'1'
    JNE CONT_REC_CHECK
    MOV RECEIVED_INCHAT_REQUEST,1
    JMP LEVEL1_LOOP
    CONT_REC_CHECK:
    CMP AL,'A'                 ;IF A
    JE ASSIST2_PLAYER2_LEFT1
    CMP AL,'a'                 ;IF a
    JE ASSIST2_PLAYER2_LEFT1
    CMP AL,'D'                 ;IF D
    JE ASSIST2_PLAYER2_RIGHT1
    CMP AL,'d'                 ;IF d
    JE ASSIST2_PLAYER2_RIGHT1
    CMP THROW_FLAG,1
    JE ASSIST0_LEVEL1_LOOP
    CMP PLAYER,1
    JE ASSIST0_LEVEL1_LOOP
    CMP AL,'W'                 ;IF W
    JE ASSIST2_PLAYER2_THROW
    CMP AL,'w'                 ;IF w
    JE ASSIST2_PLAYER2_THROW
    CMP AL,1BH               ;ESC
    JE  ASSIST1_EXITT
    JMP LEVEL1_LOOP
    ;----------------- 
    
    ASSIST_PLAYER2_ACTIONS:
    JMP PLAYER2_ACTIONS 
    ASSIST0_LEVEL1_LOOP:
    JMP ASSIST1_LEVEL1_LOOP
    ASSIST1_EXITT:
    JMP ASSIST_EXITT      
    ASSIST2_PLAYER2_LEFT1:
    JMP ASSIST_PLAYER2_LEFT1
    ASSIST2_PLAYER2_RIGHT1:
    JMP ASSIST_PLAYER2_RIGHT1
    ASSIST2_PLAYER2_THROW:
    JMP PLAYER2_THROW
    
    ;-----------------
    
    PLAYER1_SENDING_KEYS:
    MOV AH,0
    INT 16H
    MOV SEND_VALUE,AX
    CMP AL,1BH
    JE ASSIST1_EXITT           
    CMP AL,'1'
    JNE S0
    MOV SENT_INCHAT_REQUEST,1
    CALL SEND_DATA
    JMP ASSIST_LEVEL1_LOOP
    S0:
    CMP AL,'A'                 ;IF A 
    JNE S1
    CALL SEND_DATA        
    JMP KEY_ACTION1
    S1:
    CMP AL,'a'                 ;IF a  
    JNE S2
    CALL SEND_DATA                
    JMP KEY_ACTION1
    S2:
    CMP AL,'D'                 ;IF D   
    JNE S3
    CALL SEND_DATA               
    JMP KEY_ACTION1
    S3:
    CMP AL,'d'                 ;IF d 
    JNE S4
    CALL SEND_DATA             
    JMP KEY_ACTION1
    S4:
    CMP PLAYER,2
    JE ASSIST1_LEVEL1_LOOP
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN DON'T THROW ANOTHER ONE
    JE ASSIST1_LEVEL1_LOOP
    CMP AL,'W'                 ;IF W
    JNE S5
    CALL SEND_DATA
    MOV THROW_FLAG,1
    JMP KEY_ACTION1
    S5:
    CMP AL,'w'                 ;IF w
    JNE ASSIST1_LEVEL1_LOOP
    CALL SEND_DATA
    MOV THROW_FLAG,1
                    
    KEY_ACTION1:  
    CMP AL,'A'                 ;IF A 
    JE  ASSIST_PLAYER1_LEFT1
    CMP AL,'a'                 ;IF a  
    JE  ASSIST_PLAYER1_LEFT1
    CMP AL,'D'                 ;IF D   
    JE  ASSIST_PLAYER1_RIGHT1
    CMP AL,'d'                 ;IF d 
    JE  ASSIST_PLAYER1_RIGHT1
    CMP AL,'W'                 ;IF W
    JE  ASSIST_PLAYER1_THROW
    CMP AL,'w'                 ;IF w
    JE  ASSIST_PLAYER1_THROW
    ;----------------------- 
    ASSIST1_LEVEL1_LOOP:
    JMP LEVEL1_LOOP   
    
    ASSIST_PLAYER2_LEFT1:
    JMP PLAYER2_LEFT1
    
    ASSIST_PLAYER2_RIGHT1:
    JMP PLAYER2_RIGHT1
    
    ASSIST_PLAYER2_THROW:
    JMP PLAYER2_THROW
    
    ASSIST_PLAYER1_RIGHT1:
    JMP PLAYER1_RIGHT1
    
    ASSIST_PLAYER1_LEFT1:
    JMP PLAYER1_LEFT1 
    
    ASSIST_PLAYER1_THROW:
    JMP PLAYER1_THROW
    
    ASSIST_EXITT:
    MOV SEND_VALUE,1BH
    CALL SEND_DATA
    JMP EXITT
    
    ;-----------------------
    PLAYER2_ACTIONS:
    MOV SEND_VALUE,0
    MOV AH,1                   ;CHECK KEY PRESS
    INT 16H 
    JNZ PLAYER2_SENDING_KEYS
    MOV RECEIVED_VALUE,0
    CALL RECEIVE_DATA
    CMP RECEIVED_VALUE,0
    JE ASSIST2_LEVEL1_LOOP
    
    
    ;PLAYER 2     
    MOV AX,RECEIVED_VALUE
    CMP AL,'1'
    JNE CONT2_REC_CHECK
    MOV RECEIVED_INCHAT_REQUEST,1
    JMP ASSIST2_LEVEL1_LOOP
    CONT2_REC_CHECK:
    CMP AL,'A'                 ;IF A
    JE ASSIST_PLAYER1_LEFT1
    CMP AL,'a'                 ;IF a
    JE ASSIST_PLAYER1_LEFT1
    CMP AL,'D'                 ;IF D
    JE ASSIST_PLAYER1_RIGHT1
    CMP AL,'d'                 ;IF d
    JE ASSIST_PLAYER1_RIGHT1
    CMP THROW_FLAG,1
    JE ASSIST2_LEVEL1_LOOP
    CMP PLAYER,2
    JE ASSIST2_LEVEL1_LOOP
    CMP AL,'W'                 ;IF W
    JE ASSIST_PLAYER1_THROW
    CMP AL,'w'                 ;IF w
    JE ASSIST_PLAYER1_THROW
    CMP AL,1BH               ;ESC
    JE  ASSIST_EXITT
    JMP LEVEL1_LOOP
    
    ASSIST2_PLAYER1_THROW:
    JMP ASSIST_PLAYER1_THROW
    ASSIST2_LEVEL1_LOOP:
    JMP ASSIST_LEVEL1_LOOP
    ASSISTTT_EXITT:
    MOV SEND_VALUE,1BH
    CALL SEND_DATA
    JMP EXITT
    
    PLAYER2_SENDING_KEYS:
    MOV AH,0
    INT 16H
    MOV SEND_VALUE,AX
    CMP AX,011BH
    JE ASSISTTT_EXITT
    CMP AL,'1'
    JNE S01
    MOV SENT_INCHAT_REQUEST,1
    CALL SEND_DATA
    JMP ASSIST2_LEVEL1_LOOP
    S01: 
    CMP AL,'A'                 ;IF A 
    JNE S6
    CALL SEND_DATA        
    JMP KEY_ACTION2
    S6:
    CMP AL,'a'                 ;IF a  
    JNE S7
    CALL SEND_DATA                
    JMP KEY_ACTION2
    S7:
    CMP AL,'D'                 ;IF D   
    JNE S8
    CALL SEND_DATA               
    JMP KEY_ACTION2
    S8:
    CMP AL,'d'                 ;IF d 
    JNE S9
    CALL SEND_DATA             
    JMP KEY_ACTION2
    S9:
    CMP PLAYER,1
    JE ASSIST_LEVEL1_LOOP
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN DON'T THROW ANOTHER ONE
    JE ASSIST_LEVEL1_LOOP
    CMP AL,'W'                 ;IF W
    JNE S10
    CALL SEND_DATA
    MOV THROW_FLAG,1
    JMP KEY_ACTION2
    S10:
    CMP AL,'w'                 ;IF w
    JNE ASSIST_LEVEL1_LOOP
    CALL SEND_DATA
    MOV THROW_FLAG,1
                    
    KEY_ACTION2:  
    CMP AL,'A'                 ;IF A 
    JE  PLAYER2_LEFT1
    CMP AL,'a'                 ;IF a  
    JE  PLAYER2_LEFT1
    CMP AL,'D'                 ;IF D   
    JE  PLAYER2_RIGHT1
    CMP AL,'d'                 ;IF d 
    JE  PLAYER2_RIGHT1
    CMP AL,'W'                 ;IF W
    JE  PLAYER2_THROW
    CMP AL,'w'                 ;IF w
    JE  PLAYER2_THROW
    
    ;----------------------- 
    
    ASSIST_LEVEL1_LOOP:
    JMP LEVEL1_LOOP 
    
    
    ;-----------------------
    PLAYER1_RIGHT1:
    CALL MOVEBASKET1RIGHT      ;MOVE PLAYER 1 RIGHT
    JMP ASSIST_LEVEL1_LOOP
    PLAYER1_LEFT1:
    CALL MOVEBASKET1LEFT       ;MOVE PLAYER 1 LEFT
    JMP ASSIST_LEVEL1_LOOP
    PLAYER2_LEFT1:
    CALL MOVEBASKET2LEFT       ;MOVE PLAYER 2 LEFT
    JMP ASSIST_LEVEL1_LOOP
    PLAYER2_RIGHT1:
    CALL MOVEBASKET2RIGHT      ;MOVE PLAYRE 2 RIGHT
    JMP ASSIST_LEVEL1_LOOP
    ;------------------------
    PLAYER1_THROW:
    CMP PLAYER,1               ;THROW BALL PLAYER 1
    JNE ASSIST_LEVEL1_LOOP
    MOV AX,BASKETX1            ;INITIALIZE BALL X COORDINATE
    ADD AX,20
    MOV INITIAL_X,AX
    MOV AX,INITIAL_X
    MOV X_COORDINATE,AX
    SUB AX,RADIUS_LENGTH       ;CALC X OF CENTER
    MOV CENTER_X,AX
    MOV AX,INITIAL_Y
    MOV Y_COORDINATE,AX
    MOV CENTER_Y,AX            ;SET  Y OF CENTER
    MOV AX,X_COORDINATE
    SUB AX,CENTER_X
    MOV CURRENT_X,AX           ;MAPPING THE X COORDINATE
    MOV AX,Y_COORDINATE
    SUB AX,CENTER_Y            ;MAPPING THE Y COORDINATE
    MOV CURRENT_Y,AX
    MOV THROW_FLAG,1           ;SET THE THROW FLAG
    MOV ZIGZAG_COUNTER,0       ;RESET THE ZIGZAG COUNTER
    JMP LEVEL1_LOOP            ;RETURN BACK TO THE LEVEL LOOP
    ;------------------------
    PLAYER2_THROW:             
    ;SAME AS PLAYER1_THROW WITH A CHANGE IN THE MAPPING PROCESS
    CMP PLAYER,2
    JNE ASSIST_LEVEL1_LOOP
    MOV AX,BASKETX2
    ADD AX,20
    MOV INITIAL_X,AX
    MOV AX,INITIAL_X
    MOV X_COORDINATE,AX
    ADD AX,RADIUS_LENGTH
    MOV CENTER_X,AX
    MOV AX,INITIAL_Y
    MOV Y_COORDINATE,AX
    MOV CENTER_Y,AX
    MOV AX,X_COORDINATE
    SUB AX,CENTER_X
    MOV CURRENT_X,AX
    MOV AX,Y_COORDINATE
    SUB AX,CENTER_Y
    MOV CURRENT_Y,AX
    MOV THROW_FLAG,1
    MOV ZIGZAG_COUNTER,0
    JMP LEVEL1_LOOP
    ;------------------------
    ; END OF LEVEL ONE
    EXITT:
    MOV SEND_VALUE,1BH
    CALL SEND_DATA
    MOV SEND_VALUE,0
    MOV AH,0
    MOV AL,12H
    INT 10H
    RET
LEVEL1_PROC ENDP    
   
LONG_SHOT_INIT PROC
      
      MOV RADIUS_LENGTH,160
      MOV RADIUS_SQUARED,25600
      MOV CHECKER,113
      MOV INITIAL_Y,274
      CMP PLAYER,1
      JNE PLAYER_2_L
      MOV AX,INITIAL_X
      MOV X_COORDINATE,AX
      SUB AX,RADIUS_LENGTH
      MOV CENTER_X,AX
      MOV AX,INITIAL_Y
      MOV Y_COORDINATE,AX
      MOV CENTER_Y,AX
    
      MOV AX,X_COORDINATE
      SUB AX,CENTER_X
      MOV CURRENT_X,AX
    
      MOV AX,Y_COORDINATE
      SUB AX,CENTER_Y
      MOV CURRENT_Y,AX
      
      JMP END_INIT_L
      
      PLAYER_2_L:
      MOV AX,INITIAL_X
      MOV X_COORDINATE,AX
      ADD AX,RADIUS_LENGTH
      MOV CENTER_X,AX
      MOV AX,INITIAL_Y
      MOV Y_COORDINATE,AX
      MOV CENTER_Y,AX
    
      MOV AX,X_COORDINATE
      SUB AX,CENTER_X
      MOV CURRENT_X,AX
    
      MOV AX,Y_COORDINATE
      SUB AX,CENTER_Y
      MOV CURRENT_Y,AX 
      END_INIT_L:
      
      RET
LONG_SHOT_INIT ENDP
   
LONG_SHOT PROC                
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN
    JNE L_ASSIST_FINISH_THROW    ;IF SO DON'T THROW ANOTHER ONE
    ;--------------------------
    ;--------------------------

    MOV CX,X_COORDINATE        ;INITIALIZE THE CURRENT BALL X
    MOV DX,Y_COORDINATE        ;INITIALIZE THE CURRENT BALL Y
    MOV X_DRAW_BALL,CX
    MOV Y_DRAW_BALL,DX
    ;--------------------------
    ;--------------------------
    CALL DRAWBALL   
    CALL DELETEBALL
    ;--------------------------
    ;--------------------------
    
    CMP PLAYER,2               ;CHECK WHO'S THE THROWING PLAYER
    JE  L_PLAYER2_COORDINATES    ;IF PLAYER 2 GO TO PLAYER 2 COORDINATION
    ;--------------------------
    ;--------------------------
    MOV AX,CHECKER             
    CMP CURRENT_Y,AX           ;CHECK 1ST/2ND/3RD/4TH QUARTER OF ARC
    JL L_FIRST_OR_FOURTH_Q       
    JMP L_SECOND_OR_THIRD_Q
    
    L_FIRST_OR_FOURTH_Q:         ;IF Y IS LOWER THAN SIN(45) OF THE ARC RADIUS
    CMP CURRENT_X,0            ;CHECK IF IT'S 1ST OR 4TH QUARTER
    JG L_FIRST_Q
    JMP L_FOURTH_Q
    
    L_SECOND_OR_THIRD_Q:         ;IF Y IS GREATER THAN SIN(45) OF THE ARC RADIUS
    CMP CURRENT_X,0            ;CHECK IF IT'S 2ND OR 3RD QUARTER
    JG  L_SECOND_Q
    JMP L_THIRD_Q 
    
    L_ASSIST_FINISH_THROW:
    JMP S_FINISH
    ;---------------------------
    ;---------------------------
    L_FIRST_Q:                   ;IF X IS GREATER THAN 0
    ;---------------------------
    CALL FIRST_Q_PLAYER1
    JMP L_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    L_SECOND_Q:                  ;IF X IS GREATER THAN 0
    ;---------------------------
    CALL SECOND_Q_PLAYER1
    JMP L_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    L_THIRD_Q:                   ;IF Y IS LESS THAN 0
    ;---------------------------
    CALL THIRD_Q_PLAYER
    JMP L_FINISH
    ;---------------------------
    ;---------------------------
    L_FOURTH_Q:                  ;IF Y IS LESS THAN 0
    ;---------------------------
    CALL FOURTH_Q_PLAYER
    JMP S_FINISH
    ;---------------------------
    L_PLAYER2_COORDINATES:       ;SAME AS PLAYER 1 BUT MIRRORED ON Y AXIS
    ;PLAYER 2
    
    MOV AX,CHECKER
    CMP CURRENT_Y,AX
    JL L_FIRST_OR_FOURTH_Q2
    JMP L_SECOND_OR_THIRD_Q2
    
    L_FIRST_OR_FOURTH_Q2:
    CMP CURRENT_X,0
    JG L_FOURTH_Q2
    JMP L_FIRST_Q2
    
    L_SECOND_OR_THIRD_Q2:
    CMP CURRENT_X,0
    JG  L_THIRD_Q2
    JMP L_SECOND_Q2
    
    ;---------------------------
    ;---------------------------
    L_FIRST_Q2:
    ;---------------------------
    CALL FIRST_Q_PLAYER2
    JMP L_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    L_SECOND_Q2:
    ;---------------------------
    CALL SECOND_Q_PLAYER2
    JMP L_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    L_THIRD_Q2:
    ;---------------------------
    CALL THIRD_Q_PLAYER2
    JMP L_FINISH
    ;---------------------------
    ;---------------------------
    L_FOURTH_Q2:
    ;---------------------------
    CALL FOURTH_Q_PLAYER2
    JMP L_FINISH
    ;---------------------------
    
    ;---------------------------
    
    L_FINISH:
    RET
    
LONG_SHOT ENDP

HALF_SHOT_INIT PROC
    MOV CHECKER,56
    MOV INITIAL_Y,274
    MOV RADIUS_LENGTH,80
    MOV RADIUS_SQUARED,6400
    CMP PLAYER,1
    JNE PLAYER_2_S
    MOV AX,INITIAL_X
    MOV X_COORDINATE,AX
    SUB AX,RADIUS_LENGTH
    MOV CENTER_X,AX
    MOV AX,INITIAL_Y
    MOV Y_COORDINATE,AX
    MOV CENTER_Y,AX
    
    MOV AX,X_COORDINATE
    SUB AX,CENTER_X
    MOV CURRENT_X,AX
    
    MOV AX,Y_COORDINATE
    SUB AX,CENTER_Y
    MOV CURRENT_Y,AX
      
    JMP END_INIT_S
      
    PLAYER_2_S:
    MOV AX,INITIAL_X
    MOV X_COORDINATE,AX
    ADD AX,RADIUS_LENGTH
    MOV CENTER_X,AX
    MOV AX,INITIAL_Y
    MOV Y_COORDINATE,AX
    MOV CENTER_Y,AX
    
    MOV AX,X_COORDINATE
    SUB AX,CENTER_X
    MOV CURRENT_X,AX
    
    MOV AX,Y_COORDINATE
    SUB AX,CENTER_Y
    MOV CURRENT_Y,AX 
    END_INIT_S:
    RET
HALF_SHOT_INIT ENDP

HALF_SHOT PROC                
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN
    JNE S_ASSIST_FINISH_THROW    ;IF SO DON'T THROW ANOTHER ONE
    ;--------------------------
    ;--------------------------

    MOV CX,X_COORDINATE        ;INITIALIZE THE CURRENT BALL X
    MOV DX,Y_COORDINATE        ;INITIALIZE THE CURRENT BALL Y
    MOV X_DRAW_BALL,CX
    MOV Y_DRAW_BALL,DX
    ;--------------------------
    ;--------------------------
    CALL DRAWBALL   
    CALL DELETEBALL
    ;--------------------------
    ;--------------------------
    
    CMP PLAYER,2               ;CHECK WHO'S THE THROWING PLAYER
    JE  S_PLAYER2_COORDINATES    ;IF PLAYER 2 GO TO PLAYER 2 COORDINATION
    ;--------------------------
    ;--------------------------
    MOV AX,CHECKER             
    CMP CURRENT_Y,AX           ;CHECK 1ST/2ND/3RD/4TH QUARTER OF ARC
    JL S_FIRST_OR_FOURTH_Q       
    JMP S_SECOND_OR_THIRD_Q
    
    S_FIRST_OR_FOURTH_Q:         ;IF Y IS LOWER THAN SIN(45) OF THE ARC RADIUS
    CMP CURRENT_X,0            ;CHECK IF IT'S 1ST OR 4TH QUARTER
    JG S_FIRST_Q
    JMP S_FOURTH_Q
    
    S_SECOND_OR_THIRD_Q:         ;IF Y IS GREATER THAN SIN(45) OF THE ARC RADIUS
    CMP CURRENT_X,0            ;CHECK IF IT'S 2ND OR 3RD QUARTER
    JG  S_SECOND_Q
    JMP S_THIRD_Q 
    
    S_ASSIST_FINISH_THROW:
    JMP S_FINISH
    ;---------------------------
    ;---------------------------
    S_FIRST_Q:                   ;IF X IS GREATER THAN 0
    ;---------------------------
    CALL FIRST_Q_PLAYER1
    JMP S_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    S_SECOND_Q:                  ;IF X IS GREATER THAN 0
    ;---------------------------
    CALL SECOND_Q_PLAYER1
    JMP S_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    S_THIRD_Q:                   ;IF Y IS LESS THAN 0
    ;---------------------------
    CALL THIRD_Q_PLAYER
    JMP S_FINISH
    ;---------------------------
    ;---------------------------
    S_FOURTH_Q:                  ;IF Y IS LESS THAN 0
    ;---------------------------
    CALL FOURTH_Q_PLAYER
    JMP S_FINISH
    ;---------------------------
    S_PLAYER2_COORDINATES:       ;SAME AS PLAYER 1 BUT MIRRORED ON Y AXIS
    ;PLAYER 2
    
    MOV AX,CHECKER
    CMP CURRENT_Y,AX
    JL S_FIRST_OR_FOURTH_Q2
    JMP S_SECOND_OR_THIRD_Q2
    
    S_FIRST_OR_FOURTH_Q2:
    CMP CURRENT_X,0
    JG S_FOURTH_Q2
    JMP S_FIRST_Q2
    
    S_SECOND_OR_THIRD_Q2:
    CMP CURRENT_X,0
    JG  S_THIRD_Q2
    JMP S_SECOND_Q2
    
    ;---------------------------
    ;---------------------------
    S_FIRST_Q2:
    ;---------------------------
    CALL FIRST_Q_PLAYER2
    JMP S_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    S_SECOND_Q2:
    ;---------------------------
    CALL SECOND_Q_PLAYER2
    JMP S_FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    S_THIRD_Q2:
    ;---------------------------
    CALL THIRD_Q_PLAYER2
    JMP S_FINISH
    ;---------------------------
    ;---------------------------
    S_FOURTH_Q2:
    ;---------------------------
    CALL FOURTH_Q_PLAYER2
    JMP S_FINISH
    ;---------------------------
    
    ;---------------------------
    
    S_FINISH:
    RET
    
HALF_SHOT ENDP

REINITIALIZE PROC
    ;THIS PROCEDURE REINITIALIZES THE VARIABLES AGAIN TO THEIR ORIGINAL VALUES
    PUSH BX
    PUSH CX
    MOV INITIAL_X,635
    MOV INITIAL_Y,470
    MOV NO_BOUNCE,0
    MOV ZIGZAG_COUNTER,0
    MOV basketX1,457
    MOV basketX2,163
    MOV score1,5
    MOV score2,5 
    MOV ENDGAME,0
    MOV THROW_FLAG,0
    MOV P1UP,0
    MOV P2UP,0
    MOV LOOPNUM,1
    MOV TRANSNUMB,0
    MOV COUNTDOWN,'1'
    MOV PLAYER1_NAME,30
    MOV PLAYER2_NAME,30
    MOV PLAYER1_NAME,63    ;?
    MOV PLAYER2_NAME,63    ;? 
    MOV PLAYER,1
    MOV FrameX,149
    MOV FrameY,199
    MOV Color1,1
    MOV Color2,1
    MOV CX,30
    MOV BX,2
    NAMING:
    MOV PLAYER1_NAME[BX],'$'
    MOV PLAYER2_NAME[BX],'$'   
    INC BX
    LOOP NAMING 
    POP CX
    POP BX
    RET
REINITIALIZE ENDP        
    
CHOOSE PROC           ;PRINTING LEVEL CHOICES
    ;------------------------
    LEA BP,MSG1       ;PRINTING 'LEVEL1'
    MOV CX,7
    MOV DX,0E24H
    MOV AH,13H 
    MOV AL,0
    MOV BH,0
    MOV BL,0FH
    CMP CHOICE,1
    JNE WHITE1        ;IF NOT CHOSEN PRINT IN WHITE
    MOV BL,2          ;IF CHOSEN CHANGE TO GREEN
    WHITE1:
    INT 10H
    ;------------------------
    LEA BP,MSG2       ;PRINTING 'LEVEL2'
    ADD DH,2
    MOV DL,24H
    MOV AH,13H 
    MOV AL,0
    MOV BH,0
    MOV BL,0FH
    CMP CHOICE,2
    JNE WHITE2        ;IF NOT CHOSEN THEN WHITE
    MOV BL,2          ;IF CHOSEN THEN GREEN
    WHITE2:
    INT 10H
    ;------------------------
    MOV CX,4          ;PRINTING 'EXIT'
    LEA BP,MSG3
    ADD DH,2
    MOV DL,24H
    MOV AH,13H 
    MOV AL,0
    MOV BH,0
    MOV BL,0FH
    CMP CHOICE,3      ;IF NOT CHOSEN THEN WHITE
    JNE WHITE3        ;IF CHOSEN THEN GREEN
    MOV BL,2
    WHITE3:
    INT 10H
    ;------------------------
    RET
CHOOSE ENDP
    ;--------------------------------------------------
DRAW_FIREBALL PROC    
                    ;PRINTING FIREBALL
                    ;SETTING CURSOR AND NUMBER OF CHARS IN EACH ROW
                    ;COLOR IS SET FROM OUTSIDE
                    ;FIRST POSITION IS SET FROM OUTSIDE THEN ROW IS INC
    ;------------------------
    MOV BH,0       
    MOV AL,1
    LEA BP,F1
    MOV AH,13H
    MOV CX,13
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F2
    MOV AH,13H
    MOV CX,16
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F3
    MOV AH,13H
    MOV CX,19
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F4
    MOV AH,13H
    MOV CX,20
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F5
    MOV AH,13H
    MOV CX,21
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F6
    MOV AH,13H
    MOV CX,22
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F7
    MOV AH,13H
    MOV CX,23
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F8
    MOV AH,13H
    MOV CX,23
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F9
    MOV AH,13H
    MOV CX,23
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F10
    MOV AH,13H
    MOV CX,23
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F11
    MOV AH,13H
    MOV CX,22
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F12
    MOV AH,13H
    MOV CX,20
    INT 10H
    ;------------------------
    INC DH
    LEA BP,F13
    MOV AH,13H
    MOV CX,16
    INT 10H
    ;------------------------
    RET
DRAW_FIREBALL ENDP 
    ;--------------------------------------------------
TRANSN PROC
    ;------------------------
    PUSH DX            ;PUSH THE PRE-SET POSITION OF THE FIREBALL
    MOV CX,0FH         ;DELAY
    MOV DX,4240H
    MOV AX,8600H
    INT 15H
    POP DX             ;POP THE FIREBALL POSTION
    ;------------------------
    PUSH DX            ;PUSH IT AGAIN
    CALL DRAW_FIREBALL ;DRAW THE FIREBALL
    ;------------------------
    LEA BP,COUNTDOWN   ;PRINTNIG THE COUNTDOWN VALUE
    MOV CX,1
    MOV DX,0E27H
    MOV AH,13H 
    MOV AL,0
    MOV BH,0
    MOV BL,0FH
    INT 10H
    ;------------------------
    MOV CX,0FH         ;DELAY
    MOV DX,4240H
    MOV AX,8600H
    INT 15H
    ;------------------------
    POP DX             ;POP THE FIREBALL POSITION
    PUSH DX            ;PUSH IT AGAIN
    MOV BL,4
    CALL DRAW_FIREBALL ;DELETE THE FIREBALL TO BE MOVED DOWN AGAIN
    POP DX
    ;------------------------
    INC COUNTDOWN      ;INCREMENT THE COUNTDOWN VALUE
    ;------------------------
    RET
TRANSN ENDP
    ;--------------------------------------------------
TRANSN_CONTINUED PROC
    ;------------------------
    PUSH DX
    MOV CX,0FH         ;DELAY
    MOV DX,4240H
    MOV AX,8600H
    INT 15H
    POP DX
    ;------------------------
    MOV BL,0
    CALL DRAW_FIREBALL ;DELETE THE FIREBALL
    ;------------------------
    LEA BP,COUNTDOWN_MSG ;PRINT 'GO'
    MOV CX,2
    MOV DX,0E27H
    MOV AH,13H 
    MOV AL,0
    MOV BH,0
    MOV BL,2
    INT 10H 
    ;------------------------
    PUSH DX
    MOV CX,0FH         ;DELAY
    MOV DX,4240H
    MOV AX,8600H
    INT 15H
    ;------------------------
    POP DX
    RET
TRANSN_CONTINUED ENDP
    ;--------------------------------------------------
ZIGZAG PROC
    ;------------------------
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;------------------------
    MOV CX,30
    ZIGZAG_LOOP1:           ;FIRST HALF OF THE ZIGZAG
    PUSH CX
    CMP X_DRAW_BALL,5       ;CHECK IF END OF SCREEN IS REACHED
    JG CONTINUE_ZIGZAG
    MOV X_DRAW_BALL,635     ;RESET BACK THE BALL TO THE BEGINING OF SCREEN
    CONTINUE_ZIGZAG: 
    DEC X_DRAW_BALL         ;MOVE THE BALL
    DEC Y_DRAW_BALL
    CALL DRAWBALL
    CALL DELETEBALL
    POP CX
    LOOP  ZIGZAG_LOOP1
    ;------------------------
    MOV CX,30
    ZIGZAG_LOOP2:           ;SECOND HALF OF THE ZIZAG
                            ;SAME IDEA AS THE FIRST HALF
    PUSH CX
    INC Y_DRAW_BALL
    DEC X_DRAW_BALL
    CALL DRAWBALL
    CALL DELETEBALL
    POP CX
    LOOP ZIGZAG_LOOP2
    ;------------------------
    POP DX
    POP CX
    POP BX
    POP AX
    ;------------------------
    RET
ZIGZAG ENDP
   ;--------------------------------------------------
   ;--------------------------------------------------
   ;--------------------------------------------------
   ;--------------------------------------------------
   ;--------------------------------------------------
   
THROW_BALL PROC                
    CMP THROW_FLAG,1           ;CHECK IF A BALL IS ALREADY THROWN
    JNE ASSIST_FINISH_THROW    ;IF SO DON'T THROW ANOTHER ONE
    ;--------------------------
    ;--------------------------

    MOV CX,X_COORDINATE        ;INITIALIZE THE CURRENT BALL X
    MOV DX,Y_COORDINATE        ;INITIALIZE THE CURRENT BALL Y
    MOV X_DRAW_BALL,CX
    MOV Y_DRAW_BALL,DX
    ;--------------------------
    ;--------------------------
    CALL DRAWBALL   
    CALL DELETEBALL
    ;--------------------------
    ;--------------------------
    
    CMP PLAYER,2               ;CHECK WHO'S THE THROWING PLAYER
    JE  PLAYER2_COORDINATES    ;IF PLAYER 2 GO TO PLAYER 2 COORDINATION
    ;--------------------------
    ;--------------------------
    MOV AX,CHECKER             
    CMP CURRENT_Y,AX           ;CHECK 1ST/2ND/3RD/4TH QUARTER OF ARC
    JL FIRST_OR_FOURTH_Q       
    JMP SECOND_OR_THIRD_Q
    
    FIRST_OR_FOURTH_Q:         ;IF Y IS LOWER THAN SIN(45) OF THE ARC RADIUS
    CMP CURRENT_X,0            ;CHECK IF IT'S 1ST OR 4TH QUARTER
    JG FIRST_Q
    JMP FOURTH_Q
    
    SECOND_OR_THIRD_Q:         ;IF Y IS GREATER THAN SIN(45) OF THE ARC RADIUS
    CMP CURRENT_X,0            ;CHECK IF IT'S 2ND OR 3RD QUARTER
    JG  SECOND_Q
    JMP THIRD_Q 
    
    ASSIST_FINISH_THROW:
    JMP FINISH
    ;---------------------------
    ;---------------------------
    FIRST_Q:                   ;IF X IS GREATER THAN 0
    ;---------------------------
    CALL FIRST_Q_PLAYER1
    JMP FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    SECOND_Q:                  ;IF X IS GREATER THAN 0
    ;---------------------------
    CALL SECOND_Q_PLAYER1
    JMP FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    THIRD_Q:                   ;IF Y IS LESS THAN 0
    ;---------------------------
    CALL THIRD_Q_PLAYER
    JMP FINISH
    ;---------------------------
    ;---------------------------
    FOURTH_Q:                  ;IF Y IS LESS THAN 0
    ;---------------------------
    CALL FOURTH_Q_PLAYER
    JMP FINISH
    ;---------------------------
    PLAYER2_COORDINATES:       ;SAME AS PLAYER 1 BUT MIRRORED ON Y AXIS
    ;PLAYER 2
    
    MOV AX,CHECKER
    CMP CURRENT_Y,AX
    JL FIRST_OR_FOURTH_Q2
    JMP SECOND_OR_THIRD_Q2
    
    FIRST_OR_FOURTH_Q2:
    CMP CURRENT_X,0
    JG FOURTH_Q2
    JMP FIRST_Q2
    
    SECOND_OR_THIRD_Q2:
    CMP CURRENT_X,0
    JG  THIRD_Q2
    JMP SECOND_Q2
    
    ;---------------------------
    ;---------------------------
    FIRST_Q2:
    ;---------------------------
    CALL FIRST_Q_PLAYER2
    JMP FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    SECOND_Q2:
    ;---------------------------
    CALL SECOND_Q_PLAYER2
    JMP FINISH
    ;---------------------------
    
    ;---------------------------
    ;---------------------------
    THIRD_Q2:
    ;---------------------------
    CALL THIRD_Q_PLAYER2
    JMP FINISH
    ;---------------------------
    ;---------------------------
    FOURTH_Q2:
    ;---------------------------
    CALL FOURTH_Q_PLAYER2
    JMP FINISH
    ;---------------------------
    
    ;---------------------------
    
    FINISH:
    RET
    
THROW_BALL ENDP

    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;THROW_BALL UTILITY PROCEDURES


FIRST_Q_PLAYER1 PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF X_COORDINATE WILL BE CHANGED
    ;THE USED INEQUALITY
    ;2[(Xi^2+Yi^2-r^2)+(2Yi+1)]+(1-2Xi)>0
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_Y
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_X
    MUL CX
    SUB COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    INC CURRENT_Y
    DEC Y_COORDINATE
    CMP COMPARISON_VAL,0
    JLE FINISH1
    DEC CURRENT_X
    DEC X_COORDINATE
    FINISH1:
    
    RET
FIRST_Q_PLAYER1 ENDP
    ;--------------------------
    ;--------------------------
    ;--------------------------
    
FIRST_Q_PLAYER2 PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF X_COORDINATE WILL BE CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_Y
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_X
    MUL CX
    ADD COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    INC CURRENT_Y
    DEC Y_COORDINATE
    CMP COMPARISON_VAL,0
    JLE FINISH5
    INC CURRENT_X
    INC X_COORDINATE
    FINISH5:
    
    RET
FIRST_Q_PLAYER2 ENDP
    ;--------------------------
    ;--------------------------
    ;-------------------------- 
    
SECOND_Q_PLAYER1 PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF Y_COORDINATE WILL CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_X
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_Y
    MUL CX
    SUB COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    DEC CURRENT_X
    DEC X_COORDINATE
    CMP COMPARISON_VAL,0
    JGE FINISH2
    INC CURRENT_Y
    DEC Y_COORDINATE
    
    FINISH2:
    
    RET
SECOND_Q_PLAYER1 ENDP
    ;--------------------------
    ;--------------------------
    ;--------------------------
    
SECOND_Q_PLAYER2 PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF Y_COORDINATE WILL CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_X
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_X
    MUL CX
    ADD COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    INC CURRENT_X
    INC X_COORDINATE
    CMP COMPARISON_VAL,0
    JG  FINISH6
    INC CURRENT_Y
    DEC Y_COORDINATE
    
    FINISH6:
    
    RET
SECOND_Q_PLAYER2 ENDP
    ;--------------------------
    ;--------------------------
    ;--------------------------
THIRD_Q_PLAYER PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF X_COORDINATE WILL CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_X
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_Y
    MUL CX
    SUB COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    DEC CURRENT_X
    DEC X_COORDINATE
    CMP COMPARISON_VAL,0
    JLE FINISH3
    DEC CURRENT_Y
    INC Y_COORDINATE
    
    FINISH3:
    
    RET
THIRD_Q_PLAYER ENDP
    ;--------------------------
    ;--------------------------
    ;--------------------------
    
THIRD_Q_PLAYER2 PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF Y_COORDINATE WILL CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_X
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_X
    MUL CX
    ADD COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    INC CURRENT_X
    INC X_COORDINATE
    CMP COMPARISON_VAL,0
    JL  FINISH7
    DEC CURRENT_Y
    INC Y_COORDINATE
    
    FINISH7:
    
    RET
THIRD_Q_PLAYER2 ENDP
    ;--------------------------
    ;--------------------------
    ;--------------------------
FOURTH_Q_PLAYER PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF X_COORDINATE WILL BE CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_X
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_Y
    MUL CX
    SUB COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    DEC CURRENT_Y
    INC Y_COORDINATE
    CMP COMPARISON_VAL,0
    JGE FINISH4
    DEC CURRENT_X
    DEC X_COORDINATE
    
    FINISH4:
    
    RET
FOURTH_Q_PLAYER ENDP

    ;--------------------------
    ;--------------------------
    ;--------------------------
    
FOURTH_Q_PLAYER2 PROC
    ;CIRCLE VALIDATION INEQUALITY
    ;USED TO CHECK IF X_COORDINATE WILL BE CHANGED
    ;------------------------
    ;CALCULATING THE LEFT HANDSIDE OF THE INEQUALITY
    ;SAME IDEA AS THE FIRST PROC
    MOV AX,CURRENT_X
    MOV CX,AX
    MUL CX
    MOV CURRENT_X_SQUARED,AX
    MOV AX,CURRENT_Y
    MOV CX,AX
    MUL CX
    MOV CURRENT_Y_SQUARED,AX
    
    MOV AX,CURRENT_X_SQUARED
    ADD AX,CURRENT_Y_SQUARED
    SUB AX,RADIUS_SQUARED
    MOV COMPARISON_VAL,AX
    MOV AX,CURRENT_X
    MOV CX,2
    MUL CX
    ADD AX,1
    ADD AX,COMPARISON_VAL
    MUL CX
    ADD COMPARISON_VAL,1
    MOV AX,CURRENT_Y
    MUL CX
    ADD COMPARISON_VAL,AX
    ;---------------------------
    ;SET THE NEXT POINT COORDINATES
    DEC CURRENT_Y
    INC Y_COORDINATE
    CMP COMPARISON_VAL,0
    JG  FINISH8
    INC CURRENT_X
    INC X_COORDINATE
    
    FINISH8:
    
    RET
FOURTH_Q_PLAYER2 ENDP

    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;PROCEDURE2
   
   DrawBall proc 
     mov si,y_draw_ball
    
  mov di,x_draw_ball     ;get center
  sub di,5               ;minus radius 

  mov cx,di
  mov dx,si  
  mov al,4h
  mov ah,0ch  
                         ;draw first line
  add di,10
  
back_draw:int 10h   
  inc cx
  cmp cx,di 
  jnz back_draw
  
 ;;;;;;;;;;;;;;;;;;;;;;;;
                          ;draw one line up and one down
  mov bx,10               ;10 pixels
  mov di,x_draw_ball     
  sub di,5                ;start position
 loop2_draw: 
  mov ax,2 
  mov si,y_draw_ball
  inc si 
 
loop1_draw:  
  push ax                  
  mov cx,di
  mov dx,si  
  mov al,4h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,2                ;Y-position
  dec ax
  cmp ax,0
  jnz loop1_draw 
  
  inc di
  dec bx 
  cmp bx,0
  jnz loop2_draw
  ;;;;;;;;;;;;;;;;;;;;;;
                         ;continue drawing lines                        
  mov bx,0008            ;second two lines 8 pixels
  mov di,x_draw_ball
  sub di,4
 loop22_draw: 
  mov ax,2 
  mov si,y_draw_ball
  add si,2 
 
loop11_draw:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,4h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,4 
  dec ax
  cmp ax,0
  jnz loop11_draw 
  
  inc di
  dec bx 
  cmp bx,0
  jnz loop22_draw
  
    ;;;;;;;;;;;;;;;;;;;;
  
  mov bx,0008 
  mov di,x_draw_ball
  sub di,4
 loop222_draw: 
  mov ax,2 
  mov si,y_draw_ball
  add si,3 
 
loop111_draw:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,4h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,6 
  dec ax
  cmp ax,0
  jnz loop111_draw 
  
  inc di
  dec bx 
  cmp bx,0
  jnz loop222_draw 
  ;;;;;;;;;;;;;;;;;
  
  mov bx,0006 
  mov di,x_draw_ball
  sub di,3
 loop2222_draw: 
  mov ax,2 
  mov si,y_draw_ball
  add si,4 
 
loop1111_draw:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,4h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,8 
  dec ax
  cmp ax,0
  jnz loop1111_draw 
  
  inc di
  dec bx 
  cmp bx,0
  jnz loop2222_draw
  
  CMP POWERUPFALL,1
  JE CHANGE_DELAY
  MOV CX,0H       ;DELAY
  MOV DX,1388H
  MOV AX,8600H
  INT 15H
  JMP END_DRAW_BALL 
  CHANGE_DELAY:
  MOV CX,0H       ;DELAY
  MOV DX,1500H
  MOV AX,8600H
  INT 15H
  END_DRAW_BALL:
  ret
DrawBall endp
    
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;PROCEDURE3  

DeleteBall proc
 mov si,y_draw_ball
    
  mov di,x_draw_ball
  sub di,5

  mov cx,di
  mov dx,si  
  mov al,0h
  mov ah,0ch  
  
  add di,10
  
back2_delete:int 10h   
  inc cx
  cmp cx,di 
  jnz back2_delete
  
     ;;;;;;;;;;;;;;;;;;;;;;;;
  mov bx,10  
  mov di,x_draw_ball
  sub di,5
 lop2_delete: 
  mov ax,2 
  mov si,y_draw_ball
  inc si 
 
lop1_delete:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,0h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,2 
  dec ax
  cmp ax,0
  jnz lop1_delete 
  
  inc di
  dec bx 
  cmp bx,0
  jnz lop2_delete
    ;;;;;;;;;;;;;;;;;;;;
 
  
  mov bx,0008 
  mov di,x_draw_ball
  sub di,4
 lop22_delete: 
  mov ax,2 
  mov si,y_draw_ball
  add si,2 
 
lop11_delete:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,0h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,4 
  dec ax
  cmp ax,0
  jnz lop11_delete 
  
  inc di
  dec bx 
  cmp bx,0
  jnz lop22_delete
  
    ;;;;;;;;;;;;;;;;;;;;
  
  mov bx,0008 
  mov di,x_draw_ball
  sub di,4
 lop222_delete: 
  mov ax,2 
  mov si,y_draw_ball
  add si,3 
 
lop111_delete:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,0h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,6 
  dec ax
  cmp ax,0
  jnz lop111_delete 
  
  inc di
  dec bx 
  cmp bx,0
  jnz lop222_delete 
  ;;;;;;;;;;;;;;;;;
  
  mov bx,0006 
  mov di,x_draw_ball
  sub di,3
 lop2222_delete: 
  mov ax,2 
  mov si,y_draw_ball
  add si,4 
 
lop1111_delete:  
  push ax
  mov cx,di
  mov dx,si  
  mov al,0h
  mov ah,0ch  
  int 10h 
  pop ax 
  sub si,8 
  dec ax
  cmp ax,0
  jnz lop1111_delete 
  
  inc di
  dec bx 
  cmp bx,0
  jnz lop2222_delete 
  ret
DeleteBall endp
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------
    ;--------------------------

    DrawNet proc    
       ;4 pixels wide 
       push ax
       PUSH BX
       push cx
       push dx
       MOV CX,00H
       MOV DX,320
       MOV BX,0
       mov al,0Fh ;White
       mov ah,0ch ;Draw Pixel Command 
 gameground:
       int 10h
       inc cx
       cmp cx,640
       jnz gameground
       
       mov cx,317
       mov dx,319
       mov al,0Eh ;Yellow
       
 netsides: int 10h    ;Draw two vertical lines
       add cx,4
       int 10h
       sub cx,4
       dec dx
       cmp dx,239
       jnz netsides
netceil: int 10h    ;Draw the top of net
       inc cx
       cmp cx,321
       jnz netceil                               
       pop dx                                                  
       pop cx
       POP BX                                                  
       pop ax                                                  
    ret                                      
DrawNet endp                                 
        ;------------------------------------------------
        ;------------------------------------------------                                     
DrawBasket1 proc                              
       ;40 pixels wide                           
       ;40 pixels high
       
       push ax
       push bx
       push cx
       push dx 
       
        
       mov cx,basketX1     ;player 1 position 
       mov al,Color1          ;sets color to white
       push cx
       
       mov dx,279 ;Y always starts from here
       mov bx,40  ;width
       mov ah,0ch ;Draw Pixel Command
 ceil1: int 10h 
       inc cx
       sub bx,1
       jnz ceil1
       
             
             mov bx,10
rhorizontal1: push bx         ;draws right side
             mov bx,4
rvertical1:   inc dx          ;draws 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz rvertical1
             dec cx
             pop bx
             sub bx,1
             jnz rhorizontal1
             dec cx                                    
      
       mov bx,20
floor1: int 10h 
       dec cx
       sub bx,1
       jnz floor1 
       
             mov bx,10
lhorizontal1: push bx          ;draws left side
             mov bx,4
lvertical1:   dec dx           ;draws 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz lvertical1
             dec cx
             pop bx
             sub bx,1
             jnz lhorizontal1
  
             pop cx
             mov dx,279
             add cx,8
  smallline1: int 10h          ;small lines in net
             inc dx
             add cx,24
             int 10h
             sub cx,24
             cmp dx,311
             jnz smallline1                                 
                      
             add cx,8
             mov dx,279
  largeline1: int 10h          ;tall lines in net
             inc dx
             add cx,8
             int 10h
             sub cx,8
             cmp dx,319
             jnz largeline1         
             
             pop dx
             pop cx
             pop bx
             pop ax         
                                               
    ret                                        
DrawBasket1 endp
         ;------------------------------------------------
         ;------------------------------------------------
DrawBasket2 proc                              
       ;40 pixels wide                           
       ;40 pixels high
       
       push ax
       push bx
       push cx
       push dx 
       
        
       mov cx,basketX2     ;player 2 position 
       mov al,Color2          ;sets color to green
       push cx
       
       mov dx,279 ;Y always starts from here
       mov bx,40  ;width
       mov ah,0ch ;Draw Pixel Command
 ceil2: int 10h 
       inc cx
       sub bx,1
       jnz ceil2
       
             
             mov bx,10
rhorizontal2: push bx         ;draws right side
             mov bx,4
rvertical2:   inc dx          ;draws 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz rvertical2
             dec cx
             pop bx
             sub bx,1
             jnz rhorizontal2
             dec cx                                    
      
       mov bx,20
floor2: int 10h 
       dec cx
       sub bx,1
       jnz floor2 
       
             mov bx,10
lhorizontal2: push bx          ;draws left side
             mov bx,4
lvertical2:   dec dx           ;draws 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz lvertical2
             dec cx
             pop bx
             sub bx,1
             jnz lhorizontal2
  
             pop cx
             mov dx,279
             add cx,8
  smallline2: int 10h          ;small lines in net
             inc dx
             add cx,24
             int 10h
             sub cx,24
             cmp dx,311
             jnz smallline2                                 
                      
             add cx,8
             mov dx,279
  largeline2: int 10h          ;tall lines in net
             inc dx
             add cx,8
             int 10h
             sub cx,8
             cmp dx,319
             jnz largeline2         
             
             pop dx
             pop cx
             pop bx
             pop ax         
                                               
    ret                                        
DrawBasket2 endp
         ;------------------------------------------------
         ;------------------------------------------------
DeleteBasket1 proc                              
       ;40 pixels wide                           
       ;40 pixels high
       
       push ax
       push bx
       push cx
       push dx 
       
         
       mov cx,basketX1     ;if one gets player 1 position 
       push cx
       mov al,00h ;sets colour to black
       mov dx,279 ;Y always starts from here
       mov bx,40  ;width
       mov ah,0ch ;Draw Pixel Command
 dceil1:int 10h 
       inc cx
       sub bx,1
       jnz dceil1
       
             
             mov bx,10
drhorizontal1:push bx         ;delete right side
             mov bx,4
drvertical1:  inc dx          ;delete 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz drvertical1
             dec cx
             pop bx
             sub bx,1
             jnz drhorizontal1
             dec cx                                    
      
       mov bx,20
dfloor1:int 10h 
       dec cx
       sub bx,1
       jnz dfloor1 
       
             mov bx,10
dlhorizontal1:push bx          ;delete left side
             mov bx,4
dlvertical1:  dec dx           ;delete 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz dlvertical1
             dec cx
             pop bx
             sub bx,1
             jnz dlhorizontal1
  
             pop cx
             mov dx,279
             add cx,8
 dsmallline1: int 10h          ;small lines in net
             inc dx
             add cx,24
             int 10h
             sub cx,24
             cmp dx,311
             jnz dsmallline1                                 
                      
             add cx,8
             mov dx,279
 dlargeline1: int 10h          ;tall lines in net
             inc dx
             add cx,8
             int 10h
             sub cx,8
             cmp dx,319
             jnz dlargeline1         
             
             pop dx
             pop cx
             pop bx
             pop ax         
                                               
    ret                                        
DeleteBasket1 endp
          ;------------------------------------------------
          ;------------------------------------------------
DeleteBasket2 proc                              
       ;40 pixels wide                           
       ;40 pixels high
       
       push ax
       push bx
       push cx
       push dx 
       
         
       mov cx,basketX2     ;if one gets player 1 position 
       push cx
       mov al,00h ;sets colour to black
       mov dx,279 ;Y always starts from here
       mov bx,40  ;width
       mov ah,0ch ;Draw Pixel Command
 dceil2:int 10h 
       inc cx
       sub bx,1
       jnz dceil2
       
             
             mov bx,10
drhorizontal2:push bx         ;delete right side
             mov bx,4
drvertical2:  inc dx          ;delete 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz drvertical2
             dec cx
             pop bx
             sub bx,1
             jnz drhorizontal2
             dec cx                                    
      
       mov bx,20
dfloor2:int 10h 
       dec cx
       sub bx,1
       jnz dfloor2 
       
             mov bx,10
dlhorizontal2:push bx          ;delete left side
             mov bx,4
dlvertical2:  dec dx           ;delete 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz dlvertical2
             dec cx
             pop bx
             sub bx,1
             jnz dlhorizontal2
  
             pop cx
             mov dx,279
             add cx,8
 dsmallline2: int 10h          ;small lines in net
             inc dx
             add cx,24
             int 10h
             sub cx,24
             cmp dx,311
             jnz dsmallline2                                 
                      
             add cx,8
             mov dx,279
 dlargeline2: int 10h          ;tall lines in net
             inc dx
             add cx,8
             int 10h
             sub cx,8
             cmp dx,319
             jnz dlargeline2         
             
             pop dx
             pop cx
             pop bx
             pop ax         
                                               
    ret                                        
DeleteBasket2 endp
            ;------------------------------------------------
            ;------------------------------------------------
MoveBasket1Right proc 
             push ax
             push bx
             push cx
             push si
             
             mov ah,0
             mov al,SpeedPlayer1     ;checks if there is power up
             cmp al,0
             je mrNoMore1            ;if freeze returns
             cmp al,1
             je mrNormal1
             mov al,20               ;if fast inc 20
             jmp mrFast1
   mrNormal1:mov al,10               ;if normal inc 10
     mrFast1:         
             lea si,basketX1
             mov bx,599
             mov cx,basketX1     ;gets player 1 position
             sub bx,cx           ;gets the diff between basket and right wall
             cmp bx,ax           ;if distance less than 10 or 20
             jb mrcheck1
             
             
             call DeleteBasket1
             add cx,ax              ;inc location
             mov [si],cx
             call DrawBasket1
             jmp mrNoMore1 
             
    mrcheck1:cmp bx,0               ;if 0 ret
             je mrNoMore1
             call DeleteBasket1
             add cx,bx              ;inc location by remaining distance
             mov [si],cx
             call DrawBasket1
             
   mrNoMore1:                  ;move right no more
             pop si
             pop cx
             pop bx
             pop ax
    ret
MoveBasket1Right endp
            
            ;------------------------------------------------
            ;------------------------------------------------
MoveBasket2Right proc
             push ax
             push bx
             push cx
             push si
             
             mov ah,0
             mov al,SpeedPlayer2     ;checks if there is power up
             cmp al,0
             je mrNoMore2            ;if freeze returns
             cmp al,1
             je mrNormal2
             mov al,20               ;if fast inc 20
             jmp mrFast2
   mrNormal2:mov al,10               ;if normal inc 10
     mrFast2:
             
             lea si,basketX2
             mov bx,276
             mov cx,basketX2     ;gets player 2 position
             sub bx,cx           ;gets the diff between basket and right wall
             cmp bx,ax           ;if distance less than 10 or 20
             jb mrcheck2
                                  
             call DeleteBasket2
             add cx,ax              ;inc location
             mov [si],cx
             call DrawBasket2 
             jmp mrNoMore2 
             
    mrcheck2:cmp bx,0               ;if 0 ret
             je mrNoMore2
             call DeleteBasket2
             add cx,bx              ;inc location by remaining distance
             mov [si],cx
             call DrawBasket2
    mrNoMore2:                   ;move right no more
             pop si
             pop cx 
             pop bx
             pop ax
    ret
MoveBasket2Right endp
            ;------------------------------------------------
            ;------------------------------------------------
MoveBasket1Left proc
             push ax
             push dx
             push bx
             push cx
             push si
             
             mov ah,0
             mov al,SpeedPlayer1     ;checks if there is power up
             cmp al,0
             je mlNoMore1            ;if freeze returns
             cmp al,1
             je mlNormal1
             mov al,20               ;if fast inc 20
             jmp mlFast1
   mlNormal1:mov al,10               ;if normal inc 10
     mlFast1:
             
             lea si,basketX1
             mov bx,322
             mov cx,basketX1     ;gets player 1 position
             mov dx,basketX1
             sub dx,bx           ;gets the diff between basket and left wall
             cmp dx,ax           ;if distance less than 10 or 20
             jb mlcheck1
             
             call DeleteBasket1
             sub cx,ax              ;dec location
             mov [si],cx
             call DrawBasket1
             jmp mlNoMore1
             
    mlcheck1:cmp dx,0               ;if 0 ret
             je mlNoMore1
             call DeleteBasket1
             sub cx,dx              ;dec location by remaining distance
             mov [si],cx
             call DrawBasket1        
             
     mlNoMore1:                  ;move left no more
             
             pop si
             pop cx
             pop bx
             pop dx
             pop ax                    
    ret
MoveBasket1Left endp
           ;------------------------------------------------
           ;------------------------------------------------
MoveBasket2Left proc
             push ax
             push dx
             push cx
             push si
             
             mov ah,0
             mov al,SpeedPlayer2     ;checks if there is power up
             cmp al,0
             je mlNoMore2            ;if freeze returns
             cmp al,1
             je mlNormal2
             mov al,20               ;if fast inc 20
             jmp mlFast2
   mlNormal2:mov al,10               ;if normal inc 10
     mlFast2:
             
             lea si,basketX2
             mov cx,basketX2     ;gets player 2 position
             mov dx,basketX2
             cmp dx,ax           ;if distance less than 10 or 20
             jb mlcheck2
                                   
             call DeleteBasket2
             sub cx,ax              ;dec location
             mov [si],cx
             call DrawBasket2 
             jmp mlNoMore2
             
    mlcheck2:cmp dx,0               ;if 0 ret
             je mlNoMore2
             call DeleteBasket2
             sub cx,dx              ;dec location by remaining distance
             mov [si],cx
             call DrawBasket2
             
      mlNoMore2:                  ;move left no more
             
             pop si
             pop cx
             pop dx
             pop ax                    
    ret
MoveBasket2Left endp
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------ 
Drawscorebar proc
PUSH AX
PUSH BX
PUSH CX
PUSH DX                      
mov ah,2                      ;set cursor of player2
mov dh,23                     
mov dl,7
MOV BX,0
int 10h 

mov ah,9                      ;display player2
mov dx,offset Player2_name+2  
int 21h 

mov al,7                      ;set cursor of hearts
add al,Player2_name+1         ;moving cursor according to number
mov ah,2                      ;of characters in name
mov dh,23
mov dl,al
int 10h

mov ah,2
mov dl,':'
int 21h

mov al,8
add al,Player2_name+1
mov ah,2
mov dh,23
mov dl,al
int 10h

mov ax,score2                ;display hearts(lives)
cmp ax,0
je heart1end
heartinit: 
push ax
mov ah,2
mov dl,03h
int 21h
pop ax

dec ax
cmp ax,0
jnz heartinit
heart1end:
                               ;set cursor of player1
mov ah,2
mov dh,23
mov dl,55
int 10h

mov ah,9
mov dx,offset Player1_name+2   ;display player1
int 21h 

mov al,55                      ;set cursor of hearts
add al,Player1_name+1          ;moving cursor according to number
mov ah,2                       ;of characters in name
mov dh,23
mov dl,al
int 10h

mov ah,2
mov dl,':'
int 21h

mov al,56
add al,Player1_name+1
mov ah,2
mov dh,23
mov dl,al
int 10h

mov ax,score1                ;display hearts(lives)
cmp ax,0
je heart2end
heartinit2: 
push ax
mov ah,2
mov dl,03h
int 21h
pop ax

dec ax
cmp ax,0
jnz heartinit2  
heart2end:

POP DX
POP CX
POP BX
POP AX

ret
Drawscorebar endp 
        
SCORE_LEVEL2 PROC
    CMP THROW_FLAG,1
    JNE DONT_DRAW2
    CMP X_COORDINATE,312
    JL DONT_DRAW2
    CMP X_COORDINATE,324
    JG DONT_DRAW2
    
    
    
    CALL SCOREUPDATE
    MOV Y_COORDINATE,274
    CALL DRAWNET
    DONT_DRAW2:
    RET
SCORE_LEVEL2 ENDP            

    
scoreupdate proc

MOV THROW_FLAG,0    
mov ax,X_DRAW_BALL
mov dx,player
cmp dx,1           ;if player1
jE player2         ;updates for player2
CMP P2UP,3
JNE SCORE_CONTINUE1
MOV P2UP,0
SCORE_CONTINUE1:         
MOV PLAYER,1
mov bx,basketx1 
lea di,score1
jmp sdone
player2:
CMP P1UP,3
JNE SCORE_CONTINUE2
MOV P1UP,0
SCORE_CONTINUE2:
MOV PLAYER,2 
mov bx,basketx2 
lea di,score2

                        
sdone:
CMP PLAYER,2
JE PLAYER2_SS
CMP AX,324
JA CONTINUE_SDONE
DEC SCORE2
JMP CHECK_END
PLAYER2_SS:
CMP AX,317
JB CONTINUE_SDONE
DEC SCORE1
JMP CHECK_END

CONTINUE_SDONE:
cmp ax,bx          ;if xBall below xBasket 
jb outt            ;the ball is out
add bx,40          ;right side of basket
cmp ax,bx          ;if xBall above xBasket
ja outt            ;the ball is out

jmp inbasket       ;else in basket


outt:
mov ax,[di]        ;if out decrement the score
dec ax
mov [di],ax

CMP PLAYER,2
JE P2UP_RESET
MOV P1UP,0
JMP CHECK_END
P2UP_RESET:
MOV P2UP,0

CHECK_END:
CMP SCORE1,0           ;if score is zero
JNE CHECK_END2      ;TERMINATE SCORE COUNT
;ELSE SET THE FLAG END THE WHOLE GAME
MOV ENDGAME,1
CALL CHECK_WINNER  ;PRINTS WINNER
JMP DONT_DRAW

CHECK_END2:
CMP SCORE2,0           ;if score is zero
JNE TERMINATE      ;TERMINATE SCORE COUNT
;ELSE SET THE FLAG END THE WHOLE GAME
MOV ENDGAME,1
CALL CHECK_WINNER  ;PRINTS WINNER
JMP DONT_DRAW

inbasket:
CMP PLAYER,2
JE P2POWER
INC P1UP
JMP TERMINATE
P2POWER:
INC P2UP 

TERMINATE:
MOV AL,012H
MOV AH,00H
INT 10H 
call DRAW_GUI
DONT_DRAW:
ret
scoreupdate endp  
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------

DRAW_GUI PROC 
    push ax
    
    MOV AH,0           ;CHOOSING VIDEO MODE
    MOV AL,12H         ;80 X 30
    INT 10H
    
    CALL DRAWBASKET1
    CALL DRAWBASKET2
    CALL DRAWNET
    CALL Drawscorebar
    cmp score1,0
    je endDrawGui
    cmp score2,0
    jne notendDrawGui 
    endDrawGui:
    MOV ENDGAME,1
    call CHECK_WINNER
    
    
    notendDrawGui:
    
    pop ax
    RET
DRAW_GUI ENDP
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------ 
PlayerNames proc 
    push ax
    push cx
    push dx
    push si 
    
    CMP MY_PLAYER,2
    JE TONAME2
    
    mov ah,2            ;set cursor
    mov dx,0a20h
    int 10h
    
    mov ah,9             ;display enter name
    mov dx,offset Name1Mess
    int 21h
    
    lea si,Player1_name
    add si,2
    mov cx,15
    player1name:
    mov ah,00
    int 16h
    cmp ax,1C0Dh
    je name1done
    cmp al,32
    je name1good
    cmp al,65
    jb player1name
    cmp al,122
    ja player1name
    cmp al,96
    ja name1good
    cmp al,90
    ja player1name
    name1good:
    mov [si],al
    mov ah,2
    mov dl,al
    int 21h
    inc si
    loop player1name
    name1done:
    mov al,15
    sub al,cl
    mov Player1_name[1],al

    cmp cx,15
    jne TOSENDING_NAME1
    mov Player1_name[1],2
    mov Player1_name[2],80
    mov Player1_name[3],49  
    
    ;------SENDING NAME1
     
    TOSENDING_NAME1:
    MOV CL,Player1_name[1]       ;SENDING COUNT OF LETTERS
    MOV BYTE PTR SEND_VALUE,CL 
    CALL SEND_DATA 
    
    MOV CX,0
    LEA SI,PLAYER1_NAME[2] 
    MOV CL,Player1_name[1]
    SENDING_NAME1:
    MOV AL,[SI]
    MOV BYTE PTR SEND_VALUE,AL
    CALL SEND_DATA 
    INC SI
    LOOP SENDING_NAME1
    
    JMP TONAME1
    ;------
    
    toname2:

    mov ah,0           
    mov al,12h           ;video mode
    int 10h
    
    mov ah,2
    mov dx,0a20h         ;set cursor
    int 10h  
    
    mov ah,9
    mov dx,offset Name2Mess    ;display enter name
    int 21h
    
    lea si,Player2_name
    add si,2
    mov cx,15
    player2name:
    mov ah,00
    int 16h
    cmp ax,1C0Dh
    je name2done
    cmp al,32
    je name2good
    cmp al,65
    jb player2name
    cmp al,122
    ja player2name
    cmp al,96
    ja name2good
    cmp al,90
    ja player2name
    name2good:
    mov [si],al
    mov ah,2
    mov dl,al
    int 21h
    inc si
    loop player2name
    name2done:
    mov al,15
    sub al,cl
    mov Player2_name[1],al 

    cmp cx,15
    jne TOSENDING_NAME2
    mov Player2_name[1],2
    mov Player2_name[2],80
    mov Player2_name[3],50
     
    ;------SENDING NAME2
     
    TOSENDING_NAME2:
    MOV CL,Player2_name[1]       ;SENDING COUNT OF LETTERS
    MOV BYTE PTR SEND_VALUE,CL 
    CALL SEND_DATA 
    
    MOV CX,0
    MOV CL,Player2_name[1]
    LEA SI,PLAYER2_NAME[2]
    SENDING_NAME2:
    MOV AL,[SI]
    MOV BYTE PTR SEND_VALUE,AL
    CALL SEND_DATA  
    INC SI
    LOOP SENDING_NAME2
    
    ;------
    
    toname1:
    
    pop si
    pop dx
    pop cx
    pop ax
ret 
PlayerNames endp  
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------
        ;------------------------------------------------
THROW_ZIGZAG PROC 
    CMP THROW_FLAG,1
    JNE ASSIST_FINISH_THROW_ZIGZAG
    MOV RADIUS_LENGTH,160
    MOV RADIUS_SQUARED,25600
    ;--------------------------
    ;--------------------------
    CMP ZIGZAG_COUNTER,120
    JLE COUNTINUE_ZIGZAG_THROW
    MOV ZIGZAG_COUNTER,0
    ;--------------------------
    ;--------------------------
    ;CHECK THE SCREEN LEFT EDGE
    COUNTINUE_ZIGZAG_THROW:
    CMP X_COORDINATE,5
    JG PASS1
    INC X_COORDINATE
    ;--------------------------
    ;CHECK THE RIGHT SCREEN EDGE
    PASS1:
    CMP X_COORDINATE,635
    JL PASS2
    DEC X_COORDINATE
    ;--------------------------
    PASS2:
    ;MOV THE BALL
    MOV CX,X_COORDINATE
    MOV DX,Y_COORDINATE
    MOV X_DRAW_BALL,CX
    MOV Y_DRAW_BALL,DX
    CALL DRAWBALL    
    CALL DELETEBALL
    ;--------------------------
    ;--------------------------
    CMP PLAYER,2                 ;IF PLAYER 2 START AT PLAYER 2
    JE PLAYER2_ZIGZAG
    ;--------------------------
    ;--------------------------
    ;PLAYER 1
    
    ;DETERMINE THE HALF OF THE THROW
    CMP CURRENT_X,0              ;CHECK IF THE BALL REACHED PEAK (HALF WAY)
    JL  SECOND_ZIGZAG_HALF1
    ;--------------------------
    ;--------------------------
    ;FIRST HALF
    CMP ZIGZAG_COUNTER,60
    JG  HORIZONTAL1
    ;GO VERTICAL UP
    INC CURRENT_Y
    DEC Y_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    ;GO HORIZONTAL LEFT
    HORIZONTAL1:
    DEC CURRENT_X
    DEC X_COORDINATE
    ASSIST_FINISH_THROW_ZIGZAG:
    JMP FINISH_THROW_ZIGZAG
    ;--------------------------
    ;--------------------------
    ;SECOND HALF
    SECOND_ZIGZAG_HALF1:
    CMP ZIGZAG_COUNTER,60
    JL  HORIZONTAL2
    ;VERTICAL DOWN
    DEC CURRENT_Y
    INC Y_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    ;GO HORIZONTAL LEF
    HORIZONTAL2:
    DEC CURRENT_X
    DEC X_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    ;--------------------------
    ;--------------------------
    PLAYER2_ZIGZAG:
    ;PLAYER2 SAME AS PLAYER 1 BUT MORRIORED ON Y-AXIS
    
    ;DETERMINE THE HALF OF THE THROW
    CMP CURRENT_X,0
    JG  SECOND_ZIGZAG_HALF2
    ;--------------------------
    ;--------------------------
    ;FIRST HALF
    CMP ZIGZAG_COUNTER,60
    JG  HORIZONTAL3
    ;VERTICAL
    INC CURRENT_Y
    DEC Y_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    HORIZONTAL3:
    INC CURRENT_X
    INC X_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    ;--------------------------
    ;--------------------------
    ;SECOND HALF
    SECOND_ZIGZAG_HALF2:
    CMP ZIGZAG_COUNTER,60
    JL  HORIZONTAL4
    ;VERTICAL
    DEC CURRENT_Y
    INC Y_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    HORIZONTAL4:
    INC CURRENT_X
    INC X_COORDINATE
    JMP FINISH_THROW_ZIGZAG
    ;--------------------------
    ;--------------------------
    FINISH_THROW_ZIGZAG:
    INC ZIGZAG_COUNTER
    RET    
THROW_ZIGZAG ENDP

CHECK_WINNER PROC
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX 

    MOV AX,00H    
    MOV BX,00H    
    MOV AH,2               ;SETTING CURSOR
    MOV DH,27
    MOV DL,33
    INT 10H
    
    MOV AH,9               ;DISPLAYING (WINNER IS )
    MOV DX,OFFSET WINNER   
    INT 21H 
    
    CMP SCORE1,0
    JNE TWO_LOSE
    MOV DX,OFFSET PLAYER2_NAME+2             ;PLAYER 2 WINS
    JMP DONE_WINNER            
    TWO_LOSE:
    MOV DX,OFFSET PLAYER1_NAME+2             ;PLAYER 1 WINS
    DONE_WINNER:
    
    MOV AH,9               ;DISPLAYING WINNER NAME   
    INT 21H
    
    MOV CX,2DH             ;DELAY
    MOV DX,0C6C0H
    MOV AX,8600H
    INT 15H
    
    POP DX
    POP CX
    POP BX
    POP AX
       
    RET
CHECK_WINNER ENDP


DrawSquare proc    
              push bx  
              mov bh,10
      square:
              mov bl,10      
        line: push bx
			  mov bx,0
              int 10h
			  pop bx
              inc cx
              sub bl,1
              jnz line
              
              sub cx,10
              inc dx 
              
              sub bh,1
              jnz square   
              pop bx                           
    ret                                      
DrawSquare endp                                 
                                             
DrawMenu  proc
              mov al,1   ;Pixel color
              mov cx,150 ;Column
              mov dx,200 ;Row          
              mov ah,0ch ;Draw Pixel Command 
                    
              mov bl,5
        line1:    
              call DrawSquare 
              add cx,30
              sub dx,10
              inc al
              sub bl,1
              jnz line1
			  
              mov bl,5
			  sub cx,150
			  add dx,30
        line2:    
              call DrawSquare       
              add cx,30
              sub dx,10
              inc al      
              sub bl,1
              jnz line2
    ret
DrawMenu  endp

DrawBasketColor proc                              
       ;40 pixels wide                           
       ;40 pixels high
       
       push ax
       push bx
       push cx
       push dx 
       
        
       mov cx,330     ;player 1 position 
      ;mov al,1          ;sets color to white
       push cx
       
       mov dx,200 ;Y always starts from here
       mov bx,40  ;width
       mov ah,0ch ;Draw Pixel Command
 Cceil1: int 10h 
       inc cx
       sub bx,1
       jnz Cceil1
       
             
             mov bx,10
Crhorizontal1: push bx         ;draws right side
             mov bx,4
Crvertical1:   inc dx          ;draws 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz Crvertical1
             dec cx
             pop bx
             sub bx,1
             jnz Crhorizontal1
             dec cx                                    
      
       mov bx,20
Cfloor1: int 10h 
       dec cx
       sub bx,1
       jnz Cfloor1 
       
             mov bx,10
Clhorizontal1: push bx          ;draws left side
             mov bx,4
Clvertical1:   dec dx           ;draws 4 vertical pixels then shift one
             int 10h
             sub bx,1
             jnz Clvertical1
             dec cx
             pop bx
             sub bx,1
             jnz Clhorizontal1
  
             pop cx
             mov dx,200
             add cx,8
  Csmallline1: int 10h          ;small lines in net
             inc dx
             add cx,24
             int 10h
             sub cx,24
             cmp dx,232
             jnz Csmallline1                                 
                      
             add cx,8
             mov dx,200
  Clargeline1: int 10h          ;tall lines in net
             inc dx
             add cx,8
             int 10h
             sub cx,8
             cmp dx,240
             jnz Clargeline1         
             
             pop dx
             pop cx
             pop bx
             pop ax         
                                               
    ret                                        
DrawBasketColor endp


SquareFrame proc
      
	         mov cx,FrameX
			 mov dx,FrameY
			 mov ah,0ch ;Draw Pixel Command
			 mov al,0Fh  ;white color
			 mov bl,11
			
  CielFrame: push bx
             mov bx,0
             int 10h
			 add dx,11
			 int 10h
			 sub dx,11
             pop bx
			 inc cx
			 sub bl,1
			 jnz CielFrame
             
			 int 10h
			 add dx,11
			 int 10h
			 sub dx,11
			 
             mov bl,11			 
   SideFrame: push bx
             mov bx,0
             int 10h
			 sub cx,11
			 int 10h
			 add cx,11
             pop bx
			 inc dx
			 sub bl,1
			 jnz SideFrame		 

      ret
SquareFrame endp

DeleteSquareFrame proc
      
	         mov cx,FrameX
			 mov dx,FrameY
			 mov ah,0ch ;Draw Pixel Command
			 mov al,00h  ;black color
	 mov bl,11
			
  DCielFrame: push bx
             mov bx,0
             int 10h
			 add dx,11
			 int 10h
			 sub dx,11
             pop bx
			 inc cx
			 sub bl,1
			 jnz DCielFrame
             
			 int 10h
			 add dx,11
			 int 10h
			 sub dx,11
			 
             mov bl,11			 
   DSideFrame: push bx
             mov bx,0
             int 10h
			 sub cx,11
			 int 10h
			 add cx,11
             pop bx
			 inc dx
			 sub bl,1
			 jnz DSideFrame		 	 

      ret
DeleteSquareFrame endp

ChooseBasket1Color proc
                    
				    mov ah,2            ;set cursor
                    mov dx,0a16h
                    int 10h
                    mov ah,9             ;display enter name
                    mov dx,offset Name1Mess
                    int 21h      
                    mov FrameX,149
					mov FrameY,199
					call DrawMenu
					call SquareFrame
					mov al,1
					call DrawBasketColor	
          ColorMenu:
		            push ax
					MOV AH,0                   ;GET KEY
                    INT 16H
                    CMP AX,4D00H               ;IF RIGHT
                    JE COLOR_RIGHT
                    CMP AX,4B00H               ;IF LEFT
                    JE COLOR_LEFT
					CMP AX,4800H               ;IF UP
                    JE COLOR_UP
					CMP AX,5000H               ;IF DOWN
                    JE COLOR_DOWN
					CMP AX,1C0DH               ;IF ENTER
                    JE ASSIST_COLOR_ENTER
  AssistColorMenu:	jmp ColorMenu

  
		COLOR_RIGHT: 
		              cmp FrameX,269
					  pop ax
		              JE AssistColorMenu
					  push ax
					  call DeleteSquareFrame
					  add FrameX,30
					  call SquareFrame
					  pop ax
					  inc al
					  inc Color1
					  call DrawBasketColor
					  jmp ColorMenu
					  
ASSIST_COLOR_ENTER:   jmp COLOR_ENTER			  
					  
        COLOR_LEFT:
                      cmp FrameX,149
					  pop ax
		              JE AssistColorMenu
					  push ax
					  call DeleteSquareFrame
					  sub FrameX,30
					  call SquareFrame
					  pop ax
					  dec al
					  dec Color1
					  call DrawBasketColor
					  jmp ColorMenu
        COLOR_DOWN:
                      cmp FrameY,229
					  pop ax
		              JE AssistColorMenu
					  push ax
					  call DeleteSquareFrame
					  add FrameY,30
					  call SquareFrame
					  pop ax
					  add al,5
					  add Color1,5
					  call DrawBasketColor
					  jmp ColorMenu
        COLOR_UP:		
					  cmp FrameY,199
					  pop ax
		              JE AssistColorMenu
					  push ax
					  call DeleteSquareFrame
					  sub FrameY,30
					  call SquareFrame
					  pop ax
					  sub al,5
					  sub Color1,5
					  call DrawBasketColor
					  jmp ColorMenu
        COLOR_ENTER:  
                            
		       
				pop ax
				
          ret 
ChooseBasket1Color endp


ChooseBasket2Color proc

                    mov ah,2
                    mov dx,0a16h         ;set cursor
                    int 10h  
                    mov ah,9
                    mov dx,offset Name2Mess    ;display enter name
                    int 21h
            	    mov FrameX,149
					mov FrameY,199
					call DrawMenu
					call SquareFrame
					mov al,1
					call DrawBasketColor	
          ColorMenu2:
		            push ax
					MOV AH,0                   ;GET KEY
                    INT 16H
                    CMP AX,4D00H               ;IF RIGHT
                    JE COLOR_RIGHT2
                    CMP AX,4B00H               ;IF LEFT
                    JE COLOR_LEFT2
					CMP AX,4800H               ;IF UP
                    JE COLOR_UP2
					CMP AX,5000H               ;IF DOWN
                    JE COLOR_DOWN2
					CMP AX,1C0DH               ;IF ENTER
                    JE ASSIST_COLOR_ENTER2
  AssistColorMenu2:	jmp ColorMenu2

  
		COLOR_RIGHT2: 
		              cmp FrameX,269
					  pop ax
		              JE AssistColorMenu2
					  push ax
					  call DeleteSquareFrame
					  add FrameX,30
					  call SquareFrame
					  pop ax
					  inc al
					  inc Color2
					  call DrawBasketColor
					  jmp ColorMenu2
					  
ASSIST_COLOR_ENTER2:   jmp COLOR_ENTER2			  
					  
        COLOR_LEFT2:
                      cmp FrameX,149
					  pop ax
		              JE AssistColorMenu2
					  push ax
					  call DeleteSquareFrame
					  sub FrameX,30
					  call SquareFrame
					  pop ax
					  dec al
					  dec Color2
					  call DrawBasketColor
					  jmp ColorMenu2
        COLOR_DOWN2:
                      cmp FrameY,229
					  pop ax
		              JE AssistColorMenu2
					  push ax
					  call DeleteSquareFrame
					  add FrameY,30
					  call SquareFrame
					  pop ax
					  add al,5
					  add Color2,5
					  call DrawBasketColor
					  jmp ColorMenu2
        COLOR_UP2:		
					  cmp FrameY,199
					  pop ax
		              JE AssistColorMenu2
					  push ax
					  call DeleteSquareFrame
					  sub FrameY,30
					  call SquareFrame
					  pop ax
					  sub al,5
					  sub Color2,5
					  call DrawBasketColor
					  jmp ColorMenu2
        COLOR_ENTER2:        
		       
				pop ax
				
          ret 
ChooseBasket2Color endp
;------------------------------------------------
CheckCatchPowerUp proc
       
       push dx 
       
    cmp PowerupX,317       ;check player
    jb Player2PowerUp
	
	mov dx,basketX1
	cmp PowerupX,dx
	jb  assist_PowerUpOut
	add dx,40
	cmp PowerupX,dx
	ja  assist_PowerUpOut
	
	cmp PowerUpType,1 
	je SpeedPowerUp1
	cmp PowerUpType,2
	je FreezePowerUp1
	cmp PowerUpType,3  
	je LifePowerUp1
	cmp PowerUpType,4 
	je KillPowerUp1

SpeedPowerUp1: mov SpeedPlayer1,2
               ;mov SpeedPlayer2,1	
               jmp PowerUpOut
FreezePowerUp1:mov SpeedPlayer2,0
               ;mov SpeedPlayer1,1
               jmp PowerUpOut
LifePowerUp1:  ;increase player1 life
               cmp score1,5
               je  PowerUpOut
               inc score1  
               call DRAW_GUI
               jmp PowerUpOut
KillPowerUp1:  ;decrease player2 life 
               dec score2
               call DRAW_GUI 
               assist_PowerUpOut:
               jmp PowerUpOut
               
			   
Player2PowerUp:    

    mov dx,basketX2
	cmp PowerupX,dx
	jb  PowerUpOut
	add dx,40
	cmp PowerupX,dx
	ja  PowerUpOut
	
	cmp PowerUpType,1 
	je SpeedPowerUp2
	cmp PowerUpType,2
	je FreezePowerUp2
	cmp PowerUpType,3  
	je LifePowerUp2
	cmp PowerUpType,4 
	je KillPowerUp2

SpeedPowerUp2: mov SpeedPlayer2,2	
               ;mov SpeedPlayer1,1
               jmp PowerUpOut
FreezePowerUp2:mov SpeedPlayer1,0
               ;mov SpeedPlayer2,1
               jmp PowerUpOut
LifePowerUp2:  ;increase player2 life
               cmp score2,5
               je  PowerUpOut
               inc score2
               call DRAW_GUI
               jmp PowerUpOut
KillPowerUp2:  ;decrease player1 life
               dec score1
               call DRAW_GUI
                                   
PowerUpOut:   

    pop dx
    ret
CheckCatchPowerUp endp

PowerUpMovement proc 
push ax
push bx
push cx
push dx 
mov ax,0
mov bx,0
mov cx,0
mov dx,0 

CMP MY_PLAYER,2
JE  PLAYER2_PU_MOVE

cmp PowerUpFall,1   ;if there is no powerup falling
jne checktime       ;go see if it's time to powerup   

JMP PLAYER1_PU_MOVE 
               
checktime: 
CALL TEST_POWERUP                    
                    ;then initialize the powerup
mov dx,PowerUpY     ;initialize powerupY location

cmp PPUTurn,1        ;check player
je getplayer1x
call GetRandLoc2 
mov bX,RandomLoc2
jmp donelocation     
getplayer1x:
call GetRandLoc1  
mov bx,RandomLoc1
 
donelocation: 
mov PowerUpX,bx     ;PowerUpX location
mov PowerUpY,15

call GetRandomPU    ;choose random powerup
Mov ax,RandomPU
mov PowerUptype,ax  
;-------------------
;PLAYER1 SENDING
CMP POWERUPFALL,1
JNE assist2_MoveOut

MOV AL,BYTE PTR POWERUPFALL
MOV BYTE PTR SEND_VALUE,AL 
CALL SEND_DATA 

MOV CX,00H       ;DELAY
MOV DX,9000h
MOV AX,8600H
INT 15H

MOV AL,BYTE PTR POWERUPTYPE
MOV BYTE PTR SEND_VALUE,AL
CALL SEND_DATA

MOV AX,POWERUPX
MOV BYTE PTR SEND_VALUE,AH
CALL SEND_DATA
MOV BYTE PTR SEND_VALUE,AL
CALL SEND_DATA

;MOV AL,BYTE PTR POWERUPY
;MOV BYTE PTR SEND_VALUE,AL
;CALL SEND_DATA                                                      
                   
JMP PLAYER1_PU_MOVE 
;-------------------- 
assist2_MoveOut:
JMP assist_MoveOut
;--------------------
;PLAYER2 RECEIVING

PLAYER2_PU_MOVE:
  
CMP PUFALLCHANGED,1
JE PLAYER2_RECEIVING
cmp PowerUpFall,1        ;if there is no powerup falling move out
je PLAYER1_PU_MOVE      

JMP assist2_MoveOut


PLAYER2_RECEIVING:

MOV PowerUptype,0
MOV PUFALLCHANGED,0 
MOV POWERUPX,0

MOV RECEIVED_VALUE,6                ;receiving type
RECEIVE_PUTYPE:
CALL RECEIVE_DATA
CMP RECEIVED_VALUE,6
JE RECEIVE_PUTYPE 
MOV AX,RECEIVED_VALUE               
MOV PowerUptype,AX

MOV RECEIVED_VALUE,0FFFFH           ;receiving power up x
RECEIVE_PUX1:
CALL RECEIVE_DATA
CMP RECEIVED_VALUE,0FFFFH
JE RECEIVE_PUX1
MOV AX,0 
MOV AH,BYTE PTR RECEIVED_VALUE               

MOV RECEIVED_VALUE,0FFFFH           ;receiving power up x
RECEIVE_PUX2:
CALL RECEIVE_DATA
CMP RECEIVED_VALUE,0FFFFH
JE RECEIVE_PUX2 
MOV AL,BYTE PTR RECEIVED_VALUE               
MOV PowerUpX,AX

MOV PowerUpY,15                     ;setting power up y

MOV SPEEDPLAYER1,1
MOV SPEEDPLAYER2,1

PLAYER1_PU_MOVE:

CMP POWERUPFALL,0                   ;comparing to see which type
JE assist_MoveOut  
cmp PowerUptype,1
je MoveSpeed
cmp PowerUptype,2
je MoveFreeze
cmp PowerUptype,3
je assist_MoveLife
cmp PowerUptype,4
je MoveKill 


;-----------------
MoveSpeed:
mov dx,PowerUpY 
cmp dx,278          ;check if powerup reached basket
je reachingbasket   
call drawspeed
call deletespeed 

jmp ContinueFall 

assist_MoveLife:
jmp MoveLife
assist_MoveOut:
jmp Moveout
;------------------
MoveFreeze:
mov dx,PowerUpY 
cmp dx,273
je reachingbasket
call drawfreeze
call deletefreeze 

jmp ContinueFall

assist_MoveKill:
jmp MoveKill
 
;------------------ 
MoveLife:
mov dx,PowerUpY
cmp dx,272    
je reachingbasket
call drawlife
call deletelife

jmp ContinueFall 


 
;------------------ 
MoveKill:
mov dx,PowerUpY
cmp dx,276
je reachingbasket
call drawkill
call deletekill

;------------------
ContinueFall:
inc dx
mov PowerUpY,dx 
 
mov PowerUpFall,1 
jmp moveout
reachingbasket:
call CheckCatchPowerUp   

mov PowerUpfall,0

cmp  PPUTurn,1
je switchturn 
mov PPUTurn,1
jmp moveout
switchturn:
mov PPUTurn,2 

moveout:
MOV SEND_VALUE,0
MOV RECEIVED_VALUE,0  

pop dx
pop cx
pop bx
pop ax

ret
PowerUpMovement endp
;---------------------------
;---------------------------
                            
;--------------------------------------------
;POWERUP TIME PROCEDURES
GET_TIME PROC
    
    mov ah,0
    int 1ah                        ;clock service
    MOV CURRENT_TIME,DH
    
    RET
GET_TIME ENDP

POWERUP_COUNT PROC
    
    MOV AL,CURRENT_TIME
    SUB AL,START_TIME
    CMP AL,1
    JNE NO_POWERUP
    
    INC POWERUP_COUNTER
    JMP FINISH_P_COUNT
    
    NO_POWERUP:
    MOV POWERUPFALL,0
    
    FINISH_P_COUNT:
    RET
POWERUP_COUNT ENDP

POWERUP_CHECK PROC
    
    CMP POWERUP_COUNTER,2
    JNE FINISH_P_CHECK
    
    MOV POWERUP_COUNTER,0
    MOV POWERUPFALL,1
    MOV SPEEDPLAYER1,1
    MOV SPEEDPLAYER2,1
    CALL GET_TIME
    MOV AL,CURRENT_TIME
    MOV START_TIME,AL
    
    FINISH_P_CHECK:
    RET
POWERUP_CHECK ENDP

;--------------------------------------------    

TEST_POWERUP PROC
    
    CALL GET_TIME
    
    CMP POWERUPFALL,1
    JNE CHECK_POWER
    JMP JUMP_OUT
    
    CHECK_POWER:
    CALL POWERUP_COUNT
    CALL POWERUP_CHECK
    
    JUMP_OUT:
    RET
TEST_POWERUP ENDP                            
;---------------------------
GetRandomPU proc 
push ax
push cx
push dx    

RAND:
mov dh,0    
mov ah,0
int 1ah
mov cx,5                     ;to get max 4 types
mov ax,dx
xor dx,dx
div cx

CMP DX,0                     ;if zero ignore
JE RAND
mov RandomPU,dx

pop dx
pop cx
pop ax
ret
GetRandomPU endp

;---------------------------
;---------------------------

GetRandLoc1 proc               ;random loc for player1

push ax
push cx
push dx    

mov dh,0    
mov ah,0
int 1ah
mov cx,290
mov ax,dx
xor dx,dx
div cx

add dx,330
mov RandomLoc1,dx

pop dx
pop cx
pop ax


ret
GetRandLoc1 endp 
    
;---------------------------
;---------------------------
 
GetRandLoc2 proc             ;random loc for player2

push ax
push cx
push dx    

mov dh,0    
mov ah,0
int 1ah
mov cx,290
mov ax,dx
xor dx,dx
div cx

add dx,10
mov RandomLoc2,dx

pop dx
pop cx
pop ax


ret
GetRandLoc2 endp 
;-----------------------------
;-----------------------------
;drawing power ups
DrawSpeed proc 
push ax
push bx
push cx
push dx    
    
    
mov cx,PowerUpX
mov dx,PowerUpY
mov bx,cx
add bx,6
mov al,0eh
mov ah,0ch
b1drawspeed:
push bx
mov bx,0
int 10h 
pop bx
inc cx
dec dx
cmp cx,bx
jnz b1drawspeed 

mov bx,dx
add bx,4
b2drawspeed:
push bx
mov bx,0
int 10h 
pop bx
inc dx
cmp dx,bx
jnz b2drawspeed

 
mov bx,cx
add bx,6
b3drawspeed:
push bx
mov bx,0
int 10h 
pop bx
inc cx
dec dx
cmp cx,bx
jnz b3drawspeed

;-------------------------delays
 CMP THROW_FLAG,1
 JE DONT_DELAY6
 MOV CX,00H       ;DELAY
   MOV DX,2710h
 MOV AX,8600H
 INT 15H
 JMP END_DRAW6
  
  DONT_DELAY6:
  MOV CX,00H       ;DELAY
  MOV DX,0BB8h
  MOV AX,8600H
  INT 15H
  END_DRAW6:  
pop dx
pop cx
pop bx
pop ax
  
 ret  
DrawSpeed endp 

DeleteSpeed proc 
push ax
push bx
push cx
push dx    
    
    
mov cx,PowerUpX
mov dx,PowerUpY
mov bx,cx
add bx,6
mov al,00
mov ah,0ch
b1deletespeed:
push bx
mov bx,0
int 10h 
pop bx
inc cx
dec dx
cmp cx,bx
jnz b1deletespeed 

mov bx,dx
add bx,4
b2deletespeed:
push bx
mov bx,0
int 10h 
pop bx
inc dx
cmp dx,bx
jnz b2deletespeed

 
mov bx,cx
add bx,6
b3deletespeed:
push bx
mov bx,0
int 10h 
pop bx
inc cx
dec dx
cmp cx,bx
jnz b3deletespeed

 
pop dx
pop cx
pop bx
pop ax
  
 ret  
DeleteSpeed endp 

;------------------------
;------------------------
DrawFreeze proc  
push ax
push bx
push cx
push dx    
    
mov cx,PowerUpX
mov dx,PowerUpY
mov bx,cx
add bx,12
mov al,9h
mov ah,0ch
b1drawfreeze:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b1drawfreeze

dec cx

dec dx 
mov ah,0ch 
mov bx,0
int 10h

add dx,2
mov ah,0ch
int 10h

sub cx,11

sub dx,2 
mov ah,0ch
int 10h

add dx,2
mov ah,0ch
int 10h

sub dx,7

mov bx,cx
add bx,12
mov ah,0ch
b2drawfreeze:
push bx
mov bx,0
int 10h 
pop bx
inc cx
inc dx
cmp cx,bx
jnz b2drawfreeze

sub dx,2
mov ah,0ch
mov bx,0
int 10h

sub cx,2
add dx,2 
mov ah,0ch
int 10h

sub cx,11
sub dx,11
mov ah,0ch
int 10h

add cx,2
sub dx,2
mov ah,0ch
int 10h


inc dx
add cx,5
mov bx,dx
add bx,12 
mov ah,0ch
b3drawfreeze:
push bx
mov bx,0
int 10h 
pop bx
inc dx
cmp dx,bx
jnz b3drawfreeze 

dec dx

inc cx 
mov ah,0ch 
mov bx,0
int 10h

sub cx,2
mov ah,0ch
int 10h


sub dx,11
add cx,2
mov ah,0ch
int 10h
sub cx,2
mov ah,0ch
int 10h

add cx,7

mov bx,dx
add bx,12 
mov ah,0ch
b4drawfreeze:
push bx
mov bx,0
int 10h 
pop bx
dec cx
inc dx
cmp dx,bx
jnz b4drawfreeze


sub dx,2
mov ah,0ch
mov bx,0
int 10h
add cx,2
add dx,2
mov ah,0ch
int 10h


sub dx,13
add cx,9
mov ah,0ch
int 10h
add cx,2
add dx,2
mov ah,0ch
int 10h
  
  CMP THROW_FLAG,1
 JE DONT_DELAY2
 MOV CX,00H       ;DELAY
   MOV DX,2710h
 MOV AX,8600H
 INT 15H
 JMP END_DRAW
  
  DONT_DELAY2:
  MOV CX,00H       ;DELAY
  MOV DX,0BB8h
  MOV AX,8600H
  INT 15H
  END_DRAW:
 
pop dx
pop cx
pop bx
pop ax    
    
ret    
DrawFreeze endp    
               
DeleteFreeze proc  
push ax
push bx
push cx
push dx    
    
mov cx,PowerUpX
mov dx,PowerUpY
mov bx,cx
add bx,12
mov al,00
mov ah,0ch
b1deletefreeze:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b1deletefreeze

dec cx

dec dx 
mov ah,0ch
mov bx,0
int 10h

add dx,2
mov ah,0ch
int 10h

sub cx,11

sub dx,2 
mov ah,0ch
int 10h

add dx,2
mov ah,0ch
int 10h

sub dx,7

mov bx,cx
add bx,12
mov ah,0ch
b2deletefreeze:
push bx
mov bx,0
int 10h 
pop bx
inc cx
inc dx
cmp cx,bx
jnz b2deletefreeze

sub dx,2
mov ah,0ch
mov bx,0
int 10h

sub cx,2
add dx,2 
mov ah,0ch
int 10h

sub cx,11
sub dx,11
mov ah,0ch
int 10h

add cx,2
sub dx,2
mov ah,0ch
int 10h


inc dx
add cx,5
mov bx,dx
add bx,12 
mov ah,0ch
b3deletefreeze:
push bx
mov bx,0
int 10h 
pop bx
inc dx
cmp dx,bx
jnz b3deletefreeze 

dec dx

inc cx 
mov ah,0ch
mov bx,0
int 10h

sub cx,2
mov ah,0ch
int 10h


sub dx,11
add cx,2
mov ah,0ch
int 10h
sub cx,2
mov ah,0ch
int 10h

add cx,7

mov bx,dx
add bx,12 
mov ah,0ch
b4deletefreeze:
push bx
mov bx,0
int 10h 
pop bx
dec cx
inc dx
cmp dx,bx
jnz b4deletefreeze


sub dx,2
mov ah,0ch 
mov bx,0
int 10h
add cx,2
add dx,2
mov ah,0ch
int 10h


sub dx,13
add cx,9
mov ah,0ch
int 10h
add cx,2
add dx,2
mov ah,0ch
int 10h


pop dx
pop cx
pop bx
pop ax    
    
ret    
DeleteFreeze endp 

;----------------------
;----------------------
DrawLife proc
push ax
push bx
push cx
push dx 
push si
push di

mov di,2 
mov dx,PowerUpY
secdrawlife: 
mov cx,PowerUpX
mov bx,cx
add bx,5
mov al,0fh
mov ah,0ch
b1drawlife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b1drawlife

add cx,2

mov bx,cx
add bx,5
mov al,0fh
mov ah,0ch
b2drawlife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b2drawlife
inc dx 
dec di
cmp di,0
jnz secdrawlife

dec dx
mov si,1 
mov di,10
contdrawlife:
mov cx,PowerUpX
add cx,si
inc dx
mov bx,cx
add bx,di 
mov al,0fh
mov ah,0ch
b3drawlife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b3drawlife

inc si
sub di,2
cmp di,0 
jnz contdrawlife 

mov cx,PowerUpX
mov dx,PowerUpY
inc cx
dec dx
mov bx,cx
add bx,3
mov al,0fh
mov ah,0ch
b4drawlife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b4drawlife

add cx,4

mov bx,cx
add bx,3
mov al,0fh
mov ah,0ch
b5drawlife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b5drawlife

 CMP THROW_FLAG,1
 JE DONT_DELAY3
 MOV CX,00H       ;DELAY
   MOV DX,2710h
 MOV AX,8600H
 INT 15H
 JMP END_DRAW3
  
  DONT_DELAY3:
  MOV CX,00H       ;DELAY
  MOV DX,0BB8h
  MOV AX,8600H
  INT 15H
  END_DRAW3:
  
pop di
pop si
pop dx
pop cx
pop bx
pop ax 
    
ret    
DrawLife endp 

DeleteLife proc
push ax
push bx
push cx
push dx 
push si
push di

mov di,2 
mov dx,PowerUpY
secdeletelife: 
mov cx,PowerUpX
mov bx,cx
add bx,5
mov al,00
mov ah,0ch
b1deletelife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b1deletelife

add cx,2

mov bx,cx
add bx,5
mov al,00
mov ah,0ch
b2deletelife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b2deletelife
inc dx 
dec di
cmp di,0
jnz secdeletelife

dec dx
mov si,1 
mov di,10
contdeletelife:
mov cx,PowerUpX
add cx,si
inc dx
mov bx,cx
add bx,di 
mov al,00
mov ah,0ch
b3deletelife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b3deletelife

inc si
sub di,2
cmp di,0 
jnz contdeletelife 

mov cx,PowerUpX
mov dx,PowerUpY
inc cx
dec dx
mov bx,cx
add bx,3
mov al,00
mov ah,0ch
b4deletelife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b4deletelife

add cx,4

mov bx,cx
add bx,3
mov al,00
mov ah,0ch
b5deletelife:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b5deletelife


pop di
pop si
pop dx
pop cx
pop bx
pop ax 
    
ret    
DeleteLife endp 
 
;----------------------
;----------------------    
DrawKill proc
push ax
push bx
push cx
push dx     

mov cx,PowerUpX
mov dx,PowerUpY
mov bx,cx
add bx,12
mov al,7h
mov ah,0ch
b1drawkill:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b1drawkill

sub cx,9
sub dx,2
mov bx,dx
add bx,5
mov al,04h
mov ah,0ch
b2drawkill:
push bx
mov bx,0
int 10h 
pop bx
inc dx
cmp dx,bx
jnz b2drawkill

 CMP THROW_FLAG,1
 JE DONT_DELAY4
 MOV CX,00H       ;DELAY
   MOV DX,2710h
 MOV AX,8600H
 INT 15H
 JMP END_DRAW4
  
  DONT_DELAY4:
  MOV CX,00H       ;DELAY
  MOV DX,0BB8h
  MOV AX,8600H
  INT 15H
  END_DRAW4:
 
pop dx
pop cx
pop bx
pop ax    
ret    
DrawKill endp

DeleteKill proc
push ax
push bx
push cx
push dx     

mov cx,PowerUpX
mov dx,PowerUpY
mov bx,cx
add bx,12
mov al,00
mov ah,0ch
b1deletekill:
push bx
mov bx,0
int 10h 
pop bx
inc cx
cmp cx,bx
jnz b1deletekill

sub cx,9
sub dx,2
mov bx,dx
add bx,5
mov al,00
mov ah,0ch
b2deletekill:
push bx
mov bx,0
int 10h 
pop bx
inc dx
cmp dx,bx
jnz b2deletekill

 
pop dx
pop cx
pop bx
pop ax    
ret    
DeleteKill endp  


END MAIN