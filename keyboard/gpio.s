; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN_AHB_DATA_BITS_R  EQU    0x40064000
GPIO_PORTN               	EQU    2_001000000000000	
; PORT K
GPIO_PORTK_AHB_LOCK_R    	EQU    0x40061520
GPIO_PORTK_AHB_CR_R      	EQU    0x40061524
GPIO_PORTK_AHB_AMSEL_R   	EQU    0x40061528
GPIO_PORTK_AHB_PCTL_R    	EQU    0x4006152C
GPIO_PORTK_AHB_DIR_R     	EQU    0x40061400
GPIO_PORTK_AHB_AFSEL_R   	EQU    0x40061420
GPIO_PORTK_AHB_DEN_R     	EQU    0x4006151C
GPIO_PORTK_AHB_PUR_R     	EQU    0x40061510	
GPIO_PORTK_AHB_DATA_R    	EQU    0x400613FC
GPIO_PORTK_AHB_DATA_BITS_R  EQU    0x40061000
GPIO_PORTK               	EQU    2_000001000000000
; PORT L
GPIO_PORTL_AHB_LOCK_R    	EQU    0x40062520
GPIO_PORTL_AHB_CR_R      	EQU    0x40062524
GPIO_PORTL_AHB_AMSEL_R   	EQU    0x40062528
GPIO_PORTL_AHB_PCTL_R    	EQU    0x4006252C
GPIO_PORTL_AHB_DIR_R     	EQU    0x40062400
GPIO_PORTL_AHB_AFSEL_R   	EQU    0x40062420
GPIO_PORTL_AHB_DEN_R     	EQU    0x4006251C
GPIO_PORTL_AHB_PUR_R     	EQU    0x40062510	
GPIO_PORTL_AHB_DATA_R    	EQU    0x400623FC
GPIO_PORTL_AHB_DATA_BITS_R  EQU    0x40062000
GPIO_PORTL               	EQU    2_000010000000000
; PORT M
GPIO_PORTM_AHB_LOCK_R    	EQU    0x40063520
GPIO_PORTM_AHB_CR_R      	EQU    0x40063524
GPIO_PORTM_AHB_AMSEL_R   	EQU    0x40063528
GPIO_PORTM_AHB_PCTL_R    	EQU    0x4006352C
GPIO_PORTM_AHB_DIR_R     	EQU    0x40063400
GPIO_PORTM_AHB_AFSEL_R   	EQU    0x40063420
GPIO_PORTM_AHB_DEN_R     	EQU    0x4006351C
GPIO_PORTM_AHB_PUR_R     	EQU    0x40063510	
GPIO_PORTM_AHB_DATA_R    	EQU    0x400633FC
GPIO_PORTM_AHB_DATA_BITS_R  EQU    0x40063000
GPIO_PORTM               	EQU    2_000100000000000
	

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortK_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortM_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
        EXPORT PortL_Input 
        EXPORT PortL_Output             

GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTK                 ;Seta o bit da porta K
            ORR     R1, #GPIO_PORTL                 ;Seta o bit da porta L, fazendo com OR
			ORR     R1, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
			ORR 	R1, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR 
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTK                 ;Seta os bits correspondentes �s portas para fazer a compara��o
            ORR 	R2, #GPIO_PORTL
			ORR     R2, #GPIO_PORTM                 
			ORR 	R2, #GPIO_PORTJ
            TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Destravar a porta somente se for o pino PD7
 
; 3. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
			LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
            LDR     R0, =GPIO_PORTK_AHB_AMSEL_R     
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTL_AHB_AMSEL_R		
            STR     R1, [R0]	
            LDR     R0, =GPIO_PORTM_AHB_AMSEL_R		
            STR     R1, [R0]	            
 
