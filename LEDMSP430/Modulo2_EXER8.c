#include <msp430.h> 


/**
 * main.c
 */


void espera(void);
void config(void);

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
    TA0CCR0 = 16383;
	config();
	__enable_interrupt();
    while (1);
	return 0;
}

void espera(void){
    TA0CTL |= 0;    // zera o contador
    TA0CTL &= ~TAIFG;  // apaga TAIFG
    while ( (TA0CTL&TAIFG) == 0);  // espera TA0CCR0
}



void config(void){

    TA0CTL = TASSEL_1 | MC_1 |TAIE;    //modo ACLK (2 ^ 15 Hz ) , modo UP, habilita TAIE para usar TAIFG

    P1DIR |= BIT0; //Led1 saída
    P1OUT &= ~BIT0; //Led1 apagado

    P4DIR |= BIT7;
    P4OUT &= ~BIT7;

    P2DIR &= ~BIT1;
    P2REN |= BIT1;
    P2OUT |= BIT1;

    P1DIR &= ~BIT1;
    P1REN |= BIT1;
    P1OUT |= BIT1;

}


#pragma vector= 52;
__interrupt void rootta0(void){
    volatile int x;
    P4OUT ^= BIT7;
//    TA0CTL &= ~TAIFG;
    TA0IV;
}
