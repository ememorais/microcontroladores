#if LIB_KB != 2
      #warning "Vers�o do arquivo teclado errada! Verifique"
#endif

void Keyboard_Init(void);

uint8_t Keyboard_Poll(void);

