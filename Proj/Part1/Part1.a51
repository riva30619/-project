ORG	0					

	MOV	SCON, #50H
	MOV	TMOD, #20H			
	MOV	TH1,  #0FDH			
	SETB	TR1							
	CALL	MainDOOR
MainDOOR:
	MOV DPTR, #0
	MOV	DPTR, #DOOR
	
SendDOOR:
	CLR		A							
	MOVC	A, @A+DPTR	
	MOV		R1,A
	JZ		LINE2   ;Send letter until value is 0
					;then jump to LINE2 to the next line
	MOV		SBUF, R1	
	ACALL	Wait			
	INC		DPTR					
	SJMP	SendDOOR	

LINE2:
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	ACALL DELAY
	AJMP MainSTART
	
// SendSTART	
MainSTART:
	MOV DPTR, #0
	MOV	DPTR, #START
	MOV R0, #0  ;Send string
	MOV R1, #0  ;Save the value of P2
	MOV R2, #0  ;count *
	MOV R3, #0  ;Save the value of PASSWORD
	MOV R4, #0  ;count correct time
	MOV R5, #0  ;count PASSWORD line
SendSTART:
	CLR		TI
	CLR		A							
	MOVC	A, @A+DPTR	
	MOV		R0,A
	JZ		READ
	MOV		SBUF, R0	
	ACALL	Wait			
	INC		DPTR					
	SJMP	SendSTART
	
// INPUT
PASS:
	CJNE R2, #5, READ ;Count * ,R2=5 PASSWORD input completed
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	AJMP CHECK      ;Confirm password is correct or incorrect
	
READ:
	MOV R1, P2  ; READ INPUT
	CJNE R1, #0FFH, READINPUT
	AJMP READ
     
READINPUT:
	MOV A, #'*' ; SEND *
	CLR TI
	MOV SBUF, A
	JNB TI, $
		
	// READ 
	MOV A, #0
	MOV A,R5
	MOV R3, #0
	MOV DPTR, #PASSWORD
	MOVC A, @A+DPTR 
	INC R2               ;count *
	MOV R3, A            ;Save the value of PASSWORD
	MOV A,P2
	CLR C
	SUBB A, R3           ;Correct passward minus input
	MOV P2, #0FFH        ;Change P2 from input value back to 0FFH
	CJNE A, #0,PASS      ;input correct A=0 continue,A!=0 jump to PASS
	INC R4               ;input correct R4 +1
	INC R5               ;input correct R5 +1,read next line of password
	AJMP PASS            ;jump to PASS

CHECK:
	CJNE R4, #5,MainWRONG ;Wrong R4!=5 jump to MainWRONG send WRONG
	MOV P1, #0F8H		  ;Correct R4=5 continue
	AJMP MainCORRECT      ;jump to MainCORRECT send CORRECT
	
//WRONG
MainWRONG:
	MOV DPTR, #0
	MOV	DPTR, #WRONG
	MOV R0, #0
SendWRONG:
	CLR		TI
	CLR		A							
	MOVC	A, @A+DPTR	
	MOV		R0,A
	JZ		LINE
	MOV		SBUF, R0	
	ACALL	Wait			
	INC		DPTR					
	SJMP	SendWRONG
MainCORRECT:
	MOV DPTR, #0
	MOV	DPTR, #CORRECT
	MOV R0, #0
SendCORRECT:
	CLR		TI
	CLR		A							
	MOVC	A, @A+DPTR	
	MOV		R0,A
	JZ		LINE1    ;Send letter until value is 0
					 ;then jump to LINE1 to the next line
	MOV		SBUF, R0	
	ACALL	Wait			
	INC		DPTR					
	SJMP	SendCORRECT
MainOPEN:
	MOV DPTR, #0
	MOV	DPTR, #OPEN
	MOV R0, #0
SendOPEN:
	CLR		TI
	CLR		A							
	MOVC	A, @A+DPTR	
	MOV		R0,A
	JZ		LIGHT      ;jump to LIGHT 
	MOV		SBUF, R0	
	ACALL	Wait			
	INC		DPTR					
	SJMP	SendOPEN  
	
LINE:
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	ACALL DELAY
	AJMP MainSTART	
LINE1:
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	ACALL DELAY
	AJMP MainOPEN   ;jump to MainOPEN send OPEN	
	
LIGHT:
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	// SEND \n
	MOV A, #10
	CLR TI
	MOV SBUF, A
	JNB TI, $
	// P1, #0FFH
	ACALL DELAY
	MOV P1, #0FFH  ;P1 0F8H to 0FFH
	AJMP MainSTART
// CLR TI
Wait:
	JNB		TI, Wait			
	CLR		TI							
	RET
//DELAY
DELAY:
		MOV R0,#100
DELAY1:
		MOV R1,#100
DELAY2:
		MOV R2,#100
DELAYLOOP:
		DJNZ R2,DELAYLOOP
		DJNZ R1,DELAY2
		DJNZ R0,DELAY1
		RET

//STRING
DOOR:
	DB "This is a 5-digit passward door lock",0
START:
	DB "Enter passcode to unlock: ",0
CORRECT:
	DB "PIN CORRECT! ",0
OPEN:
	DB "DOOR OPENDED! ",0
WRONG:
	DB "PIN WRONG! ",0
PASSWORD:
	DB 11111101B
	DB 11111011B
	DB 11110111B
	DB 11101111B
	DB 11011111B

END