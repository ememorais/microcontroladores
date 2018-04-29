#include "motor_display.h"

uint8_t motorDisplay_strings[][17] = 
{
    {"MOTOR PARADO    "},
    {"VELOCIDADE: XXX%"},
    {"ROTACAO: XX     "},
    {"                "}
};

void MotorDisplay_Stopped(void) {
    LCD_PositionCursor(0, 0);
    LCD_PushCustomString(0, ((uint32_t)motorDisplay_strings));
    
    LCD_PositionCursor(1, 0);
    LCD_PushCustomString(3, ((uint32_t)motorDisplay_strings));
}

void MotorDisplay_Running(void) {
    LCD_PositionCursor(0, 0);
    LCD_PushCustomString(1, ((uint32_t)motorDisplay_strings));
    
    LCD_PositionCursor(0, 12);
    
    //Se o 3o dígito (motor_speed/100) for 1, manda '1'; senão manda um espaço vazio
    LCD_PushChar(((motor_speed / 100) == 1) ? '1': ' ');

    //Manda o 2o dígito ((motor_speed / 10) % 10) em ascii (+48)
    LCD_PushChar(((motor_speed / 10) % 10) + 48);

    //Manda o 3o dígito (motor_speed % 10) em ascii (+48)
    LCD_PushChar((motor_speed % 10) + 48);

    
    LCD_PositionCursor(1, 0);
    LCD_PushCustomString(2, ((uint32_t)motorDisplay_strings));
}
