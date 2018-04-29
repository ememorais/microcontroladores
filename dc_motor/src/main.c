// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// TODO: explicação

#define LIB_LCD     2
#define LIB_KB      2
#define LIB_UTILS   2

#include <stdint.h>
#include "globals.h"
#include "lcd.h"
#include "dc_motor.h"
#include "utils.h"
#include "keyboard.h"
#include "timer.h"

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
    
    Motor_Process(0);

	while(1) 
	{
		SysTick_Wait1ms(50);
		Motor_Process(Keyboard_Poll());
		if(timer_counter >= 1000)
		{
			timer_counter = 0;
			motor_speed++;
			Motor_DisplayRunning();
		}
	}
}

