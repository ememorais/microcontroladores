        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        IMPORT  LCD_PushConfig
        IMPORT  LCD_PushString
		IMPORT  LCD_PushChar
            
        EXPORT  Display_QueryRotation
            
Display_QueryRotation
    PUSH    {R0, LR}
    MOV     R0, #0x80              	;Coloca cursor na 1a posição da 1a linha
	BL	    LCD_PushConfig
	
	MOV	    R0, #2                  ;Manda string [2] para o display
    BL      LCD_PushString
    
    MOV R0, #0xC0                   ;Coloca cursor na 1a posição da 2a linha
	BL	    LCD_PushConfig
    
    POP     {R0, LR}
    BX      LR
    
    
    ALIGN
    END