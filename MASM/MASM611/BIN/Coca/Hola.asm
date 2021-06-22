.model small
.stack
.data
   saludo   db "Hala mundo!!!", "$"
 
.code
main  proc              ;Inicia proceso
   ;No se porque las siguientes dos lineas son necesarias, solo pone que ds (data segment reg) va a ser la direccion de saludo (creo)
   mov   ax,@data
   mov   ds,ax 

   mov   ah,09h          ;Function(print string)
   mov   dx,offset saludo         ;DX = String terminated by "$"
   int   21h               ;Interruptions DOS Functions 
 
   mov   ah,4ch       ;Function (Quit with exit code (EXIT))
   xor   al, al
   int   21h            ;Interruption DOS Functions
 
main  endp              ;Termina proceso
end main