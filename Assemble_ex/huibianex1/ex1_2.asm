DSEG    SEGMENT
DATA1   DB 56H,-127,'ABCD',3 DUP(1),'Z'
DATA2   DW 5678H,-127,'AB','CD',3 DUP(1),'Z'
DATA3   DD 567890ABH,-127,3 DUP(1),'AB','CD'
DSEG    ENDS

SSEG    SEGMENT
    SKTP DB 20 DUP(0)
SSEG    ENDS

CSEG    SEGMENT
    ASSUME  CS:CSEG,DS:DSEG
    ASSUME  SS:SSEG

START:  MOV AX,DSEG
        MOV DS,AX
        MOV AX,SSEG
        MOV SS,AX
        MOV SP,LENGTH SKTP

        MOV AH,4CH
        INT 21H

CSEG    ENDS
END START