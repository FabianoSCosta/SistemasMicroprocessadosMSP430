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


PE3:    MOV #VE12,R5 ; Coloca o tamanho do vetor em R5  
        MOV #0, R7  ; multiplos de 4
        MOV #0, R6  ; multiplos de 2
        MOV.b @R5,R10 ;R10 é contador
        INC R5
        call #M2M4
        JMP $

M2M4:   MOV.b @R5,R8        
        BIT #0x0003,R8 ; (0000 0000 0000 0011 AND R8)
        JZ MULT4
        BIT #0x0001,R8
        JZ MULT2
        JMP FINAL
        
MULT4:  INC R6
        INC R7 ; todo multiplo de 4 é de 2
        JMP FINAL
           
MULT2: INC R6

FINAL:  INC R5
        DEC R10
        JNZ M2M4
        RET
        
        RSEG DATA16_N
        VE12:   dc8 8,'21404823'                    ;dc8 -> .b dc16 -> .w ; Aparentemente, no IAR Workbench, declarar dc16 já inicia e termina o vetor com 0
        
        END