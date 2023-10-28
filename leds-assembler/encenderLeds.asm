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

CICLO1
	BSF PORTB, 0
	BSF PORTB, 1
	BSF PORTB, 2
	BSF PORTB, 3
	GOTO CICLO1
	END