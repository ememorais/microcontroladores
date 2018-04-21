        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        IMPORT  LCD_PushConfig
        IMPORT  LCD_PushString
        IMPORT  LCD_PushChar
            
        EXPORT  Winder_Query
        EXPORT  Winder_Init
            
        ALIGN


STRING_FLAG 	    EQU 0x20001000
LAST_STRING_FLAG    EQU 0x20001004
INPUT_FLAG          EQU 0x20001008
LAST_INPUT_FLAG     EQU 0x20001008
    
Winder_Init
    MOV     R1, #0xFF
    LDR     R0, =LAST_STRING_FLAG
    STR     R1, [R0]
    MOV     R1, #0x00
    LDR     R0, =STRING_FLAG
    STR     R1, [R0]
    BX      LR

    

Winder_Query
    PUSH    {R0, R1, R2, LR}

    ;Se a flag de string atual é diferente da anterior, atualiza
    ;a string no LCD de acordo com a flag
    
    LDR     R0, =STRING_FLAG        ;Carrega valor atual da flag string em R1
    LDR     R1, [R0]    
    
    LDR     R0, =LAST_STRING_FLAG   ;Carrega ultimo valor da flag string em R0
    LDR     R2, [R0]
    
            
    
    CMP     R2, R1                  ;Pula para input do botão se valor não mudou
    BEQ     winder_button_input
    
    STR     R1, [R0]                ;Atualiza o ultimo valor lido com o valor atual
    
winder_string_rotation              ;Escolhe uma frase dependendo do valor de 
    CMP     R1, #0
    BNE     winder_string_direction
    MOV     R0, R1
    BL      Display_Query
    B       winder_button_input
winder_string_direction
    CMP     R1, #1
    BNE     winder_string_speed
    MOV     R0, R1
    BL      Display_Query
    B       winder_button_input
winder_string_speed
    CMP     R1, #2
    BNE     winder_button_input
    MOV     R0, R1
    BL      Display_Query
  
    
winder_button_input


winder_end
    POP     {R0, R1, R2, LR}
    BX LR

Display_Query
    PUSH    {R0, LR}
    PUSH    {R0}
    MOV     R0, #0x80              	;Coloca cursor na 1a posição da 1a linha
    BL      LCD_PushConfig
    
    POP     {R0}
    ADD     R0, #2
    BL      LCD_PushString
    
    MOV     R0, #0xC0               ;Coloca cursor na 1a posição da 2a linha
    BL      LCD_PushConfig
    
    POP     {R0, LR}
    BX      LR
    

    
    
    ALIGN
    END