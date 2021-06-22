;asume que tiene un variable board0
;asume que tenemos los macros de string

;Parameters:    ax     posicion en x
;               dx     posicion en y
;returns:       ax:    offset de board0 equivalente 
getBoardOffset proc
    push bp
    mov bp, sp

    push dx ;Guardamos en el stack dx porque el mnemonico mul lo va a usar
    mov bx, 5
    mul bx;(x*5)
    add ax, 2 ;(x*5) + 2 
    pop dx ;dx ahora esta y de nuevo

    push ax ;metemos el resultado de ((x * 5) + 2) en el stack porque mul va a usar ax
    mov ax, dx
    mov bx, 92 ;4E para poder hacer la multiplicacion 78 * ax
    mul bx ;y * 78
    pop dx ; dx ahora tiene el sesultado de ((x * 5) + 2) y ax el resultado de (y * 78)

    add ax, dx ;ax ahora contiene el result 

    pop bp
    ret ;sin parametros en stack
getBoardOffset endp

;Parameters:    bx incio de la cadena con el comando
;Locals:        [bp - 2] : x
;               [bp - 4] : y
;returns:       ax: 0 si la puso, 1 si los parametros no son 
;               validos, 2 si esta sobre otra pieza, 3 si va
;               a cometer suicidio, 4 si es KO
playBlackPiece proc
    push bp
    mov bp, sp
    sub sp, 4

    call isCoordenate;bx ya tiene metida la cadena
    cmp ax, 0
    je NOT_LETTER;Si no es coordenada

    ;convertimos letra mayuscula a numero
    xor ax, ax
    mov al, [bx]
    sub ax, 41h
    mov [bp - 2], ax
    ;convertimos de numero ascii a numero
    xor dx, dx
    mov dl, [bx + 1]
    sub dx, 31h
    mov [bp - 4], dx
    ;ax (x) y dx (y) ahora contienen las coordenadas de [0, 8)

    call getPieceAt ;ax = que pieza tiene, bx = ptr a la pos en el tablero

    cmp ax, 0 
    je PAINT_PIECE

    cmp ax, 2
    je OVER_OTHER_PIECE
    cmp ax, 3
    je OVER_OTHER_PIECE

PAINT_PIECE:
    mCopyString <offset FB>, bx, 2
;Revisamos si es suicidio
    ;Sacamos una go string con la posicion x, y
    mClearMarked
    mGetGoString [bp - 2], [bp - 4]
    lea si, goObj
    cmp byte ptr[si + 2], 0;Si no tiene libs entonces es suicidio
    je SUICIDE
;Revisamos si es ko
    mScanBoard
    mCompareString board0, lastLastBoard, 877
    je KO

;Si no es ni suicidio ni ko entonces se juega normalmente
    mCopyString offset lastBoard, offset lastLastBoard, 877
    mCopyString offset board0, offset lastBoard, 877

    xor ax, ax
    jmp RETURN

NOT_LETTER:
    mov ax, 1
    jmp RETURN

OVER_OTHER_PIECE:
    mov ax, 2
    jmp RETURN

SUICIDE:
    mCopyString <offset EMPTY>, bx, 2
    mov ax, 3
    jmp RETURN

KO:
    mCopyString offset lastBoard, offset board0, 877
    mov ax, 4

RETURN:
    mov sp, bp
    pop bp
    ret ;sin parametros en stack
playBlackPiece endp

;Parameters:    bx incio de la cadena con el comando
;returns:       ax: 0 si la puso, 1 si los parametros no son 
;               validos, 2 si esta sobre otra pieza, 3 si va
;               a cometer suicidio, 4 si es KO
playWhitePiece proc
    push bp
    mov bp, sp
    sub sp, 4
    
    call isCoordenate;bx ya tiene metida la cadena
    cmp ax, 0
    je NOT_LETTER;Si no es coordenada

    ;convertimos letra mayuscula a numero
    xor ax, ax
    mov al, [bx]
    sub ax, 41h
    mov [bp - 2], ax
    ;convertimos de numero ascii a numero
    xor dx, dx
    mov dl, [bx + 1]
    sub dx, 31h
    mov [bp - 4], dx
    ;ax (x) y dx (y) ahora contienen las coordenadas de [0, 8)

    call getPieceAt ;ax = que pieza tiene, bx = ptr a la pos en el tablero

    cmp ax, 0 
    je PAINT_PIECE

    cmp ax, 2
    je OVER_OTHER_PIECE
    cmp ax, 3
    je OVER_OTHER_PIECE

