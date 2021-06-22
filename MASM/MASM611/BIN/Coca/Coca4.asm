;Arreglos

include macros.asm

.model small 
.stack
.data
    arreglo db 7 dup("$"), "$"
    mensajeInicial db "1) Ingresar texto", 0ah, 0dh, "2) Mostrar Texto Guardado", 0ah, 0dh, "3) Salir", 0ah, 0dh, "$"
.code
main proc far 

    mov ax,@DATA 
    mov ds,ax 

Inicio:
    println mensajeInicial
    getChar
    cmp al, "1" 
        je opcion1
    cmp al, "2" 
        je opcion2
    cmp al, "3" 
        je Salir
    
    jmp Inicio

opcion1:
    printEmptyln
    getString arreglo
    jmp Inicio
opcion2:
    println arreglo
    jmp Inicio

Salir:
    mov ah,4ch
    int 21h 
main endp 
end main 