; My primer intento
; It stores a name 'Zara Ali' in the data section of the memory, then changes its value to another name 'Nuha Ali'
;

.model small
; Probando sin stack?
.data
   nombre db "Zara Ali", "$" ;$ terminated string
	
.code ;No se si se puede hacer sin main, y no se que significa main proc, main endp y end main. (?) Cual es la diferencia entre main endp y end main

main  proc              ;Inicia proceso
   mov   ax,seg nombre     ;"Operador SEG: devuelve el valor del segmento de la variable o etiqueta" Creo que sirve para conseguir el 'puntero'
   mov   ds,ax          ;ds = ax = saludo
 
   mov   ah,09          ;Function(print string)
   lea   dx,saludo         ;DX = String terminated by "$"
   int   21h               ;Interruptions DOS Functions
 
;mensaje en pantalla
 
   mov   ax,4c00h       ;Function (Quit with exit code (EXIT))
   int   21h            ;Interruption DOS Functions
 
main  endp              ;Termina proceso
end main