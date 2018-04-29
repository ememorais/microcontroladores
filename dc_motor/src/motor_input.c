// motor_input.c
// Desenvolvido para a placa EK-TM4C1294XL
// Recebe e armazena dados do teclado que alteram o funcionamento do motor DC.
// Marcelo Fernandes e Bruno Colombo

#include <stdint.h>
#include "motor_input.h"

uint8_t Keyboard_Poll(void);

volatile uint32_t motor_speed = 0;
volatile uint32_t motor_direction = 0;

void MotorInput_Init(void)
{

}

void MotorInput_Query(void)
{
    uint8_t valor_lido = Keyboard_Poll();

    if(valor_lido == 0)
    {
        motor_speed = 0;
        MotorDisplay_Stopped();
        return;
    }
    else if (valor_lido >= 1 && valor_lido <= 7)
    {
        motor_speed = 30 + (valor_lido*10);
        MotorDisplay_Running();
        return;
    }
    else if (valor_lido == '*')
    {
        motor_direction = 0;
        MotorDisplay_Running();
        return;
    }
    else if (valor_lido == '#')
    {
        motor_direction = 1;
        MotorDisplay_Running();
        return;
    }
}
