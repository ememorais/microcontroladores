;------------�rea de C�digo------------
;Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de c�digo
COLUMN_ARRAY_SIZE EQU 4

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        IMPORT  SysTick_Wait1ms
        
        EXPORT  Keyboard_Poll
        IMPORT  PortA_Output
        IMPORT  PortD_Input
                
keyboardArray = 1, 2, 3, 'A',\
                4, 5, 6, 'B',\
                7, 8, 9, 'C',\
                '*', 0, '#', 'D'

columnArray   = 2_1110, 2_1101, 2_1011, 2_0111
               
        ALIGN
 ;------------Keyboard_Poll------------
; Checa se alguma tecla foi pressionada.
; R0 itera entre colunas, 
Keyboard_Poll
    PUSH    {R0, R1, R2, R3, R4, R5, LR}
    MOV     R5, #0                  ;Coloca o iterador de colunas em 0
    LDR     R1, =columnArray        ;Coloca o endere�o do column array em R1
;    MOV     R2, #COLUMN_ARRAY_SIZE  ;Coloca o tamanho da coluna no R2
    
keyboard_poll_loop
    LDR     R1, =columnArray        ;Coloca o endere�o do column array em R1
;    MUL     R3, R2, R5              ;Coloca o offset de leitura em R3 (iterador * tamanho do vetor)
    ADD     R1, R5                  ;Avan�a o endere�o original at� o offset calculado
    LDRB    R0, [R1]                ;Pega a halfword correspondente do columnArray
    BL      PortA_Output            ;Escreve na porta para ativar a coluna escolhida
    
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
    
    
    
    
    
   



    
    
    