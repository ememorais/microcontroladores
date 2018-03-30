;------------Constantes------------
DELAY_SMALL EQU 400
DELAY_BIG   EQU 4



        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        EXPORT  LCD_Init
         
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us			
        IMPORT  PortJ_Input
		IMPORT  PortK_Output
        IMPORT  PortM_Output
            
;TABELA: Pág 24 - http://moodle.utfpr.edu.br/pluginfile.php/412456/mod_resource/content/1/Datasheet_HD44780.pdf

;------------LCD_Init------------
; Configura o sistema para utilizar o LCD.
; Entrada: Nenhum
; Saída: Nenhum
; Modifica: R0, R1
LCD_Init
    PUSH {R0, LR}
    
    MOV R0, #0x01
    BL  LCD_PushConfig
	MOV R0, #DELAY_BIG
    BL  SysTick_Wait1ms   
    
    ;Entry Mode Set 
    MOV R0, #2_00000110     ;(0 0 0 0 0 1 I/D S) 
    BL LCD_PushConfig
    
    ;Function Set 
    MOV R0, #2_00111000     ;(0 0 1 DL N F - -)
    BL  LCD_PushConfig
    
    ;Display on/off control
	
	MOV R0, #2_00001110     ;(0 0 0 0 1 D C B)          
	BL  LCD_PushConfig
    
    ;Return home            ;(0 0 0 0 0 0 1 -)
    MOV R0, #2_00000010
    BL  LCD_PushConfig
    
    POP {R0, LR}
    BX LR

;------------LCD_PushConfig------------
; Envia dados no modo config para o controlador do LCD.
; Entrada: R0 --> Dado a ser enviado
; Saída: Nenhum
; Modifica: R0, R1 (temporariamente), R2 (temporariamente)
LCD_PushConfig
    PUSH {R1, R2, LR}
    MOV R2, R0
	MOV R0, #2_00000000             
	BL  PortM_Output
	MOV R0, R2             
	BL  PortK_Output
	MOV R0, #2_00000100             
	BL  PortM_Output
	MOV R0, #DELAY_SMALL
	BL  SysTick_Wait1us
    POP {R1, R2, LR}
    BX LR
    
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo