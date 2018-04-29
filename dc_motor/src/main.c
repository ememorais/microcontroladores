// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// TODO: explicação

#define LIB_LCD     2
#define LIB_KB      2
#define LIB_UTILS   2

#include <stdint.h>
#include "lcd.h"
#include "motor_input.h"
#include "utils.h"
#include "keyboard.h"
#include "timer.h"

void PLL_Init(void);
void SysTick_Init(void);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);

extern volatile uint32_t motor_speed;
extern volatile uint32_t motor_direction;
extern volatile uint32_t timer_counter;

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
    LCD_Init();
	Keyboard_Init();
    Timer_Init();
    
    MotorInput_Process(0);

	while(1) 
	{
		SysTick_Wait1ms(50);
		MotorInput_Process(Keyboard_Poll());
		if(timer_counter >= 1000)
		{
			timer_counter = 0;
			motor_speed++;
			MotorDisplay_Running();
		}
	}
}

