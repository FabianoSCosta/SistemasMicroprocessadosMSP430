#include <msp430.h> 

#define TRUE 1
#define FALSE 0
#define ABERTA 1
#define FECHADA 0
#define DBC 1000

int s1(void);
int s2(void);

void debounce(int valor);
void config(void);

int main(void){
    WDTCTL = WDTPW | WDTHOLD; // stop watchdog timer
    config();
    while (TRUE){
        if (s1() == TRUE) P1OUT ^= BIT0;
        if (s2() == TRUE) P1OUT ^= BIT0;
    }
    return 0;
}

int s1(void){
    static int ps1=ABERTA;
    if ( (P2IN&BIT1) == 0){
        if (ps1==ABERTA){
            debounce(DBC);
            ps1=FECHADA;
            return TRUE;
        }
    }
    else{
        if (ps1==FECHADA){
                debounce(DBC);
                ps1=ABERTA;
                return FALSE;
        }
    }
    return FALSE;
}

int s2(void){
    static int ps2=ABERTA;
    if ( (P1IN&BIT1) == 0){
        if (ps2==ABERTA){
            debounce(DBC);
            ps2=FECHADA;
            return TRUE;
        }
    }
    else{
        if (ps2==FECHADA){
            debounce(DBC);
            ps2=ABERTA;
            return FALSE;
        }
    }
    return FALSE;
}


void debounce(int valor){
    volatile int x;
    for (x=0; x<valor; x++);
}

// Configurar GPIO
void config(void){
    P1DIR |= BIT0; //Led1 = P1.0 = sa�da
    P1OUT &= ~BIT0; //Led1 apagado

    P4DIR |= BIT7; //Led2 = P4.7 = sa�da
    P4OUT &= ~BIT7; //Led1 apagado

    P2DIR &= ~BIT1;
    P2REN |= BIT1;
    P2OUT |= BIT1;

    P1DIR &= ~BIT1;
    P1REN |= BIT1;
    P1OUT |= BIT1;

}