PAINT_PIECE:
    mCopyString <offset FW>, bx, 2
;Revisamos si es suicidio
    ;Sacamos una go string con la posicion x, y
    mClearMarked
    mGetGoString [bp - 2], [bp - 4]
    lea si, goObj
    cmp byte ptr[si + 2], 0;Si no tiene libs entonces es suicidio
    je SUICIDE
;Revisamos si es ko
    mScanBoard
    mCompareString board0, lastLastBoard, 877
    je KO

;Si no es ni suicidio ni ko entonces se juega normalmente
    mCopyString offset lastBoard, offset lastLastBoard, 877
    mCopyString offset board0, offset lastBoard, 877

    xor ax, ax
    jmp RETURN

NOT_LETTER:
    mov ax, 1
    jmp RETURN

OVER_OTHER_PIECE:
    mov ax, 2
    jmp RETURN

SUICIDE:
    mCopyString <offset EMPTY>, bx, 2
    mov ax, 3
    jmp RETURN

KO:
    mCopyString offset lastBoard, offset board0, 877
    mov ax, 4

RETURN:
    mov sp, bp
    pop bp
    ret ;sin parametros en stack
playWhitePiece endp

;Parameters:    bx incio de la cadena a analizar
;returns:       ax:    0 si no es coordenada 1 si es coordenada
isCoordenate proc
    push bp
    mov bp, sp
    
    mov al, [bx]
    cmp al, 41h
    jb NOT_LETTER
    cmp al, 49h
    ja NOT_LETTER

    mov al, [bx + 1]
    cmp al, 31h
    jb NOT_LETTER
    cmp al, 39h
    ja NOT_LETTER
    
    mov ax, 1
    jmp RETURN

NOT_LETTER:
    xor ax, ax

RETURN:
    ;mov sp, bp
    pop bp
    ret ;sin parametros en stack
isCoordenate endp

;Parameters:    ax: coordenada x
;               dx: coordenada y
;returns:       ax: 0 no hay pieza, 1 esta fuera de rango, 2 si es negra, 
;                   3 si es blanca, 4 si es circulo, 5 si es cuadrado
;               bx: el offset de la pieza
getPieceAt proc
    push bp
    mov bp, sp
    
    ;revisamos que ax y dx no esten fuera de rango [0, 7]
    cmp ax, 8
    ja FUERA_DE_RANGO
    cmp dx, 8
    ja FUERA_DE_RANGO

    call getBoardOffset
    lea bx, board0
    add bx, ax

    mov al, [bx + 1]
    cmp al, ' '
    je VACIA

    mov al, [bx + 1]
    cmp al, 'N'
    je NEGRA

    mov al, [bx + 1]
    cmp al, 'B'
    je BLANCA

    mov al, [bx + 1]
    cmp al, 'C'
    je CIRCLE

    mov al, [bx + 1]
    cmp al, 'S'
    je SQUARE

FUERA_DE_RANGO:
    mov ax, 1
    jmp RETURN

VACIA:
    xor ax, ax
    jmp RETURN

NEGRA:
    mov ax, 2
    jmp RETURN

BLANCA:
    mov ax, 3
    jmp RETURN

CIRCLE:
    mov ax, 4
    jmp RETURN

SQUARE:
    mov ax, 5
    jmp RETURN

RETURN:
    ;mov sp, bp 
    pop bp
    ret ;sin parametros en stack
getPieceAt endp

resetBoard proc ;Chapuz deberia de llamarse resetGame porque reseteamos los puntajes tambien
    push bp
    mov bp, sp

    xor dx, dx
    mov cx, 9
    LOOP_I:
    push cx

    xor ax, ax
    mov cx, 9
    LOOP_J:
    mGetBoardAbsOffset ax, dx
    mCopyString <offset EMPTY>, bx, 2 
    inc ax
    loop LOOP_J

    inc dx
    pop cx
    loop LOOP_I

    ;mov sp, bp 
    pop bp
    ret ;sin parametros en stack
resetBoard endp


