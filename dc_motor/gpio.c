// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron


#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORT_J 0x0100
#define GPIO_PORT_K 0x0200
#define GPIO_PORT_L 0x0400
#define GPIO_PORT_M 0x0800
#define GPIO_PORT_N 0x1000

#define GPIO_PORTS (GPIO_PORT_J|GPIO_PORT_K|GPIO_PORT_M|GPIO_PORT_N)

#define GPIO_PORTN_LEDS   	(*((volatile uint32_t *)0x4006403C))
#define GPIO_PORTJ_BOTOES 	(*((volatile uint32_t *)0x4006003C))
#define GPIO_PORTK_LCD_DATA	(*((volatile uint32_t *)0x400613FC))
#define GPIO_PORTM_LCD_CTRL (*((volatile uint32_t *)0x4006301C))


// -------------------------------------------------------------------------------
// Fun��o GPIO_Init
// Inicializa os ports J e N
// Par�metro de entrada: N�o tem
// Par�metro de sa�da: N�o tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R |= GPIO_PORTS;

	//1b.   ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
  	while((SYSCTL_PRGPIO_R & (GPIO_PORTS) ) != (GPIO_PORTS) ){};
	
	// 2. Destravar a porta somente se for o pino PD7 e PE7
		
	// 3. Limpar o AMSEL para desabilitar a anal�gica
	GPIO_PORTJ_AHB_AMSEL_R 	= 0x00;
	GPIO_PORTK_AMSEL_R 		= 0x00;
	GPIO_PORTM_AMSEL_R		= 0x00;
	GPIO_PORTN_AMSEL_R 		= 0x00;
		
	// 4. Limpar PCTL para selecionar o GPIO
	GPIO_PORTJ_AHB_PCTL_R 	= 0x00;
	GPIO_PORTK_PCTL_R		= 0x00;
	GPIO_PORTM_PCTL_R		= 0x00;
	GPIO_PORTN_PCTL_R 		= 0x00;

	// 5. DIR para 0 se for entrada, 1 se for sa�da
	GPIO_PORTJ_AHB_DIR_R 	= 0x00;
	GPIO_PORTK_DIR_R		= 0xFF;
	GPIO_PORTM_DIR_R		= 0x07;
	GPIO_PORTN_DIR_R 		= 0x03;
		
	// 6. Limpar os bits AFSEL para 0 para selecionar GPIO sem fun��o alternativa	
	GPIO_PORTJ_AHB_AFSEL_R 	= 0x00;
	GPIO_PORTK_AFSEL_R		= 0x00;
	GPIO_PORTM_AFSEL_R		= 0x00;
	GPIO_PORTN_AFSEL_R 		= 0x00;

		
	// 7. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTJ_AHB_DEN_R 	= 0x03;
	GPIO_PORTK_DEN_R		= 0xFF;
	GPIO_PORTM_DEN_R		= 0x07; 
	GPIO_PORTN_DEN_R 		= 0x03;

	
	// 8. Habilitar resistor de pull-up interno, setar PUR para 1
	GPIO_PORTJ_AHB_PUR_R 	= 0x03;	

}	

// -------------------------------------------------------------------------------
// Fun��o PortJ_Input
// L� os valores de entrada do port J
// Par�metro de entrada: N�o tem
// Par�metro de sa�da: o valor da leitura do port
uint32_t PortJ_Input(void)
{
	return GPIO_PORTJ_BOTOES;
}

void PortK_Output(uint32_t valor)
{
	GPIO_PORTK_LCD_DATA = valor;
}

void PortM_Output(uint32_t valor)
{
	GPIO_PORTM_LCD_CTRL = valor;
}


// -------------------------------------------------------------------------------
// Fun��o PortN_Output
// Escreve os valores no port N
// Par�metro de entrada: Valor a ser escrito
// Par�metro de sa�da: n�o tem
void PortN_Output(uint32_t valor)
{
	//Ponteiro para o valor dos bits com leitura amig�vel
	GPIO_PORTN_LEDS = valor;
}




