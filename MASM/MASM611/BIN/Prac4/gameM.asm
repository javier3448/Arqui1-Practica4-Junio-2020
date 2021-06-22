;supone que se incluye macros.asm, y tiene definidas las dos string board0 y gameLineJumps
;supone que se incluye gameP.inc

paintGame macro msg
    print gameLineJumps
    print board0
endm

;Params:       una cadena de longitud 2 con la coordenada a jugar
;Returns:      ax: 0 si la puso, 1 si los parametros no son validos, 2 si esta sobre otra pieza, 3 si va a cometer suicidio, 4 si ocurrio ko
;Registers:    ax
;Comments:     letter y num son bytes en ascii
mPlayWhitePiece macro string

    pushaButAx

    lea bx, string
    call playWhitePiece

    popaButAx

endm

;Params:       una cadena de longitud 2 con la coordenada a jugar
;Returns:      ax: 0 si la puso, 1 si los parametros no son validos, 2 si esta sobre otra pieza, 3 si va a cometer suicidio
;Registers:    ax
;Comments:     letter y num son bytes en ascii
mPlayBlackPiece macro string

    pushaButAx

    lea bx, string
    call playBlackPiece

    popaButAx

endm


;Returns:       ax: el offset equivalente a las posiciones x, y enviadas en los parametros
;Registers:     ax
mGetBoardOffset macro x, y
    pushaButAx

    mov ax, x
    mov dx, y
    call getBoardOffset

    popaButAx
endm
 
;Returns       bx: cont el offset 'absoluto' (de reg DS)
mGetBoardAbsOffset macro x, y
    pushaButBx

    mov ax, x
    mov dx, y
    call getBoardOffset
    lea bx, board0
    add bx, ax

    popaButBx
endm

;Returns:       ax: Que pieza esta en la posicion x, y. 
;                   0 no hay pieza, 1 esta fuera de rango, 2 si es negra,
;                   3 si es blanca, 4 si es circulo, 5 si es cuadrado
;Registers:     ax
mGetPieceAt macro x, y
    pushaButAx

    mov ax, x
    mov dx, y
    call getPieceAt

    popaButAx
endm


mResetBoard macro ;Chapuz deberia de llamarse resetGame porque reseteamos los puntajes tambien
    pusha

    call resetBoard

    popa
endm

mResetBoards macro

    pusha

    ;Reseteamos el tablero principal
    call resetBoard

    ;Reseteamos la puntacion 
    mov bScore, 0
    mov wScore, 0

    ;Reseteamos los tableros de turnos anteriores
    lea si, lastLastBoard
    mov al, '$'
    mov cx, 1564
    call fillString



    popa

endm

;Busca goString con 0 libertades remueve todas sus fichas
;y agrega los puntos al color corespondiente
mScanBoard macro
    pusha

    call scanBoard

    popa
endm

;Busca goString con 1 libertades remueve todas sus fichas
;y agrega los puntos al color corespondiente
mEndScanBoard macro
    pusha

    call endScanBoard

    popa
endm

mBoardClearGoString macro
    pusha

    call boardClearGoString

    popa
endm
