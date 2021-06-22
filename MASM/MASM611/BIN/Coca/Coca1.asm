
;MACROS

;nombre MACRO param1, param2, ...
print macro p1 ; no se si los parametros pueden tener los mismos nombre que variables de .data
    mov ax, 0900h
    mov dx, offset p1
    int 21h
endm
;terminan con endm

.model small

.stack

.data
    msg1 db "Hola Javier", "$"
    msg2 db "Hola Mundo!", "$"

.code
main proc
    mov ax, @data
    mov ds, ax

    print msg1
    print msg2

exit:
    mov ax, 4c00h
    int 21h


main endp
end main