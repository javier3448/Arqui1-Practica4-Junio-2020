;Parameters:  text ('ref') = cadena que se pasara a minusculas
;             size = numero de caracteres a cambiar (si es mayor que sizeof text ocurre comportamiento no definido)
;Comments:    Solo funciona para los caracteres del alfabeto ingles
toUpper macro text, size
LOCAL START, END_OF_LOOP
    xor bx, bx
    mov cx, size
    START:
        cmp text[bx], 61h
        jb END_OF_LOOP
        cmp text[bx], 7ah
        ja END_OF_LOOP
        ;De aqui hasa END_OF_LOOP solo se ejecuta si es minuscala
        sub text[bx], 20h
    END_OF_LOOP:
        inc bx
        loop START
endm

toLower macro text, size
LOCAL START, END_OF_LOOP
    xor bx, bx
    mov cx, size
    START:
        cmp text[bx], 41h
        jb END_OF_LOOP
        cmp text[bx], 5ah
        ja END_OF_LOOP
        ;De aqui hasa END_OF_LOOP solo se ejecuta si es minuscala
        add text[bx], 20h
    END_OF_LOOP:
        inc bx
        loop START
endm

;cambio un poco la maquina de estados desde los dipotongos, se mejoro un cacho
toCapital macro text, size
LOCAL S0, S1, S2, END

    int 3

    lea bx, text
    mov cx, size
    int 3

    S0:
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    mov al, [bx]
    inc bx
    call isLetter 
    je S1
    jmp S0

    S1:
    cmp byte ptr[bx - 1], 61h;como ya sabemos que es letra debido al estado pasado, solo necesitamos verificar que sea minuscula
    jb S2
    sub byte ptr[bx - 1], 20h

    S2:
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    mov al, [bx]
    inc bx
    call isLetter 
    je S2
    jmp S0

    END:
endm

invert macro text, size
LOCAL S0, S1, S2, S3, S4, END

    lea bx, text
    mov cx, size

    S0:
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    mov al, [bx]
    inc bx
    call isLetter 
    je S1
    jmp S0

    S1:
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    mov al, [bx]
    inc bx
    call isLetter
    jne S0
    mov si, bx
    dec si
    dec si ;-2 porque bx esta en la posicion que se analizara en el siguiente estado, bx - 1 es la posicion que se acabada de analizar (su resultado fue no letra) y la ultima letra valida fue bx - 2
    ;jmp S2 ;cae solito a S2

    S2:
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je S4
    mov al, [bx]
    inc bx
    call isLetter
    jne S3
    jmp S2
    
    S3:
    mov di, bx
    dec di
    dec di ;-2 porque bx esta en la posicion que se analizara en el siguiente estado, bx - 1 es la posicion que se acabada de analizar (su resultado fue no letra) y la ultima letra valida fue bx - 2
    call reverseString
    jmp S0

    S4:
    mov di, bx
    dec di
    dec di ;-2 porque bx esta en la posicion que se analizara en el siguiente estado, bx - 1 es la posicion que se acabada de analizar (su resultado fue no letra) y la ultima letra valida fue bx - 2
    call reverseString

    END:
endm

findAndReplace macro text, textSize, maxTextSize, searchedString, searchedStringSize, replaceMentString, replaceMentStringSize
LOCAL
    ;buscar la cadena
    S0:

endm