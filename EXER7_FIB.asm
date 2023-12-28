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


PE3:    MOV #VE12,R5 ; Coloca o tamanho do vetor em R5  Modo absoluto? troca # por &?
        MOV #0, R6  ; multiplos de 4
        MOV.b #20,R10 ;R10 é contador    ; @R5 modo indireto
        CALL #FIB
        JMP $

FIB:    MOV @R5+,R6
        ADD @R5,R6
        MOV R6,0x0002(R5)
        DEC R10
        JNZ FIB
        RET
        
        RSEG DATA16_N
        VE12:   dc16 1,1              ;dc8 -> .b dc16 -> .w ; Aparentemente, no IAR Workbench, declarar dc16 já inicia e termina o vetor com 0
        
        END