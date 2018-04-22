DATA_POINTER        EQU 0x20000500
DATA_ROTATIONS      EQU 0x20000504
DATA_DIRECTION      EQU 0x20000508
DATA_SPEED          EQU 0x2000050C
DATA_READY          EQU 0x20000510

STATE_FLAG 	        EQU 0x20001000
LAST_STATE_FLAG     EQU 0x20001004
INPUT_FLAG          EQU 0x20001008


        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        IMPORT  Keyboard_Poll
            
        IMPORT  LCD_PushConfig
        IMPORT  LCD_PushString
        IMPORT  LCD_PushChar
        IMPORT  LCD_ClearLine_2
            
        EXPORT  Winder_Query
        EXPORT  Winder_Init
            
        ALIGN


    
    
Winder_Init
    MOV     R1, #0xFF
    LDR     R0, =LAST_STATE_FLAG
    STR     R1, [R0]
    
    MOV     R1, #0x00
    LDR     R0, =STATE_FLAG
    STR     R1, [R0]
    
    MOV     R1, #0x00
    LDR     R0, =DATA_POINTER
    STR     R1, [R0]
    
    MOV     R1, #0x00
    LDR     R0, =INPUT_FLAG
    STR     R1, [R0]
    
    MOV     R1, #0x00
    LDR     R0, =DATA_READY
    STR     R1, [R0]
    

    

Winder_Query
    PUSH    {R0, R1, R2, R3, LR}
    
    LDR     R0, =STATE_FLAG             ;Carrega valor atual da flag string em R1
    LDR     R1, [R0]    
    
    LDR     R0, =LAST_STATE_FLAG        ;Carrega ultimo valor da flag string em R0
    LDR     R2, [R0]
    
            
    
    CMP     R2, R1                      ;Pula para input do botão se valor não mudou
    BEQ     winder_button_input
    
    STR     R1, [R0]                    ;Atualiza o ultimo valor lido com o valor atual
    
winder_state_rotation                   
    CMP     R1, #0
    BNE     winder_state_direction
    
    MOV     R0, R1                      ;Atualiza display com string [0]
    BL      Display_Query
    
    LDR     R0, =DATA_ROTATIONS         ;Coloca dado de rotação no ponteiro de dados
    LDR     R1, =DATA_POINTER
    STR     R0, [R1]
    
    B       winder_button_input
winder_state_direction
    CMP     R1, #1
    BNE     winder_state_speed          
    
    MOV     R0, R1                      ;Atualiza display com string [1]
    BL      Display_Query
    
    LDR     R0, =DATA_DIRECTION         ;Coloca dado de direção no ponteiro de dados
    LDR     R1, =DATA_POINTER
    STR     R0, [R1]
    
    B       winder_button_input
winder_state_speed
    CMP     R1, #2
    BNE     winder_state_execute        
    
    MOV     R0, R1                      ;Atualiza display com string [2]
    BL      Display_Query               
                                        
    LDR     R0, =DATA_SPEED             ;Coloca dado de velocidade no ponteiro de dados
    LDR     R1, =DATA_POINTER
    STR     R0, [R1]
    
winder_state_execute
    CMP     R1, #3
    BNE     winder_button_input
    
    MOV     R0, R1                      ;Atualiza display com string [3]
    BL      Display_Query
    
    LDR     R2, =INPUT_FLAG             ;Coloca input em um estado onde não é feita leitura
    MOV     R0, #0xFF
    STR     R0, [R2]
    
    BL      Winder_SanitizeInput        ;Trata os dados lidos, transformando-os em valores aceitáveis
    
    NOP
    ;LÓGICA DE EXECUÇÃO VAI NESTE ESTADO
    
  
    
winder_button_input
    LDR     R0, =INPUT_FLAG             ;Carrega valor atual da flag input em R1
    LDR     R1, [R0]    

    BL      Keyboard_Poll               ;Coloca em R0 resultado do teclado e ignora se for 0xFF (sem pressionamento)
    CMP     R0, #0xFF
    BEQ     winder_end
    
    CMP     R0, #'#'                    ;Caso detecte pressionamento de #, pula direto para confirmação
    IT      EQ
    MOVEQ   R1, #2
    
winder_button_lsd
    CMP     R1, #0x00
    BNE     winder_button_msd
    
    LDR     R2, =DATA_POINTER           ;Coloca o valor lido na memoria
    LDR     R2, [R2]
    STR     R0, [R2]
    
    ADD     R0, #48                     ;Coloca o valor lido no LCD
    BL      LCD_PushChar
    
    LDR     R2, =INPUT_FLAG             ;Passa flag de input para próxima posição
    MOV     R0, #1
    STR     R0, [R2]
    B       winder_end

winder_button_msd
    CMP     R1, #0x01
    BNE     winder_button_confirm
     
    PUSH    {R0}
    
    LDR     R2, =DATA_POINTER           ;Multiplica o valor na memória por 10 e soma o valor lido agora
    LDR     R2, [R2]
    LDR     R0, [R2]
    
    MOV     R1, #10
    MUL     R0, R1
    
    MOV     R1, R0
    POP     {R0}
    ADD     R1, R0
    
    STR     R1, [R2]
    
    ADD     R0, #48                     ;Coloca o valor lido no LCD
    BL      LCD_PushChar
    
    LDR     R2, =INPUT_FLAG             ;Passa flag de input para próxima posição
    MOV     R0, #2
    STR     R0, [R2]
    B       winder_end

winder_button_confirm
    CMP R0, #'#'
    BNE winder_end
    
    LDR     R2, =STATE_FLAG             
    LDR     R0, [R2]
    
    CMP     R0, #0x03                   ;Se flag atual for 0xFF, não faz nada
    BEQ     winder_end
    
    ADD     R0, #1                      ;Passa flag de string para próxima posição
    STR     R0, [R2]
    
    LDR     R2, =INPUT_FLAG             ;Reseta a flag de input
    MOV     R0, #0
    STR     R0, [R2]
    
    BL      LCD_ClearLine_2             ;Limpa 2a linha do LCD
    
    

winder_end
    POP     {R0, R1, R2, R3, LR}
    BX      LR
    
    
    
Winder_SanitizeInput 
    PUSH    {R0, R1, LR}
    LDR     R1, =DATA_ROTATIONS
    LDR     R0, [R1]
    
    CMP     R0, #0                      ;Se o no de rotações for 0, coloca 1 rotação
    ITT     EQ
    ADDEQ   R0, #1
    STREQ   R0, [R1]
    
    CMP     R0, #10                     ;Se o no de rotações for >10, coloca 10 rotações
    ITT     GT
    MOVGT   R0, #10
    STRGT   R0, [R1]
    
    
    LDR     R1, =DATA_DIRECTION          
    LDR     R0, [R1]
    
    CMP     R0, #0                      ;Se a direção for != 0, coloca 1
    ITT     NE
    MOVNE   R0, #1
    STRNE   R0, [R1]
    
    LDR     R1, =DATA_SPEED             ;Se a velocidade for != 0, coloca 1
    LDR     R0, [R1]
    
    CMP     R0, #0
    ITT     NE
    MOVNE   R0, #1
    STRNE   R0, [R1]
    

    POP     {R0, R1, LR}
    BX      LR



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