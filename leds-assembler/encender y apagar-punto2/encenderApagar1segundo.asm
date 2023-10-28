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
C3 EQU 0x22

; 1. Encender y apagar los LEDs cada un segundo
; -------------------------
CICLO1
    CALL RETARDO1S ; Retardo de un segundo
    MOVLW B'00001111'  ; Encendemos los primeros 4 LEDs
    MOVWF PORTB
    CALL RETARDO1S ; Retardo de un segundo
    MOVLW B'00000000'  ; Apagamos los LEDs
    MOVWF PORTB
    GOTO CICLO1

RETARDO1S							; Subrutina delay de 1 seg
			MOVLW D'5'				; Coloca 5 decimal en W
			MOVWF C1				; Coloca el contenido de W en CONT1
ARRIBA								; Subrutina auxiliar
			MOVLW D'255'			; Coloca 255 decimal en W
			MOVWF C2				; Coloca el contenido de W en CONT2
BUCLE1								; Subrutina auxiliar
			MOVLW D'255'			; Coloca 255 decimal en W
			MOVWF C3				; Coloca el contenido de W en CONT3
REPITE1								; Subrutina auxiliar
			DECFSZ C3,1			; Decrementa CONT3 si no es cero
			GOTO REPITE1			; Va a REPITE1
			DECFSZ C2,1			; Decrementa CONT2 si no es cero
			GOTO BUCLE1				; Va a BUCLE1
			DECFSZ C1,1			; Decrementa CONT1 si no es cero
			GOTO ARRIBA				; Va a ARRIBA
			RETURN					; Sale de la subrutina
			
			
	END
