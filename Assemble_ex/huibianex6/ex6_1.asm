DSEG SEGMENT
    BUF DB 'Please input one number (0~9):',0DH,0AH,'$'
    RESULT DB 'The results are as follows:',0DH,0AH,'$'
    DATA1 DB 0;第一个数
    DATA2 DB 0;第二个数
    SUMANS DW 0;和
    SUBANS DB 0;差
    MULANS DW 0;积
    DIVANS DB 0;商
    MODANS DB 0;余数
DSEG ENDS

SSEG SEGMENT 
    STACK DB 50 DUP(0)
SSEG ENDS

CSEG SEGMENT
    ASSUME CS:CSEG,SS:SSEG,DS:DSEG
START: 
    MOV AX,DSEG
    MOV DS,AX
    MOV AX,SSEG
    MOV SS,AX
    MOV SP,SIZE STACK;初始化

    ;输出提示语言
    MOV DX,OFFSET BUF
    MOV AH,9
    INT 21H

    ;输入第一个数据并在屏幕显示
    MOV AH,1
    INT 21H
    SUB AL,30H
    MOV DATA1,AL
    MOV DL,0AH;换行
    MOV AH,2
    INT 21H

    ;输出提示语言
    MOV DX,OFFSET BUF
    MOV AH,9
    INT 21H

    ;输入第二个数据并回显
    MOV AH,1
    INT 21H
    SUB AL,30H
    MOV DATA2,AL
    MOV DL,0AH
    MOV AH,2
    INT 21H

    ;加法
    MOV AL,DATA1
    XOR AH,AH
    ADD AL,DATA2
    AAA
    MOV BL,AL
    MOV BH,AH
    MOV SUMANS,BX

    ;减法
    MOV AL,DATA1
    XOR AH,AH
    SUB AL,DATA2
    ;AAS
    MOV SUBANS,AL

    ;乘法
    MOV AL,DATA1
    XOR AH,AH
    MUL DATA2
    AAM
    MOV BL,AL
    MOV BH,AH
    MOV MULANS,BX

    ;除法
    MOV AL,DATA1
    XOR AH,AH
    DIV DATA2
    MOV DIVANS,AL
    MOV MODANS,AH

    ;输出提示语言
    MOV DX,OFFSET RESULT
    MOV AH,9
    INT 21H

    ;显示和
    MOV BX,SUMANS
    MOV AH,2
    ADD BH,30H
    MOV DL,BH
    INT 21H

    MOV AH,2
    ADD BL,30H
    MOV DL,BL
    INT 21H

    MOV DL,20H;空格
    MOV AH,2
    INT 21H

    ;显示差
    MOV BL,SUBANS
    MOV AH,2
    ADD BL,30H
    MOV DL,BL
    INT 21H

    MOV DL,20H
    MOV AH,2
    INT 21H

    ;显示积
    MOV BX,MULANS
    MOV AH,2
    ADD BH,30H
    MOV DL,BH
    INT 21H

    MOV AH,2
    ADD BL,30H
    MOV DL,BL
    INT 21H

    MOV DL,20H;空格
    MOV AH,2
    INT 21H

    ;显示商和余数
    MOV BL,DIVANS
    MOV AH,2
    ADD BL,30H
    MOV DL,BL
    INT 21H

    MOV DL,20H;空格
    MOV AH,2
    INT 21H

    MOV BL,MODANS
    MOV AH,2
    ADD BL,30H
    MOV DL,BL
    INT 21H

    MOV DL,20H;空格
    MOV AH,2
    INT 21H

    MOV AH,4CH
    INT 21H

CSEG ENDS
END START




