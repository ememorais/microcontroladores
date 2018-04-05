;------------Área de Código------------
;Tudo abaixo da diretiva a seguir será armazenado na memória de código

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        IMPORT  SysTick_Wait1ms
        
        EXPORT  Keyboard_Poll
        IMPORT  PortM_OutputKeyboard
        IMPORT  PortD_Input
                
keyboardArray = 1, 2, 3, 'A',\
                4, 5, 6, 'B',\
                7, 8, 9, 'C',\
                '*', 0, '#', 'D'

columnArray   = 2_01110000, 2_01101000, 2_01011000, 2_00111000
               
        ALIGN
 ;------------Keyboard_Poll------------
; Checa se alguma tecla foi pressionada.
; R0 itera entre colunas, 
Keyboard_Poll
    PUSH    {R0, R1, R2, R3, R4, R5, LR}
    MOV     R5, #0                  ;Coloca o iterador de colunas em 0
    LDR     R1, =columnArray        ;Coloca o endereço do column array em R1
    
keyboard_poll_loop
    LDR     R1, =columnArray        ;Coloca o endereço do column array em R1
    ADD     R1, R5                  ;Avança o endereço original até o offset calculado
    LDRB    R0, [R1]                ;Pega a halfword correspondente do columnArray
    BL      PortM_OutputKeyboard    ;Escreve na porta para ativar a coluna escolhida
    
    MOV     R0, #10
    BL      SysTick_Wait1ms         ;Espera 10ms antes de checar as entradas
    
    MOV     R0, #0x0F               ;Checa as entradas da porta L
    BL      PortD_Input 
    
    CMP     R0, #0x0F
    
    BEQ     pula_debug
    MOV     R0, R0
pula_debug
    
    ADD     R5, #1                  ;Adiciona 1 ao iterador de colunas
    
    CMP     R5, #4
    BGE     keyboard_poll_end
    B       keyboard_poll_loop


keyboard_poll_end
    POP     {R0, R1, R2, R3, R4, R5, LR}
    BX      LR
    
    
    
    ALIGN
    END
    
    
    
    
    
   



    
    
    