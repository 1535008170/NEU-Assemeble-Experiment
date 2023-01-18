DSEG    SEGMENT
DATA1   DB      13H,26H
DATA2   DW      0
DSEG    ENDS

SSEG    SEGMENT     STACK
SKTOP   DB          20 DUP(0)
SSEG    ENDS

CSEG    SEGMENT
        ASSUME      CS:CSEG,DS:DSEG
        ASSUME      SS:SSEG
START:  MOV         AX,DSEG
        MOV         DS,AX
        MOV         AX,SSEG
        MOV         SS,AX
        MOV         SP,LENGTH SKTOP
        MOV         AL,DATA1
        ADD         AL,DATA1+1
        MOV         BYTE PTR DATA2,AL
        MOV         AH,4CH
        INT         21H
CSEG    ENDS
        END         START