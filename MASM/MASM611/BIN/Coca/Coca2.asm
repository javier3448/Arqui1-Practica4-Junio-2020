;etiquetas y JMP

include macros.asm ;archivo con macros. Parecido al include de c

.model small 
.stack
.data
msg1 db 0ah, 0dh, "etiqueta1!", "$";Que significa: 0ah, 0dh. Salto de linea?
msg2 db 0ah, 0dh, "etiqueta2!", "$"
msg3 db 0ah, 0dh, "etiqueta3!", "$"

.code
main proc far 
    
    mov ax,@DATA 
    mov ds,ax 

    etiqueta1:
        print msg1
        jmp etiqueta3
    
    etiqueta2:
        print msg2
        jmp Salir

    etiqueta3:
        print msg3
        jmp etiqueta2

    Salir:
        mov ah,4ch 
        int 21h 
main endp 
end main 