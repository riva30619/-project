ORG 0H 

start:
    ; Initialization
    MOV TMOD, #21H ; Set Timer 0 in mode 1
    MOV TCON, #0 ; Clear Timer 0 control register
	MOV R3, #0 ;COUNTER
	MOV A,#01FH
	MOV DPTR,#33H
	MOVX @DPTR,A
	SETB P1.3;

standby:
    ; Standby state
    MOV P0, #0FFH ; Set Port 0 to FFH
    MOV P3, #0 ; Set Port 3 to 0
    SETB P1.3; Set Port 1 pin 3 to 1
	ORL P1,#11110110B
	MOV R3, #4 ; Set R3 as counter which store the value to 4
	;SETB P1.0; Set Port 1 pin 3 to 1
	JB P1.0, standby

activate_terminal_1:

	MOVX A,@DPTR
    MOV TH0, #26H
    MOV TL0, #0FBH
	SETB P1.0; Set Port 1 pin 3 to 1
	MOV P3, A
    CLR P1.3 ; Set Port 1 pin 3 to 0
	MOV P0, #0FEH ; Set Port 0 to FFh
	;MOV P0.0, #0FEH ; Set Port 0 PIN 0 to 1111 1110 in binary

    ; Reset Timer 0
    MOV TH0, #0
    MOV TL0, #0

    JMP activate_terminal_2 ; Jump to the common part for Activate Terminal 2

activate_terminal_2:

    MOV TH0, #26H
    MOV TL0, #0FBH
	MOV P0, #0FDH ; Set Port 0 to FFh
    ;MOV P0.1, #0FDH ; Set Port 0 PIN 1 to 1111 1101 in binary

    ; Reset Timer 0
    MOV TH0, #0
    MOV TL0, #0

    JMP activate_terminal_3 ; Jump to the common part for Activate Terminal 3

activate_terminal_3:

    MOV TH0, #26H
    MOV TL0, #0FBH
	MOV P0, #0FBH ; Set Port 0 to FFh
    ;MOV P0.2, #0FBH ; Set Port 0 PIN 2 to 1111 1011 in binary

    ; Reset Timer 0
    MOV TH0, #0
    MOV TL0, #0

    JMP activate_terminal_4 ; Jump to the common part for Activate Terminal 4

activate_terminal_4:

    MOV TH0, #26H
    MOV TL0, #0FBH
	MOV P0, #0F7H ; Set Port 0 to FFh
    ;MOV P0.3, #0F7H ; Set Port 0 to 1111 0111 in binary

    ; Reset Timer 0
    MOV TH0, #0
    MOV TL0, #0

	DEC R3 ; Make the counter=counter-1

    ; Jump back to activate_terminal_1
    CJNE R3, #0, activate_terminal_1 ;
	
	; Check if counter is zero
    AJMP standby; Jump to standby if counter is zero
END
