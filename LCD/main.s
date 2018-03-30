; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Defini��es de Valores
BIT0	    EQU 2_0001
BIT1	    EQU 2_0010
    

   

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us			
		IMPORT  GPIO_Init
        IMPORT  PortJ_Input
		IMPORT  PortK_Output
        IMPORT  PortM_Output
            
        IMPORT  LCD_Init


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
    BL LCD_Init                  ;Chama a subrotina que inicializa o LCD
    MOV R8, #'Q'

	
MainLoop
	BL  PortJ_Input				 ;Chama a subrotina que l� o estado das chaves e coloca o resultado em R0
	CMP R0, #2_00000000			 ;Verifica se a chave est� pressionada
	BNE MainLoop
	MOV R0, R8
    ADD R8, #1
    CMP R8, #'['
    IT EQ
    MOVEQ R8, #'A'
	BL  PortK_Output
	MOV R0, #2_00000101
	BL  PortM_Output
	MOV R0, #50
	BL  SysTick_Wait1us
	MOV R0, #2_00000000
	BL  PortM_Output
	MOV R0, #300
	BL  SysTick_Wait1ms
; ****************************************
; Escrever c�digo que l� o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************
	B MainLoop

;--------------------------------------------------------------------------------
; Fun��o Pisca_LED
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
; ****************************************
; Escrever fun��o que acende o LED, espera 1 segundo, apaga o LED e espera 1 s
; Esta fun��o deve chamar a rotina SysTick_Wait1ms com o par�metro de entrada em R0
; ****************************************

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo