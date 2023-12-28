; Sub-rotina MENOR que recebe em R5 o endereço de início de um vetor de bytes (sem
;sinal) e retorna:
; R6 menor elemento do vetor e
; R7 qual sua frequência (quantas vezes apareceu)

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
PR1: MOV #VE,R5
	MOV #1, R7   ;R7 é a frequência
	MOV #0, R6   ; R6 é o menor
	MOV.b @R5,R10 ; R10 é o tamanho do vetor
	DEC R10
	INC R5
	MOV.b @R5, R6
	INC R5
	call #MENOR
	JMP $

MENOR:
	CMP.b @R5,R6
	JEQ INCREMENTA
	JHS NOVOMENOR
	JLO FINAL

NOVOMENOR:
	MOV.b @R5,R6
	MOV #1, R7
	JMP FINAL

INCREMENTA: INC R7

FINAL:
	INC R5
	DEC R10
	JNZ MENOR
	RET

	.data
VE: .byte 12,"FABIANOCOSTA"

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
            
