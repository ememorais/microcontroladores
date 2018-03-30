;------------Constantes------------
DELAY_SMALL EQU 400
DELAY_BIG   EQU 4
STRING_SIZE EQU 17

;------------Área de Código------------
;Tudo abaixo da diretiva a seguir será armazenado na memória de código

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        EXPORT  LCD_Init
        EXPORT  LCD_PushConfig
        EXPORT  LCD_PushString
         
        IMPORT  SysTick_Wait1ms
        IMPORT  SysTick_Wait1us
        IMPORT  PortJ_Input
        IMPORT  PortK_Output
        IMPORT  PortM_Output
              ;...-...-...-...-
line0       = "UTFPR           ",0
line1       = "2018            ",0
line2       = "BRUNO E MARCELO ",0
line3       = "EQUIPE Nº 8     ",0
lineDefault = "STRING NOT FOUND",0

        ALIGN
            
;------------LCD_Init------------
; Configura o sistema para utilizar o LCD.
; Tabela: Pág 24 - https://goo.gl/HmbeUC
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
    
	MOV  R0, #50
	BL   SysTick_Wait1ms
    
    POP {R0, LR}
    BX  LR

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
    MOV R0, #2_00000000
    BL  PortM_Output
    POP {R1, R2, LR}
    BX  LR
    
    
LCD_PushString
;------------LCD_PushString------------
    PUSH {R0, R4, R5, R6, LR}
    MOV R6, #17
    LDR R4, =line0
    MUL R5, R0, R6
    ADD R4, R5

stringCopy
    LDRB R0, [R4], #1
    CMP R0, #0
    BEQ stringCopy_end 
    BL  LCD_PushChar
    B   stringCopy
stringCopy_end    
    POP {R0, R4, R5, R6, LR}
    BX  LR

LCD_PushChar
    PUSH {R0, R2, LR}
    MOV R2, R0
    MOV R0, #2_00000000
    BL  PortM_Output
    MOV R0, R2
    BL  PortK_Output
    MOV R0, #2_00000101
    BL  PortM_Output
    MOV R0, #DELAY_SMALL
    BL  SysTick_Wait1us
    MOV R0, #2_00000000
    BL  PortM_Output
    POP {R0, R2, LR}
    BX  LR

    
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo