// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);
void LCD_Init(void);



int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
    LCD_Init();
    
    LCD_PushString(4);

	while(1) 
	{
		
	}
}

