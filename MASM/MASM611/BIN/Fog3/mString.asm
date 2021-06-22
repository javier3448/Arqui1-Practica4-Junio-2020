;Asume que contiene los proc de string

mCompareString macro s1, s2, size
    lea si, s1
    lea di, s2
    mov cx, size
    call compareString
endm
