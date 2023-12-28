#include "msp430.h"                     ; #define controlled include file

        NAME    main                    ; module name

        PUBLIC  main                    ; make the main label vissible
                                        ; outside this module
        ORG     0FFFEh
        DC16    init                    ; set reset vector to 'init' label

        RSEG    CSTACK                  ; pre-declaration of segment
        RSEG    CODE                    ; place program in 'CODE' segment
init:   MOV     #SFE(CSTACK), SP     

main:   NOP                             ; main program
        MOV.W   #WDTPW+WDTHOLD,&WDTCTL  ; Stop watchdog timer


EXP1:   MOV #MSG,R5 ; 
        MOV #GSM, R6  ; 
        MOV #RT1, R7
        MOV #0, R8
        MOV #0, R9
        CALL #ENIGMA1
        JMP $
        NOP
ENIGMA1:
        
        MOV.b @R5+,R15
        CMP #0x0000,R15
        JZ  FINAL
        SUB.b #0x41,R15
        MOV.b RT1(R15),R14
        MOV #0,R15 ;                           reutiliza R15
        MOV.b  ALF(R14), R15        
        MOV.b R15,0(R6)
        ADD #0x0001,R6
        JMP ENIGMA1
FINAL:        
        RET

ROT4:   RLA R8
        RLA R8
        RLA R8
        RLA R8
        RET
        
        
        RSEG DATA16_N
        MSG:   dc8 "CABECAFEFACAFAD", 0              ;dc8 -> .b dc16 -> .w ; Aparentemente, no IAR Workbench, declarar dc16 já inicia e termina o vetor com 0
        GSM:   dc8 "XXXXXXXXXXXXXXX", 0
        RT1:   dc8 2,4,1,5,3,0
        ALF:   dc8 "ABCDEF"
        END