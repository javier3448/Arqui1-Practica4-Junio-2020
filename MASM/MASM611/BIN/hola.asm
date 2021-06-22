
.model small
.stack 100h
.data
   saludo   db "Hola mundo!", "a", "a", "a", "$" ;"+/- tipos: db(byte) dw(world)"
 	num db 11h
.code
 
main  proc              ;Inicia proceso
START:
   mov   ax, seg saludo     ;ax = seg saludo 
   mov   ds, ax          ;ds = ax = saludo

   mov   ah,09          ;Function(print string)
   lea   dx,saludo         ;DX = String terminated by "$"
   int   21h               ;Interruptions DOS Functions


   push ax
   mov ax, 0ffddh
   push ax

   pop cx
   ;AQUI, cual es el valor del cx y sp
;mensaje en pantalla
 
   mov   ax, 4c00h       ;Function (Quit with exit code (EXIT))
   int   21h            ;Interruption DOS Functions

main  endp              
end main

;