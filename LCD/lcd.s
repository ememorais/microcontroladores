;------------Constantes------------
DELAY_SMALL EQU 200
DELAY_BIG   EQU 2



        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        EXPORT  LCD_Init
         
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us			
        IMPORT  PortJ_Input
		IMPORT  PortK_Output
        IMPORT  PortM_Output
;------------LCD_Init------------
; Configura o sistema para utilizar o LCD.
; Entrada: Nenhum
; Saída: Nenhum
; Modifica: R0, R1
LCD_Init
    PUSH {R0, LR}
	MOV R0, #2_00000000             ;Desabilita comunicação (!RS|!RW|!EN)
	BL  PortM_Output
    
	MOV R0, #0x01                   ;Envia dado -> RESET
	BL  PortK_Output
    MOV R0, #DELAY_SMALL
    BL  SysTick_Wait1us
	MOV R0, #2_00000100             ;Habilita modo config (!RS|!RW|EN)
	BL  PortM_Output
	MOV R0, #DELAY_BIG
    BL  SysTick_Wait1ms

	MOV R0, #2_00000000             ;Desabilita comunicação (!RS|!RW|!EN)
	BL  PortM_Output
	MOV R0, #0x38                   ;Envia dado config -> (CONFIG|8BITS|2LINHAS)
	BL  PortK_Output
	MOV R0, #2_00000100             ;Habilita modo config (!RS|!RW|EN)
	BL  PortM_Output
	MOV R0, #DELAY_SMALL
	BL  SysTick_Wait1us
    
;	MOV R0, #2_00000000             
;	BL  PortM_Output
;	MOV R0, #0x06                   
;	BL  PortK_Output
;	MOV R0, #2_00000100
;	BL  PortM_Output
;	MOV R0, #DELAY_SMALL
;	BL  SysTick_Wait1us

	MOV R0, #2_00000000             ;Desabilita comunicação (!RS|!RW|!EN)
	BL  PortM_Output
	MOV R0, #0x0E                   ;Envia dado config cursor -> (DISPLAY|CURSOR|PISCA)
	BL  PortK_Output
	MOV R0, #2_00000100             ;Habilita modo config (!RS|!RW|EN)
	BL  PortM_Output
	MOV R0, #DELAY_SMALL
	BL  SysTick_Wait1us
    
	;MOV R0, #2_00000000
	;BL  PortM_Output
	;MOV R0, #0x02
	;BL  PortK_Output
	;MOV R0, #2_00000100
	;BL  PortM_Output
	;MOV R0, #DELAY_BIG
	;BL  SysTick_Wait1ms
	;MOV R0, #2_00000000
	;BL  PortM_Output
    
    POP {R0, LR}
    BX LR
    
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo