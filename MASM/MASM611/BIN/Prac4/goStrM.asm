mClearMarked macro 
    pusha

    lea si, markedArray
    mov al, 0
    mov cx,sizeof markedArray
    call fillString

    popa
endm

;Retorna en ax 0 si no esta ocupado, 1 si esta ocupado
mIsMarked macro x, y
    pushaButAx
    
    mov ax, x
    mov dx, y
    call getMarkedOffset
    movzx ax, byte ptr[bx]

    popaButAx
endm

mMark macro x, y
    pusha 

    mov ax, x
    mov dx, y
    call getMarkedOffset
    mov byte ptr[bx], 1

    popa
endm

;IMPORTANTE: resetea el goObj pero no resetea el markedArra. <-By design
;no retorna nada solo cambia la variable goString y eso es practicamente el retorno
;x debe tener rango [0, 9)
;y debe tener rango [0, 9)
;comments: metodo de entrada a la recursion getGoString
mGetGoString macro x, y
LOCAL NEGRA, BLANCA, _END
    pusha

    mov al, 0;llamamos a resetGoObj para que limpie el goObj como si fuera un goString
    call resetGoObj

    mGetPieceAt x, y;asumimos que solo puede retorna 0, 2, 3
    cmp ax, 0 ;ni negra ni blanca
    je _END

    lea bx, goObj

    mov byte ptr[bx], al
    mMark x, y
    mGoStringAddCoordenate x, y
    mov dx, y
    push dx
    mov ax, x
    push ax
    call getGoString
    jmp _END

_END:
    popa
endm

mGoStringAddCoordenate macro x, y
    pusha
    
    mov dx, y
    push dx
    mov ax, x
    push ax
    call goStringAddCoordenate

    popa
endm

mGoStringAddLib macro x, y
    pusha

    mov dx, y
    push dx
    mov ax, x
    push ax
    call goStringAddLib

    popa
endm