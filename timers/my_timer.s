
		THUMB

RCGCTIMER 			EQU 0x400FE604    ;ok
GPTMCTL_TIMER_0 	EQU 0x4003000C    ;ok
GPTMCFG_TIMER_0		EQU 0x40030000    ;ok
GPTMTAMR_TIMER_0	EQU 0x40030004    ;ok
GPTMTAILR_TIMER_0   EQU 0x40030028    ;ok
GPTMICR_TIMER_0		EQU 0x40030024    ;ok
GPTMIMR_TIMER_0		EQU 0x40030018    ;ok
NVIC_PRI4			EQU 0xE000E410    ;ok
EN0 				EQU 0xE000E100    ;ok



; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
		
		; Se alguma função do arquivo for chamada em outro arquivo	
		EXPORT Timer_Init
		; Se chamar alguma função externa	
        IMPORT PortN_Output
        EXPORT Timer0A_Handler
; -------------------------------------------------------------------------------
; Funções timer	
Timer_Init
		MRS  R0, BASEPRI			;Copia valor do BASEPRI para R0
		ORR  R0, #0x20		  
		MSR  BASEPRI, R0			;Altera valor do BASEPRI
		
		MRS  R0, PRIMASK			;Copia valor do PRIMASK para R0
		BIC  R0, #0x01		  
		MSR  PRIMASK, R0			;Altera valor do PRIMASK
		
		LDR  R0, =RCGCTIMER
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]        ;OK
		
		LDR  R0, =GPTMCTL_TIMER_0
		LDR  R1, [R0]
		BIC  R1, #0x01
		STR  R1, [R0]        ;OK
		
		LDR  R0, =GPTMCFG_TIMER_0
        LDR  R1, [R0]
		BIC  R1, #2_111
		STR  R1, [R0]   ;OK
		
		LDR	 R0, =GPTMTAMR_TIMER_0
		LDR  R1, [R0]
		BIC  R1, #0x02
		ORR  R1, #0x01
		STR  R1, [R0]        ;OK
		
		LDR  R0, =GPTMTAILR_TIMER_0
		MOV  R1, #0xB400
		MOVT R1, #0x04C4
		STR  R1, [R0]          ;OK
		
		LDR  R0, =GPTMICR_TIMER_0
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]             ;OK
		
		LDR  R0, =GPTMIMR_TIMER_0
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]             ;OK
		
		LDR  R0, =NVIC_PRI4
		LDR  R1, [R0]
		MOV  R2, #0x0000
		MOVT R2, #0xE000
		BIC  R1, R2                ;OK
		STR  R1, [R0]
		
		LDR  R0, =EN0
		LDR  R1, [R0]
		MOV  R2, #0x0000
		MOVT R2, #0x0008
		ORR  R1, R2
		STR  R1, [R0]        ;OK
		
		LDR  R0, =GPTMCTL_TIMER_0
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]      ;OK
		
		BX   LR
		
Timer0A_Handler
		LDR  R0, =GPTMICR_TIMER_0
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]
		MOV  R0, #2_11
		BL   PortN_Output		  	 	 
		
		BX	 LR
		
		NOP
		ALIGN 
		END
		