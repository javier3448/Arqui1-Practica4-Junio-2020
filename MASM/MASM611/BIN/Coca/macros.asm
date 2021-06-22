;macros simples
;string debe de tener almenos 1 byte
;utiliza bx(termina en size) y cx(termina en 0)
fillString macro string, size, character
LOCAL START
    mov cx, size
    xor bx, bx
    START:  
    mov string[bx], character
    inc bx
    loop START
endm

print macro buffer
    mov ax, 0900h
    mov dx, offset buffer
    int 21h
endm

;Solo para debugging:
printReg macro reg
    ;TODO Hacer una version propia de esta onda
endm

printChar macro val
    mov ax, 0200h
    mov dx, val
    int 21h 
endm

printEmptyln macro
    printChar 0ah
    printChar 0dh
endm

println macro buffer
    printEmptyln
    print buffer;muchas llamadas al sistema, creo que es mejor hacer una copia del string y meterle el salto de linea al principio, igual la ubicacion tendria que ser dinamica, no se como hacer eso
endm

getChar macro
    mov ax, 0100h
    int 21h
endm

;$ terminated
getString macro buffer
LOCAL ObtenerCaracter, EndObtenerCaracter
    xor si, si;poner si en 0

    ObtenerCaracter:
        ;obtener caracter por caracter hasta que lleguemos a salto de linea
        getChar
        cmp al, 0dh ;0dh es enter
            je EndObtenerCaracter
        mov buffer[si], al
        inc si
        jmp ObtenerCaracter
    EndObtenerCaracter:
    mov buffer[si], "$"

endm

;null terminated
getString macro buffer
LOCAL ObtenerCaracter, EndObtenerCaracter
    xor si, si;poner si en 0

    ObtenerCaracter:
        ;obtener caracter por caracter hasta que lleguemos a salto de linea
        getChar
        cmp al, 0dh ;0dh es enter
            je EndObtenerCaracter
        mov buffer[si], al
        inc si
        jmp ObtenerCaracter
    EndObtenerCaracter:
    mov buffer[si], 00h

endm

makeFile macro path, handler
LOCAL End
    mov ah, 3ch
    xor cx, cx
    lea dx, path
    int 21h
    jnc End ; Si no hubo carry no hay error entonces se salta hacia end sin imprimir el mensaje de erro
    println errorMsg3
    End:
    mov handler, ax
endm

openFile macro path, handler
LOCAL End
    
    mov ah, 3dh ;abrir fichero
    mov al, 02h ;Lectura y escritura
    lea dx, path ;puntero al string con la direccion
    int 21h
    mov handler, ax
    
    jnc End
        println errorMsg1

    End:
endm

writeFile macro handler, size, content
LOCAL End
    mov ah, 40h
    mov bx, handler
    mov cx, size
    lea dx, content
    int 21h

    jnc End
        println errorMsg4

    End:
endm

closeFile macro handler
LOCAL End    
    mov ah, 3eh
    mov bx, handler
    int 21h

    jnc End
        println errorMsg2

    End:
endm

readFile macro handler, buffer, size
LOCAL End    
    mov ah, 3fh
    mov bx, handler
    mov cx, size
    lea dx, buffer
    int 21h
    jnc End
        println errorMsg2

    End:
endm

;recordar que podemos tener .data adentro de un macros (ver macJon para un ejemplo)