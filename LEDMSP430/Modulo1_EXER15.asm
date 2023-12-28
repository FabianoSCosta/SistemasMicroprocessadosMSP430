;programa SW_LEDS, no qual o LED1 deve permanecer aceso enquanto a chave S1
;estiver pressionada. O mesmo deve acontecer com o LED2 e S2.


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
	BIC.b #BIT1,&P1DIR
	BIS.b #BIT1, &P1REN
	BIS.b #BIT1, &P1OUT

	BIC.b #BIT1, &P2DIR
	BIS.b #BIT1, &P2REN
	BIS.b #BIT1, &P2OUT

	BIS.b #BIT0, &P1DIR
	BIC.b #BIT0, &P1OUT

	BIS.b #BIT7, &P4DIR
	BIC.b #BIT7, &P4OUT

SW_LEDS:
	BIC.b #BIT0,&P1OUT
	BIT.b #BIT1,&P2IN
	JNZ SW_LEDS2

SW_LEDSACES:
	BIS.b #BIT0, &P1OUT
	BIT.b #BIT1, &P2IN

SW_LEDS2:
	BIC.b #BIT7,&P4OUT
	BIT.b #BIT1,&P1IN
	JNZ SW_LEDS

SW_LEDSACES2:
	BIS.b #BIT7, &P4OUT
	BIT.b #BIT7, &P4IN
	JZ SW_LEDSACES2
	JMP SW_LEDS


	JMP $
	NOP
                                            

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
            
