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
        
        MOV #GSM,R5
        MOV #DCF,R6
        MOV #RT1,R7
        MOV #RF1,R13
        CALL #ENIGMA2
        
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

ENIGMA2:
        MOV.b @R5+,R15
        CMP #0x0000,R15 ;verifica o final do vetor
        JZ  FINAL
        SUB.b #0x41,R15 ; acha a qual letra a GSM se refere (0=a,1=b...)
        MOV #0,R14 
        MOV.b RF1(R15), R14 ; move o elemento de indice R15 do vetor RF1 para R14
CONTINUA:        
        CALL #POSVET
        SUB #0x0001,R13  ; 
        
        
        
POSVET:                      ;POSVET procura R14 em RT1
        MOV.b @R13+,R12
        CMP R14,R12 ;
        JZ CONTINUA ; R13 - 1  será a a posição da memória em que o elemento foi encontrado
        JMP POSVET
        

FINAL:        
        RET

        
        
        RSEG DATA16_N
        MSG:   dc8 "CABECAFEFACAFAD", 0              ;dc8 -> .b dc16 -> .w ; Aparentemente, no IAR Workbench, declarar dc16 já inicia e termina o vetor com 0
        GSM:   dc8 "XXXXXXXXXXXXXXX", 0
        DCF:   dc8 "XXXXXXXXXXXXXXX", 0
        RT1:   dc8 2,4,1,5,3,0
        RF1:   dc8 3,5,4,0,2,1
        ALF:   dc8 "ABCDEF"
        END