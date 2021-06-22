
;Parameters:    ax     posicion en x
;               dx     posicion en y
;returns:       bx:    offset absoluto de markedArray equivalente 
getMarkedOffset proc
    push bp
    mov bp, sp

    push ax ;Guardamos en el stack dx porque el mnemonico mul lo va a usar
    mov ax, dx
    mov dx, 9
    mul dx;ax = (y*9)
    pop dx ;dx ahora tiene la coordenada x
    add ax, dx ;(y*9) + x

    lea bx, markedArray
    add bx, ax;retornamos en bx

    pop bp
    ret
getMarkedOffset endp

;params [bp + 4] coordenada x
;       [bp + 6] coordenada y
;locales [bp - 2] coordenada x + offsetAdyacente
;        [bp - 4] coordenada y + offsetAdyacente
;       goString.Color(i.e. [goObj+0]) de que color es la cadena: 1 (negra) 2 (blanca)
getGoString proc
    push bp
    mov bp, sp
    sub sp, 4

    mov cx, 4 ;numero de posiciones adyancentes
    lea bx, adyacentOffsets
    LOOP_I:
        mov ax, [bp + 4]
        mov dx, [bp + 6]
        add al, byte ptr[bx]
        add dl, byte ptr[bx + 1]
        mov [bp - 2], ax
        mov [bp - 4], dx

        ;revisamos que no este fuera de rango
        cmp ax, 8
        ja CONTINUE
        cmp dx, 8
        ja CONTINUE

        mIsMarked  [bp - 2], [bp - 4]
        cmp ax, 1
        je CONTINUE

        mGetPieceAt [bp - 2], [bp - 4]
        lea si, goObj
        cmp al, byte ptr[si] ;goObj.color
        je SAME_COLOR
        cmp al, 0
        je _EMPTY
        ;else. si no esta vacio, ni es del mismo color vamos a suponer que es del color opuesto
        jmp CONTINUE
        _EMPTY:
            mGoStringAddLib [bp - 2], [bp - 4]
            jmp CONTINUE
        SAME_COLOR:
            mMark [bp - 2], [bp - 4]
            mGoStringAddCoordenate [bp - 2], [bp - 4]
            ;los registros cx y bx deben mantener sin cambio en cada 'stack frame'
            ;, no se si estoy usando bien esa palabra
            push cx
            push bx 
            mov dx, [bp - 4]
            push dx
            mov ax, [bp - 2]
            push ax
            call getGoString
            pop bx
            pop cx

            jmp CONTINUE
    CONTINUE:
        add bx, 2
        dec cx ;Estas dos lineas reemplazan loop LOOP_I, porque loop solo 
        jne LOOP_I;puede hacer saltos pequennos y nuestro loop es muy largo


RETURN:
    mov sp, bp
    pop bp
    ret 4
getGoString endp

;params: al: valor default de libs, se espera 0 si es territory 0ffh
;solo usa ax bx si cx
resetGoObj proc
    push bp
    mov bp, sp

    lea bx, goObj
    mov byte ptr[bx], 0
    mov byte ptr[bx + 1], al
    mov byte ptr[bx + 2], 0

    ;llamando a fillString
    add bx, 3
    mov si, bx
    mov al, 0ffh
    mov cx, 162;numero de coordenadas de fichas 
    call fillString

    ;llamando a fillString
    add bx, 162
    mov si, bx
    mov al, 0ffh
    mov cx, 40;numero de coordenadas de libertades
    call fillString

    pop bp
    ret
resetGoObj endp

;params: [bp + 4] coordenada x [!!!] en 16 bits
;        [bp + 6] coordenada y [!!!] en 16 bits
;usa:    ax, bx, dx, si
goStringAddCoordenate proc
    push bp
    mov bp, sp

    lea bx, goObj
    mov si, bx;mantenemos dos indices, bx tiene la pos inicial del goObj
              ;si tiene la pos donde empieza la coordenada que tenemos que llenar
    movzx ax, byte ptr[bx + 1];ax tiene el numero de fichas actual del goString
    mov dx, 2
    mul dx
    add si, 3
    add si, ax

    mov ax, [bp + 4]
    mov byte ptr[si], al
    mov dx, [bp + 6]
    mov byte ptr[si + 1], dl

    mov al, byte ptr[bx + 1];goObj.sizeFichas
    inc al 
    mov byte ptr[bx + 1], al;incrementamos en 1 el size

    pop bp
    ret 4
goStringAddCoordenate endp

;[!!!] si lo llamamos con goObj seteado para teritory da comportamiento no definido
;params: [bp + 4] coordenada x [!!!] en 16 bits
;        [bp + 6] coordenada y [!!!] en 16 bits
goStringAddLib proc
    push bp
    mov bp, sp

;metemos en al y en dl las coordenadas para no sacarlas y meterlas del stack a cada rato y para pasarlas a 8 bits
    mov ax, [bp + 4]
    mov dx, [bp + 6]

;revisamos si ya existe una libertad con esas coordenadas
    lea bx, goObj

    mov si, bx
    add si, 165;ponemos si en la primera coordenada de libs
    movzx cx, byte ptr[bx + 2];goObj.libs
    cmp cx, 0 ;si no tiene ninguna coordenada en libs entonces no entramos al loop
    je BREAK_I
LOOP_I:
    cmp al, byte ptr[si]
    jne CONTINUE_I
    cmp dl, byte ptr[si + 1]
    je RETURN

CONTINUE_I:
    add si, 2
    loop LOOP_I

BREAK_I:

;Si termino el loop es porque no tiene ninguna libertad en x, y
;si entonces esta en la primera posicion libre
    mov [si], al
    mov [si + 1], dl
    
    ;sumamos a libs 1
    mov al, byte ptr[bx + 2]
    inc al
    mov byte ptr[bx + 2], al

RETURN:
    pop bp
    ret 4
goStringAddLib endp

