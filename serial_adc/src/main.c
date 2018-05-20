// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa periféricos e faz um loop de polling 
// e atualização do funcionamento do motor.
// Marcelo Fernandes e Bruno Colombo

#include <stdint.h>
#include <string.h>
#include "globals.h"
#include "lcd.h"
#include "utils.h"
#include "keyboard.h"
#include "timer.h"
#include "adc.h"
#include "uart.h"

void PLL_Init(void);
void SysTick_Init(void);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
  LCD_Init();
	Keyboard_Init();
  Timer_Init();
	ADC_Init();
	Uart_Init();
	
	while(1) 
	{
		//Se passaram 500*200us = 100ms, faz polling do teclado
		//e manda processar dado lido para o motor
		if(keyboard_counter >= 500) {
			if(Keyboard_Poll() == '*'){
				flag_uart =~ flag_uart;
			}
			keyboard_counter = 0;
    }
	}
}

