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

	; Variables de control
CapacidadMax_Agua EQU 0x20 ; Capacidad máxima del termotanque en litros
CantidadAgua EQU 0x21 ; Cantidad inicial de agua (simulación)
C1 EQU 0x22
C2 EQU 0x23
C3 EQU 0x24
Temp_max  EQU 0x25 ; Temperatura máxima
Temp_min EQU 0x26 ; Temperatura mínima
Temp_agua EQU 0x27 ; Temperatura agua
CantidadAgua50 EQU 0x28

; Configurar registros necesarios
	MOVLW D'50' ; Cantidad actual de agua, simulada
    MOVWF CantidadAgua ; Inicializar cantidad de agua
   	MOVLW D'110' ; Capacidad maxima de agua
    MOVWF CapacidadMax_Agua ; Inicializar capacidad maxima de agua
	MOVLW D'20' ; Temperatura inicial del agua (simulación)
	MOVWF Temp_agua ; Inicializar temperatura actual de agua
	MOVLW D'45' ; Temperatura máxima del agua
    MOVWF Temp_max ; Inicializar temperatura máxima
	MOVLW D'20' ; Temperatura minima del agua
    MOVWF Temp_min ; Inicializar temperatura minima
	MOVLW D'0' ;
    MOVWF C3 ; 
	MOVLW D'50' ;
    MOVWF CantidadAgua50 ; 
    
	; *** INICIO DE PROGRAMA ***
	; ---------------------------


INICIO

	; Comparar CantidadAgua con la capacidad máxima (110 litros)
	MOVF CantidadAgua, W ; Mover el valor de CantidadAgua a WREG
	SUBWF CapacidadMax_Agua, W ; Restar la capacidad máxima de agua y almacenar el resultado en WREG
	BTFSS STATUS, Z ; Comprobar si el resultado es cero (es decir, CantidadAgua < 110)
	CALL AguaMenosDe110 ; Saltar a la etiqueta si la cantidad de agua es menor de 110 litros, es decir que la resta no dio 0
	CALL VerificandoAgua
	CALL Prender_TempMax
	CALL AbrirCanilla
	CALL Bomba_Resistencia   
    GOTO INICIO




   
	; Etiqueta para cuando la cantidad de agua es menor de 110 litros
AguaMenosDe110
	BSF PORTB, 0 ; Activar el puerto RB0 (encender el LED o realizar alguna otra acción)
LOOP
 	; Decrementar la cantidad de agua en 1 litro cada medio segundo
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	INCF CantidadAgua, F
	MOVF CantidadAgua, W ; Mover el valor de CantidadAgua a WREG
	SUBWF CapacidadMax_Agua, W ; Restar la capacidad máxima de agua y almacenar el resultado en WREG
	BTFSS STATUS, Z ; Comprobar si el resultado es cero (es decir, CantidadAgua < 110)
	GOTO LOOP
	BCF PORTB, 0 ; Apagar el puerto RB0 (apagar el LED)
	RETURN

VerificandoAgua
	BSF PORTB, 1 ; Activar el puerto RB1 (encender el LED o realizar alguna otra acción)
	
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BCF PORTB, 1 ; Desactivar el puerto RB1 (apagar el LED o realizar alguna otra acción)
	; Verificar la temperatura del agua
    MOVF Temp_agua, W ; Cargar la temperatura actual del agua en WREG
    SUBWF Temp_max, W ; Restar la temperatura máxima
    BTFSS STATUS, Z ; Comprobar si el resultado es cero (si Temp_agua == Temp_max)
    GOTO CalentarAgua ; Saltar a la etiqueta CalentarAgua si la temperatura es menor a la máxima
	RETURN
		

	; Etiqueta para calentar el agua
CalentarAgua
	
   	BSF PORTB, 2
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BCF PORTB, 2
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	INCF Temp_agua, F
    MOVF Temp_agua, W ; Cargar la temperatura actual del agua en WREG
    SUBWF Temp_max, W ; Restar la temperatura máxima
    BTFSS STATUS, Z ; Comprobar si el resultado es cero (si Temp_agua == Temp_max)
	GOTO CalentarAgua
	RETURN

Prender_TempMax
	BSF PORTB, 3
	MOVF Temp_agua, W ; Cargar la temperatura actual del agua en WREG
    SUBWF Temp_max, W ; Restar la temperatura máxima
    BTFSS STATUS, Z ; Comprobar si el resultado es cero (si Temp_agua == Temp_max)
	BCF PORTB, 3
	RETURN

AbrirCanilla
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BSF PORTB, 5
LOOPCANILLA
    ; Decrementar la cantidad de agua en 1 litro cada medio segundo
    CALL Retardo_200ms
    CALL Retardo_200ms
    CALL Retardo_100ms
    DECF CantidadAgua, F
	MOVF CantidadAgua, W ; Mover el valor de CantidadAgua a WREG
	SUBWF CantidadAgua50, W ; Restar la capacidad máxima de agua y almacenar el resultado en WREG
	BTFSS STATUS, Z ; Comprobar si el resultado es cero (es decir, CantidadAgua < 110)
	GOTO LOOPCANILLA
    GOTO SalirLOOPCANILLA ; Salir del bucle si la cantidad llegó a 50

SalirLOOPCANILLA
    BCF PORTB, 5 ; Apagar un LED o realizar alguna acción
    RETURN

Bomba_Resistencia
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	CALL Retardo_200ms
	CALL Retardo_200ms
	CALL Retardo_100ms
	BSF PORTB, 2
	BCF PORTB, 3
	CALL AguaMenosDe110
	BCF PORTB, 2
	RETURN
	



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
			GOTO Retraso_1miliSegundo	
			RETURN				
						
	
	;Cm = t (mhz/4)
	; cm= t (4/4)
	;cm= t(en us)
	;1cm->1us
	END