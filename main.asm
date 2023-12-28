;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
	.text
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
        CMP #0x0000,R15			;verifica o final do vetor
        JZ  FINAL
        SUB.b #0x41,R15
        MOV.b RT1(R15),R14       ; encontra o elemento em RT1 que corresponde à letra( R15)
        CLR R15 ;                           reutiliza R15
        MOV.b  ALF(R14), R15     ; encontra letra cifrada
        MOV.b R15,0(R6)          ; coloca a letra cifrada em GSM
        ADD #0x0001,R6           ; pula um bit no endereço de GSM
        JMP ENIGMA1

FINAL:	RET

	.data
MSG:   .byte "CABECAFEFACAFAD",0              ;dc8 -> .b dc16 -> .w ; Aparentemente, no IAR Workbench, declarar dc16 já inicia e termina o vetor com 0
GSM:   .byte "XXXXXXXXXXXXXXX",0
DCF:   .byte "XXXXXXXXXXXXXXX",0
RT1:   .byte 2,4,1,5,3,0
RF1:   .byte 3,5,4,0,2,1
ALF:   .byte "ABCDEF"
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
