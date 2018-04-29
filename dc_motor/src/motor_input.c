// motor_input.c
// Desenvolvido para a placa EK-TM4C1294XL
// Recebe e armazena dados do teclado que alteram o funcionamento do motor DC.
// Marcelo Fernandes e Bruno Colombo

#define LIB_LCD 2

#include <stdint.h>
#include "motor_input.h"

volatile uint32_t motor_speed = 0;
volatile uint32_t motor_direction = 0;


void MotorInput_Process(int input)
{
    if(input == 0)
    {
        motor_speed = 0;
        MotorDisplay_Stopped();
        return;
    }
    else if (input >= 1 && input <= 7)
    {
        motor_speed = 30 + (input*10);
        MotorInput_Control();
        MotorDisplay_Running();
        return;
    }
    else if (input == '*')
    {
        motor_direction = 0;
        MotorInput_Control();
        MotorDisplay_Running();
        return;
    }
    else if (input == '#')
    {
        motor_direction = 1;
        MotorInput_Control();
        MotorDisplay_Running();
        return;
    }
}

void MotorInput_Control(void) 
{
    PortF_Output_Dc_Motor(1 << (motor_direction+1));
}

