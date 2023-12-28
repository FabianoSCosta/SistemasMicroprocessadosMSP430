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


PE3:    MOV #VE12,R5 ;Colocar o número 0xFFF em R5
        MOV #1, R7  ;Frequência inicial = 1
        MOV #0, R6  ;
        MOV @R5,R10 ;R10 é contador
        DEC R10
        INCD R5
        MOV.b @R5,R6 ; inicialmente, R6 é o menor
        INC R5
        call #MENOR
        JMP $

MENOR:
        CMP.b @R5,R6
        JEQ INCREMENTA ; compara se é igual
        JGE NOVOMENOR   ;compara se R5 é menor que R6
        JL  FINAL       ;compara se R5 é maior que R6    (JL ->Lower)
        
NOVOMENOR: MOV.b @R5,R6
           MOV #1,R7
           JMP FINAL
           
INCREMENTA: INC R7

FINAL:  INC R5
        DEC R10
        JNZ MENOR
        RET
        

        
        
        RSEG DATA16_N
        VE12:   dc16 19,'2109312930123012093'                        ;dc8 .b dc16 .w
        
        END
