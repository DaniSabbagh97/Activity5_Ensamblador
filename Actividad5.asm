; Author : Daniel Sabbagh - 21714038
;
;Práctica 5 - Actividad5_Daniel_Sabbagh.asm

ldi r16, 0xFF ; Cargamos el registro 16 con un 255 (11111111)
ldi r17,50 ;Se carga el valor que queremos pasarle por parametro a la funcion delay
out ddrb, r16 ; El DDRB todo a 1 configura todos los pines del puerto B como salida, desde PB0 a PB5 (pin 13)

main:
clr r16			; Clear en r16 (00000000)
out portb,r16	; Salida de r16 por el puerto B
push r17		;metemos el registro 17 en la pila para usarlo dentro una vez llamemos a la funcion delay
rcall delay		; Llamada a la subrutina delay
pop r17			;Sacamos el registro 17 de a pila porque ya ha sido usado y para no dejar basura dentro de la pila

ser r16			; Set en r16 (11111111)
out portb,r16	; Salida de r16 por el puerto B

push r17		;Igual que en el anterior recall a delay
rcall delay		; Llamada a la subrutina delay
pop r17			;Igual que en el eanterior recall a delay


rjmp main		; Salto a la etiqueta main


delay:
	push yl		;Se pusea y-low porque requiere mas de 8 bits, en este caso 16
	push yh		;Se pusea y-high porque requiere made de 8 bits.

	in yh, sph	;Se copia el stackpointer high en y-high, se usa in porque al ser registros de mas de 8 bits es una copia especial
	in yl, spl	;Se copia el stackpointer low en y-low, en este caso se copia una direccion de memoria como si fuera una copia de seguridad en ambos in

	push r22	;Pusheamos un nuevo registro vacio hacia la pila para recoger el valor del registro 17 y usarlo como parametro en la funcion
	ldd r22,y+5	;Copiamos en el regsitro 22 el valor de y+6 que es, segun el stackpointer que es el puntero en la pila, el lugar de sp mas + 6 puestos en la pila donde encontramos al valor que contiene r17, que en este caso es 50
	push r18	;Pusheamos todos los registros usados en el delay 
	push r19
	push r20
H8: ldi  r18, 5	;Apartir de aqui se comienza a usar el delay, o sea los 50 milisegundos definidos comienzan a ejecutarse
    ldi  r19, 15
    ldi  r20, 242

L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	dec r22
	brne H8	;Llamamos a H8 las veces que haya en el registro r22 que es lo que hemos copiado de r17 dentro de la pila, o sea, el valor 50 por lo que se estará ejecutando el codigo de H8, 50 veces
	pop r20	;Sacamos cada registro ya usado de la pila, en el orden equivalente a como los hemos ido introduciendo en la pila
	pop r19
	pop r18
	pop r22
	pop yh
	pop yl
	
ret
