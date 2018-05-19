// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa perif�ricos e faz um loop de polling 
// e atualiza��o do funcionamento do motor.
// Marcelo Fernandes e Bruno Colombo

#include <stdint.h>
#include "globals.h"
#include "lcd.h"
#include "utils.h"
#include "keyboard.h"
#include "timer.h"
#include "uart.h"

void PLL_Init(void);
void SysTick_Init(void);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);


volatile int x = 0;

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
    LCD_Init();
	Keyboard_Init();
    Timer_Init();
    Uart_Init();
}