scanBoard proc
    push bp
    mov bp, sp
    sub sp, 4 ;coordenada x = [bp - 2]
              ;coordenada y = [bp - 4]

    mClearMarked

    ;dejamos en bx el inicio del goObj
    lea bx, goObj
    xor dx, dx
    mov [bp - 4], dx;dx empieza en 0
    mov cx, 9
    LOOP_I:
        push cx
        xor ax, ax
        mov [bp - 2], ax;Regresamos a 0 el x
        mov cx, 9
        LOOP_J:
            mIsMarked [bp - 2], [bp - 4]
            cmp ax, 1
            je CONTINUE_J

            mGetGoString [bp - 2], [bp - 4]
            cmp byte ptr[bx], 0
            je CONTINUE_J
            
            cmp byte ptr[bx + 2], 0;[bx + 2] goObj.libsCount
            ja CONTINUE_J

            ;else. Si no esta marcada, es un goString valido (tiene color)
            ;y no tiene libertedas hay que quitar
            mBoardClearGoString

        CONTINUE_J:
        inc word ptr[bp - 2]
        dec cx ;Estas dos lineas reemplazan loop LOOP_I, porque loop solo 
        jne LOOP_J;puede hacer saltos pequennos y nuestro loop es muy largo
        
        pop cx

    CONTINUE_I:
    inc word ptr[bp - 4]
    dec cx ;Estas dos lineas reemplazan loop LOOP_I, porque loop solo 
    jne LOOP_I;puede hacer saltos pequennos y nuestro loop es muy largo


    mov sp, bp
    pop bp
    ret 
scanBoard endp 

endScanBoard proc
    push bp
    mov bp, sp
    sub sp, 4 ;coordenada x = [bp - 2]
              ;coordenada y = [bp - 4]

    mClearMarked

    ;dejamos en bx el inicio del goObj
    lea bx, goObj
    xor dx, dx
    mov [bp - 4], dx;dx empieza en 0
    mov cx, 9
    LOOP_I:
        push cx
        xor ax, ax
        mov [bp - 2], ax;Regresamos a 0 el x
        mov cx, 9
        LOOP_J:
            mIsMarked [bp - 2], [bp - 4]
            cmp ax, 1
            je CONTINUE_J

            mGetGoString [bp - 2], [bp - 4]
            cmp byte ptr[bx], 0
            je CONTINUE_J
            
            cmp byte ptr[bx + 2], 1;[bx + 2] goObj.libsCount
            ja AGREGAR_PUNTOS

            ;else. Si no esta marcada, es un goString valido (tiene color)
            ;y no tiene 1 o menos libs hay que quitar
            mBoardClearGoString
            jmp CONTINUE_J

            AGREGAR_PUNTOS:
            cmp byte ptr[bx], 2 ;2 es negra
            je IS_NEGRA
            cmp byte ptr[bx], 3 ;2 es blanca
            je IS_BLANCA

            IS_NEGRA:
            mov al, bScore
            add al, [bx + 1]
            mov bScore, al
            jmp CONTINUE_J

            IS_BLANCA:
            mov al, wScore
            add al, [bx + 1]
            mov wScore, al
            jmp CONTINUE_J

        CONTINUE_J:
        inc word ptr[bp - 2]
        dec cx ;Estas dos lineas reemplazan loop LOOP_I, porque loop solo 
        jne LOOP_J;puede hacer saltos pequennos y nuestro loop es muy largo
        
        pop cx

    CONTINUE_I:
    inc word ptr[bp - 4]
    dec cx ;Estas dos lineas reemplazan loop LOOP_I, porque loop solo 
    jne LOOP_I;puede hacer saltos pequennos y nuestro loop es muy largo


    mov sp, bp
    pop bp
    ret 
endScanBoard endp 

;Limpia las fichas del goObj actual y le suma los puntos a la ficha del color opuesto
;Sin parametros
boardClearGoString proc
    push bp
    mov bp, sp

    lea si, goObj
    
    ;Determinamos a que variable de puntaje le tenemos que agregar: bScore o wScore
    cmp byte ptr[si], 2 ;2 es negra
    je IS_NEGRA
    cmp byte ptr[si], 3 ;2 es blanca
    je IS_BLANCA

    IS_NEGRA:
    lea di, wScore
    jmp END_IF

    IS_BLANCA:
    lea di, bScore
    jmp END_IF
    
    END_IF:

    mov cx, [si + 1]
    ;Posicionamos a si para que este al inicio del arreglo de goObj.fichas
    add si, 3
    cmp cx, 0
    je RETURN
    LOOP_I:
        movzx ax, byte ptr[si]
        movzx dx, byte ptr[si + 1]
        call getPieceAt;Retorna en bx la primera casilla de la pos en el tablero
        mCopyString <offset EMPTY>, bx, 2 

        inc byte ptr[di];sumamos el score

    add si, 2 ;nos pasamos a la siguiente coordenada
    loop LOOP_I
    
RETURN:
    mov sp, bp
    pop bp
    ret
boardClearGoString endp