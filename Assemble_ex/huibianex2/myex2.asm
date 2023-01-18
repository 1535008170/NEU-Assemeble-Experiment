DSEG SEGMENT      ;此处输入数据段代码 
	TABLE DB 0,1,4,9,16,25,36,49,64,81
	RETURN DB  13,10,'$'
	BUF DB 'Please input one number(0~9):',0DH,0AH,'$'  ;'$' 作为字符串结束的标志。
	ERR DB 0DH,0AH,'ERROR!$'
DSEG ENDS

SSEG SEGMENT STACK
	STK DB 50 DUP(0)
SSEG ENDS

CSEG SEGMENT
	ASSUME CS:CSEG,DS:DSEG
	ASSUME SS:SSEG

OUTPUT PROC
    MOV AH,0
    DIV CL
    CMP AL,10
    JB  OUTPUT1
    ADD AL,07H
    OUTPUT1: ADD AL,30H;
             CMP AH,10
             JB  OUTPUT2
             ADD AH,07H
    OUTPUT2: ADD AH,30H
             PUSH AX
             MOV  DL,AL
             MOV  AH,02H
             INT  21H
             POP  AX
             MOV  DL,AH
             MOV  AH,2
             INT  21H
             RET
OUTPUT ENDP

START:MOV AX,DSEG
	  MOV DS,AX
	  MOV AX,SSEG
	  MOV SS,AX
      MOV SP,SIZE STK

	  MOV DX,OFFSET BUF
      MOV AH,9
      INT 21H

      MOV BX,OFFSET TABLE
      MOV AH,01H
      INT 21H

      CMP AL,'0'
      JB ERRORS
      CMP AL,'P'
      JA ERRORS

      SUB AL,30H
      XLAT

      MOV DX,OFFSET RETURN 
      MOV AH,09H
      INT 21H

      MOV CH,AL
      MOV CL,10
      CALL OUTPUT
      MOV DX,OFFSET RETURN
      MOV AH,09H
      INT 21H

      MOV AL,CH
      MOV CL,16
      CALL OUTPUT
      JMP EXIT

ERRORS: MOV DX,OFFSET ERR
        MOV AH,09H
        INT 21H

EXIT:   MOV AX,4C00H
        INT 21H

CSEG ENDS
END START