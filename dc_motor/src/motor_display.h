#include <stdint.h>
#include "lcd.h"

extern volatile uint32_t motor_speed;
extern volatile uint32_t motor_direction;

void MotorDisplay_Stopped(void);

void MotorDisplay_Running(void);
