#include "motor_display.h"

uint8_t motorDisplay_strings[][17] = 
{
    {"MOTOR PARADO    "},
    {"VELOCIDADE: XXX%"},
    {"ROTACAO: XX     "}
};

void MotorDisplay_Stopped(void) {
    LCD_PushConfig(0x80);
    LCD_PushCustomString(0, ((uint32_t)motorDisplay_strings));
}

void MotorDisplay_Running(void) {

}
