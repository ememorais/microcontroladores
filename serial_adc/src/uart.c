// uart.c
// Desenvolvido para a placa EK-TM4C1294XL
// Marcelo Fernandes e Bruno Colombo

#include "uart.h"

volatile uint8_t value = 36;

void Uart_Init(void)
{
    //Habilita clock no módulo UART0
    SYSCTL_RCGCUART_R |= SYSCTL_RCGCUART_R0;

    //Espera até a UART0 estar pronta
    while((SYSCTL_RCGCUART_R & SYSCTL_RCGCUART_R0) != SYSCTL_RCGCUART_R0) {}

    //Desabilita UART0 antes de fazer alterações
    UART0_CTL_R &= ~UART_CTL_UARTEN;

    //BRD  = BRDI + BRDF = UARTSysClk / (ClkDiv * Baud Rate)
    //9600 = BRDI + BRDF = 80e6 / (16 * 9600) = 520,833...
    //BRDI = 520; BRDF = 2^6 * 0,833... = 53,3 ~= 53
    UART0_IBRD_R = 520;
    UART0_FBRD_R = 53;

    UART0_LCRH_R = UART_LCRH_WLEN_8;

    UART0_CC_R = UART_CC_CS_SYSCLK;

    UART0_CTL_R |= (UART_CTL_UARTEN|UART_CTL_RXE|UART_CTL_TXE);
}

void Uart_Transmit(void)
{
    if((UART0_FR_R & UART_FR_TXFF) == 0) {
        UART0_DR_R |= value;
    }
}