; 4. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
            LDR     R0, =GPIO_PORTK_AHB_PCTL_R		
            STR     R1, [R0]                        
            LDR     R0, =GPIO_PORTL_AHB_PCTL_R      
            STR     R1, [R0]                        
            LDR     R0, =GPIO_PORTM_AHB_PCTL_R      
            STR     R1, [R0]
            
; 5. DIR para 0 se for entrada, 1 se for sa�da
			LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
			MOV     R1, #0x00						
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTK_AHB_DIR_R		
			MOV     R1, #0xFF						
            STR     R1, [R0]						
			; O certo era verificar os outros bits da PJ para n�o transformar entradas em sa�das desnecess�rias
            LDR     R0, =GPIO_PORTL_AHB_DIR_R		
            MOV     R1, #0xF0               		;Entradas: L0 L1 L2 L3 // Sa�das: L4 L5 L6 L7
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTM_AHB_DIR_R		
            MOV     R1, #0x07               		
            STR     R1, [R0]						
; 6. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
			LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R		;Carrega o endere�o do AFSEL da porta J
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTK_AHB_AFSEL_R		
            STR     R1, [R0]	
            LDR     R0, =GPIO_PORTL_AHB_AFSEL_R		
            STR     R1, [R0]	            
            LDR     R0, =GPIO_PORTM_AHB_AFSEL_R     
            STR     R1, [R0]
            
; 7. Setar os bits de DEN para habilitar I/O digital
			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
            LDR     R1, [R0]							;Ler da mem�ria o registrador GPIO_PORTN_AHB_DEN_R
			MOV     R2, #BIT0
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
	
            LDR     R0, =GPIO_PORTK_AHB_DEN_R			;Carrega o endere�o do DEN
            LDR     R1, [R0]							;Ler da mem�ria o registrador GPIO_PORTN_AHB_DEN_R
			MOV     R2, #0xFF
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
            
            LDR     R0, =GPIO_PORTL_AHB_DEN_R			;Carrega o endere�o do DEN
            LDR     R1, [R0]							;Ler da mem�ria o registrador GPIO_PORTL_AHB_DEN_R
			MOV     R2, #0xFF
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
 
            LDR     R0, =GPIO_PORTM_AHB_DEN_R			;Carrega o endere�o do DEN
            LDR     R1, [R0]                            ;Ler da mem�ria o registrador GPIO_PORTN_AHB_DEN_R
			MOV     R2, #0x07                           
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			
; 8. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
			MOV     R1, #BIT0							;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
			BX      LR
            LDR     R0, =GPIO_PORTL_AHB_PUR_R			;Carrega o endere�o do PUR para a porta 
            MOV     R1, #0x0F							;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
            BX      LR

; -------------------------------------------------------------------------------
; Fun��o PortN_Output
; Par�metro de entrada: R0
; Par�metro de sa�da: N�o tem
PortK_Output
	LDR	R1, =GPIO_PORTK_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x03FC							;Soma ao offset o endere�o do bit 1 para ser 
											;uma escrita amig�vel
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
	BX LR									;Retorno

PortL_Output
    PUSH {R1}
	LDR	R1, =GPIO_PORTL_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x03C0							
											
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
    POP {R1}
	BX LR									;Retorno	


PortM_Output
	LDR	R1, =GPIO_PORTM_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x001C							;Soma ao offset o endere�o do bit 1 para ser 
											;uma escrita amig�vel
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
	BX LR									;Retorno	

; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
    
	LDR	R1, =GPIO_PORTJ_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x0004							;Soma ao offset o endere�o dos bit 0 e 1 para 
											;serem os �nicos a serem lidos tem uma leitura amig�vel
	LDR R0, [R1]                            ;L� no barramento de dados nos pinos J0 e J1 somente
	
    BX LR									;Retorno
    
PortL_Input
    PUSH {R1}
    
	LDR	R1, =GPIO_PORTL_AHB_DATA_BITS_R		
	ADD R1, #0x3C
    
	LDR R0, [R1]
    
    POP {R1}    
	BX LR									



    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo