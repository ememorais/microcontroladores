// adc.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa ADC
// Marcelo Fernandes e Bruno Colombo

#include <stdint.h>

#include "tm4c1294ncpdt.h"

// Função ADC_Init
// Inicializa o ADC
// Parâmetro de entrada: Não tem
// Parâmetro de saída: Não tem

void ADC_Init(void)
{
	SYSCTL_RCGCADC_R |= 0x01;
	
	while((SYSCTL_PRADC_R & 0x01 ) != (0x01)){};
		
	SYSCTL_PCADC_R |= 0x07;
		
	ADC0_SSPRI_R &= ~0x3000;
	
	ADC0_ACTSS_R &= ~0x08;
	
	ADC0_EMUX_R &= ~0xF000;
	
	ADC0_SSMUX3_R &= ~0x0F;
	
	ADC0_SSCTL3_R |= 0x0F;
	
	ADC0_SSCTL3_R &= ~0x09;
		
	ADC0_ACTSS_R |= 0x08;
	
}

// Função Exec_ADC
// Executa conversão analógica para digital, utiliza o pino PE3
// Parâmetro de entrada: Não tem
// Parâmetro de saída: valor digital de 8 bits da leitura

uint32_t Exec_ADC(void)
{
	ADC0_PSSI_R |= 0x08;
	
	while((ADC0_RIS_R & 0x08) != (0x08)){};
	
	uint32_t digital_measurement = ADC0_SSFIFO3_R;
	
	digital_measurement &= ~0xFFFFF000;
	
	digital_measurement >>= 4;
	
	ADC0_ISC_R |= 0x08;	
	
	return digital_measurement;
}
