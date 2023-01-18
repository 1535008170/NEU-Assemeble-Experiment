SSEG    SEGMENT STACK
        DB      50H DUP(0)
SSEG    ENDS
DSEG    SEGMENT 
ASKFN1  DB      'FILE1 NAME:$'
ERRMSG1 DB      'FILE1 ERROR!$'
FILE1   DB      14,?,14 DUP(?)
NUM1    DW      0
ASKFN2  DB      'FILE2 NAME:$'
ERRMSG2 DB      'FILE2 ERROR!$'
FILE2   DB      14,?,14 DUP(?)
NUM2    DW      0
BUFF    DB      512 DUP(?)
DSEG    ENDS
CSEG    SEGMENT
        ASSUME  CS:CSEG,SS:SSEG,DS:DSEG
FILE    PROC    FAR
        PUSH    DS
        XOR     AX,AX
        PUSH    AX
        MOV     AX,DSEG
        MOV     DS,AX 
        LEA     DX,ASKFN1              ;输入存储file1名字
        MOV     AH,09H
        INT     21H
        LEA     DX,FILE1
        MOV     AH,0AH
        INT     21H
        MOV     DL,0AH                 ;输出换行符
        MOV     AH,2
        INT     21H
        MOV     BL,FILE1+1             ;将file1存储区改写为ASCIIZ串
        MOV     BH,0
        MOV     [BX+FILE1+2],BH
        LEA     DX,ASKFN2              ;输入存储file2名字
        MOV     AH,09H
        INT     21H
        LEA     DX,FILE2
        MOV     AH,0AH
        INT     21H
        MOV     DL,0AH                 ;输出换行符
        MOV     AH,2
        INT     21H
        MOV     BL,FILE2+1             ;将file2存储区改写为ASCIIZ串
        MOV     BH,0
        MOV     [BX+FILE2+2],BH
        LEA     DX,FILE1+2             ;打开file1
        MOV     AX,3D00H
        INT     21H
        JC      EXIT1
        MOV     NUM1,AX                ;保存file1的文件号
        LEA     DX,FILE2+2             ;打开file2
        MOV     AX,3D00H
        INT     21H
        JC      EXIT2 
        MOV     NUM2,AX                ;保存file2的文件号
AGAIN:  MOV     BX,NUM1
        MOV     CX,512                 ;读入file1
        LEA     DX,BUFF
        MOV     AH,3FH
        INT     21H                    ;AX中返回实际读入的字数
        PUSH    AX                     ;将读入字数入栈
        JC      EXIT1
        MOV     BX,NUM2
        MOV     CX,512                 ;写入file2
        LEA     DX,BUFF
        MOV     AH,40H
        INT     21H                    ;AX中返回实际写入的字数
        JC      EXIT2
        POP     AX
        CMP     AX,512
        JE      AGAIN
        MOV     AH,3EH
        INT     21H
        MOV     BX,NUM1
        MOV     AH,3EH
        INT     21H
        RET      
EXIT1:  LEA     DX,ERRMSG1						;错误处理1
        MOV     AH,9
        INT     21H
        RET
EXIT2:  LEA     DX,ERRMSG2						;错误处理2
        MOV     AH,9
        INT     21H
        RET
FILE    ENDP
CSEG    ENDS
        END     FILE