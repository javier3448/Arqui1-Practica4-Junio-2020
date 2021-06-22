;Asume que contiene los proc de string

mCompareString macro s1, s2, size
    pusha
    
    lea si, s1
    lea di, s2
    mov cx, size
    call compareString

    popa
endm

mCopyString macro sourceBeg, destBeg, _size
    pusha
    
    mov si, sourceBeg
    mov di, destBeg
    mov cx, _size
    call copyString

    popa
endm

mFillString macro sourceBeg, _size, character
    pusha

    mov si, sourceBeg
    mov cx, _size
    mov al, character
    call fillString

    popa
endm

;Cambia decBuffer para que contenga el numero en decimal
mByteToDecAscii macro decBuffer, _byte
    push ax
    push bx
    push di
    push dx

    lea decBuffer, bx
    push bx
    mov al, _byte
    call bytToHexAscii

    push dx
    push di
    push bx
    push ax
    
endm