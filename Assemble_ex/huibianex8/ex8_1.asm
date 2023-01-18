;BIOS提供的08H号中断处理程序中有一条中断指令“INT 1CH”。所以每秒要调用1000/55≈18.2次1CH号中断处理程序。
;而BIOS的1CH号中断处理程序实际上并没有执行任何工作，只有一条中断返回指令（IRET）
;INT 1CH系统中断是每秒发生18.2次,即调用每秒它18次,所以Count初值赋值为1,先DEC减1,为0执行一次背景色输出,即运行程序就输出背景色.然后Count赋值为18,Count减1,当它为0时变换背景颜色.(1秒)然后继续Count赋值为18,继续执行中断周期调用.
CODE  SEGMENT
      ORG 100H 
      ASSUME  CS:CODE,DS:CODE
      BUF DB 'This Program will dispaly the instant Clock!',0DH,0AH,'$'
      HOUR    DB  0
      MINUTE  DB  0
      SECOND  DB  0
      COUNT   DB  18
      T       DB "00:00:00"

START:
    MOV AX,CODE
    MOV DS,AX

    ;输出提示语言
    MOV DX,OFFSET BUF
    MOV AH,9
    INT 21H

    MOV AH,2CH    ;取时间
    INT 21H
    MOV HOUR,CH ;时
    MOV MINUTE,CL;分
    MOV SECOND,DH;秒

     ;设置中断向量，类型号1C DS:DX指向中断向量
    LEA DX,INT1C
    MOV AX,251CH 
    INT 21H

     ;结束并驻留 AL=返回码（任意值） DX=驻留区大小
    MOV AX,3100H 
    MOV DX,OFFSET START;驻留程序的长度
    INT 21H

INT1C PROC FAR
      DEC CS:COUNT
      JZ C1
      JMP CEND

C1:   
        PUSH DS
        PUSH ES
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI                
        PUSH CS
        POP DS
        MOV COUNT,18
        INC SECOND
        CMP SECOND,60
        JB C2
        MOV SECOND,0
        INC MINUTE
        CMP MINUTE,60
        JB C2
        MOV MINUTE,0
        INC HOUR
        CMP HOUR,24
        JB C2
        MOV HOUR,0

C2:
    MOV AL,HOUR
    CBW
    MOV DL,0AH
    DIV DL;AL,AH分别保存十位和个位
    ADD AX,3030H ;0011 0000 0011 0000 B 用来转换为ASCII码
    MOV WORD PTR[T],AX    
    MOV AL,MINUTE
    CBW
    DIV DL
    ADD AX,3030H
    MOV WORD PTR[T+3],AX
    MOV AL,SECOND
    CBW
    DIV DL
    ADD AX,3030H
    MOV WORD PTR[T+6],AX

    MOV CX,8;字符串长度
    MOV AX,0B800H ;段地址切换到显存地址
    MOV ES,AX             
    LEA SI,[T]
    MOV DI,3980 ;一页是4000
    MOV AH,00100001B ;绿底蓝色
    ;MOV AH,01110001B;白底蓝色
    ;MOV AH,00000010B;绿色

TOVM: 
    LODSB   ;[SI]送进AL
    STOSW   ;AL送ES：DI
    LOOP TOVM
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    POP ES
    POP DS

CEND: IRET;中断返回

INT1C ENDP

CODE  ENDS
END  START
