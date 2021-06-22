
mMkHtml macro
    pusha

    call mkHtml

    popa
endm

;recibe en x, y. las coordenadas de la pieza
mWriteImgNumber macro x, y
    pusha

    mov ax, x
    mov dx, y
    call writeImgNumber
    
    popa
endm

;recibe en x, y. las coordenadas de la pieza
mWriteImgLetter macro x, y
    pusha

    mov ax, x
    mov dx, y
    call writeImgLetter

    popa
endm

mHtmlWriteDate macro
    pusha

    call writeDate

    popa
endm