; A sub-rotina MAIOR16 recebe em R5 o endereço de início de um vetor de palavras
; de 16 bits (words ou W16) sem sinal e retorna:
; R6 maior elemento do vetor e
; R7 qual sua frequência (quantas vezes apareceu)

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
        MOV #1, R7  ; Frequência inicial = 1
        MOV #0, R6  ;
        MOV @R5,R10 ; R10 é contador
        DEC R10
        INCD R5
        MOV @R5,R6 ; inicialmente, R6 é o menor
        INCD R5
        call #MAIOR16
        JMP $

MAIOR16:
        CMP @R5,R6; CMP é DST-SRC
        JEQ INCREMENTA ; se é igual
        JGE FINAL   ; se @R5 é menor que R6
        JL  NOVOMAIOR      ;se @R5 é maior que R6    (JL ->Lower)
        
NOVOMAIOR: MOV @R5,R6
           MOV #1,R7
           JMP FINAL
           
INCREMENTA: INC R7

FINAL:  INCD R5
        DEC R10
        JNZ MAIOR16
        RET
        
        RSEG DATA16_N
        VE12:   dc16 13,'JOAQUIMJOSE0OSOSOSOSOSOS3'                    ;dc8 -> .b dc16 -> .w ; Aparentemente, no IAR Workbench, declarar dc16 já inicia e termina o vetor com 0
        
        END