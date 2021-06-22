;TODO TODO: Investigar como hacer una buena maquina de estados

;Reportes
;Supone que se definie las variables vocalesAbiertas(3 bytes) y vocalesCerradas(2 bytes).
;Supone que se tiene acceso a un procedure llamado stringContains en pString
;Da error si textSize es menor a 1 (unsigned)
;todo: comentar bien ese macro
;utiliza los registros bx y si para indexar. si para iterar atravez de los diptongos y bx para iterar en la cadena
getDiptongos macro text, textSize, crecCount, decCount, homoCount
LOCAL S0, S1, S2, S3, S4, S5, END, copyBx ;No se que es mejor para copyBx, que este en 
    
.data
    copyBx dw 0ffffh
    
.code 
    ;pone en 0 los counts
    int 3
    mov crecCount, 0
    mov decCount, 0
    mov homoCount, 0

    lea bx, text
    mov cx, textSize

    S0:
    mov copyBx, bx
    inc bx
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    isCerrada copyBx
    je S1
    isAbierta copyBx
    je S3
    jmp S0

    S1:
    mov si, 1
    mov copyBx, bx
    inc bx
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    isCerrada copyBx
    je S5
    isAbierta copyBx
    je S2
    jmp S0

    S2:
    mov si, 2
    inc decCount
    jmp S0

    S3:
    mov si, 3
    mov copyBx, bx
    inc bx
    dec cx
    cmp cx, 0ffffh ;-1 no uno, estamos utilizando overflow en nuestra logica lo cual puede ser muy mala practica no se
    je END
    isCerrada copyBx
    je S4
    jmp S0

    S4:
    mov si, 4
    inc crecCount
    jmp S0

    S5:
    mov si, 5
    inc homoCount
    jmp S0

    END:
endm

;Creo que solo acepta que char sea un registro
isCerrada macro char
    push cx ;copiamos cx y bx porque getDiptongos los necesita despues (poco optimo?)
    push bx
    
    mov bx, char
    push [bx]
    push 4 ;numero de vocales abiertas
    lea bx, vocalesCerradas
    push bx
    call stringContains
    
    pop bx
    pop cx
endm

;poco optimo porque haga muchos push y pops a variables que no cambian
;char tiene que ser la direccion a un char en un string (se va a meter al stack el char indicado y el char que le sigue pero so se usara el primero para la comparacion)
isAbierta macro char
    push cx ;copiamos cx y bx porque getDiptongos los necesita despues (poco optimo?)
    push bx
    
    mov bx, char
    push [bx]
    push 6 ;numero de vocales abiertas
    lea bx, vocalesAbiertas
    push bx
    call stringContains

    pop bx
    pop cx
endm

