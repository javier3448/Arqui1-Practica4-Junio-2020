;Leer caracter de consola

include macros.asm

.model small 
.stack
.data
    mensajeInicial db "Escoja nombre: ", 0ah, 0dh, "1)Javier", 0ah, 0dh, "2)Antonio", 0ah, 0dh, "3)Alvarez", 0ah, 0dh, "$"
    mensajeJavier db "Jav", "$"
    mensajeAntonio db "Ant", "$"
    mensajeAlvarez db "Alv", "$"
.code
main proc far 

    mov ax,@DATA 
    mov ds,ax 

Inicio:
    print mensajeInicial
    getChar
    cmp al, "1" ;No se si podemos poner la string a lo bestia
    je opcionJavier
    cmp al, "2" 
    je opcionAntonio
    cmp al, "2" 
    je opcionAlvarez

    jmp Inicio

opcionJavier:
    println mensajeJavier
    getChar
    jmp salir
opcionAntonio:
    println mensajeAntonio
    getChar
    jmp salir
opcionAlvarez:
    println mensajeAlvarez
    getChar
    jmp salir


Salir:
    mov ah,4ch
    int 21h 
main endp 
end main 