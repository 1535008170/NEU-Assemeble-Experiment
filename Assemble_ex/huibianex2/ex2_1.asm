DSEG    SEGMENT
JMTAB   DB    0,1,4,9,16,25,36,49,64,81 
ETR     DB    0DH,0AH,'$'
ERR     DB    0DH,0AH,'MUST INPUT A NUMBER BETWEEN 0 AND 9 $'
BUF     DB    'Please input one number(0~9):',0DH,0AH,'$'  ;'$' 作为字符串结束的标志。
DSEG    ENDS

SSEG   SEGMENT    STACK  
STK    DB       20 DUP(0)  
SSEG   ENDS  

CSEG   SEGMENT  
ASSUME  CS:CSEG,DS:DSEG,SS:SSEG  

OUTPUT  PROC 
MOV    AH,0  
DIV    CL;被除数在AX中，8位除数是源操作数，结果的8位商在AL，8位余数在AH中，此处用于保存高位和低位  
CMP    AL,10;   AL中是高位  
JB     OUTPUT1  
ADD    AL,07H  
OUTPUT1:ADD    AL,30H;转为字符型  
        CMP    AH,10;   AH中是低位  
        JB     OUTPUT2  
        ADD    AH,07H      
OUTPUT2:ADD    AH,30H;转为字符型  
        PUSH   AX;将输出的字符暂存压栈  
        MOV    DL,AL;传入高位  
        MOV    AH,02H;显示高位的值  
        INT    21H  
        POP    AX;弹栈  
        MOV    DL,AH;传入低位  
        MOV    AH,02H;显示低位的值  
        INT    21H  
        RET  
OUTPUT  ENDP;子程序结束  

START:  MOV    AX,DSEG  
        MOV    DS,AX  
        MOV    AX,SSEG  
        MOV    SS,AX  
        MOV    SP,SIZE STK  

        MOV    DX,OFFSET BUF	;输出提示语言
	MOV    AH,9
`       INT    21H

        MOV    BX,OFFSET JMTAB  
        MOV    AH,01H  
        INT    21H  
        CMP    AL,'0'  
        JB    ERRORS;如果输入字符小于'0'，输出错误信息  
        CMP    AL,'9'  
        JA    ERRORS;如果输入字符大于'9'，输出错误信息  

        SUB    AL,30H;否则转换为数字  
        XLAT   ;使用查表法  
        MOV    DX,OFFSET ETR;输出回车  
        MOV    AH,09H;  
        INT    21H  
        MOV    CH,AL;将表中对应的索引的值赋给CH  
        MOV    CL,10;进行10进制的高低位分离  
        CALL   OUTPUT  
        MOV    DX,OFFSET ETR;输出回车  
        MOV    AH,09H;  
        INT    21H  
        MOV    AL,CH  
        MOV    CL,16;进行16进制的高低位分离  
        CALL   OUTPUT  
        JMP    EXIT  
        ERRORS: MOV    DX,OFFSET ERR;输出错误信息  
        MOV    AH,09H  
        INT    21H  

EXIT:   MOV    AX,4C00H;安全退出程序  
        INT    21H  
CSEG   ENDS  
END    START  