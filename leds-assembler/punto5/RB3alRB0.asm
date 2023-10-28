	LIST P=pic16F628A
	INCLUDE <P16F628A.INC>
	__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC

; ---------------------------
; --- CONFIGURACIÓN PUERTOS ---
; ---------------------------
	ORG 0x00
	CLRF PORTB     ; Limpiamos PORTB
	BSF STATUS,RP0 ; Colocamos en 1 el bit RP0
	CLRF TRISB     ; Limpiamos TRISB, marcándolo como salida
	BCF STATUS,RP0 ; Regresamos al banco 0

; *** INICIO DE PROGRAMA ***
; ---------------------------

; Definición e inicialización de registros de trabajo
C1 EQU 0x20
C2 EQU 0x21

; 1. Encender y apagar los LEDs cada un segundo
; -------------------------
CICLO1
	
	

      ; Encendemos los primeros 4 LEDs
    BSF PORTB,0
    CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
    BSF PORTB,1  ; Encendemos los primeros 4 LEDs
    
    CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
    BSF PORTB,2
    CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
    BSF PORTB,3
    CALL Ir_Apagando
    
    GOTO CICLO1

Ir_Apagando
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BCF PORTB,3
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BCF PORTB,2
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BCF PORTB,1
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BCF PORTB,0
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	return
Retardo_200ms
			MOVLW D'200'				;x		
			GOTO Retardo_Pedido_Ms
Retardo_100ms
			MOVLW D'100'						
			GOTO Retardo_Pedido_Ms
					
;Rutina de retarde pedido	
Retardo_Pedido_Ms
	 		MOVWF C2
;Rutina 1ms		
Retraso_1miliSegundo									
			MOVLW D'249' 			;y	
			MOVWF C1				
Regresa_1Ms									
			NOP	 			
			DECFSZ C1,1	 		
			GOTO Regresa_1Ms
;fin 1ms
			DECFSZ C2,1   ;se ejecuta 1ms las veces pedidas
			goto Retraso_1miliSegundo	
			return				
						
	
	;Cm = t (mhz/4)
	; cm= t (4/4)
	;cm= t(en us)
	;1cm->1us
	

	END
