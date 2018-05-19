// uart.h
// Desenvolvido para a placa EK-TM4C1294XL
// Marcelo Fernandes e Bruno Colombo

#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void Uart_Init(void);

void Uart_Transmit(void);


#endif
