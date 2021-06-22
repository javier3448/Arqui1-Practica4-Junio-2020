;asume que tiene incluidas las variables de game: board.
;tambien: gameP.inc
;Asume que tiene los macros files

;Vamos a asumir que nunca ha error al abrir el archivo
;locales: [bp - 2] handler
;         [bp - 4] y
;         [bp - 6] x
mkHtml proc
    push bp
    mov bp, sp

    call htmlWriteDateAndScore

    newFile htmlFileName
    push ax ;ponemos en el stack handler [bp - 2]
    writeContent ax, _sizeHead, head

    xor dx, dx
    push dx ; metemos x [bp - 4]
    push dx ; metemos y [bp - 6]

    mov cx, 9
    LOOP_I:
        push cx

        writeContent [bp - 2], 5, trOpen
        ;jmp RETURN

        xor ax, ax
        mov [bp - 4], ax;Regresamos a 0 el x
        mov cx, 9
        LOOP_J:
            mWriteImgNumber [bp - 4], [bp - 6];recive ax y dx con las coordenadas x y, escribe en el string de ram, NO EN EL ARCHIVO
            mWriteImgLetter [bp - 4], [bp - 6];recive ax y dx con las coordenadas x y, escribe en el string de ram, NO EN EL ARCHIVO

            push cx
            writeContent [bp - 2], _sizeTd, td
            pop cx

            inc word ptr[bp - 4];incrementamos x
        loop LOOP_J

        inc word ptr[bp - 6]
        writeContent [bp - 2], 6, trClose

        pop cx
    loop LOOP_I

RETURN:
    writeContent [bp - 2], _sizeClosing, closing

    closeFile [bp - 2]

    mov sp, bp;hella safe
    pop bp
    ret ;sin parametros en stack
mkHtml endp

;retorna en al
writeImgNumber proc
    push bp
    mov bp, sp

    cmp dx, 0
    je Y0
    cmp dx, 8
    je Y8
    jmp Y_

    Y0:
    cmp ax, 0
    je Y0X0
    cmp ax, 8
    je Y0X8
    jmp Y0X_

    Y8:
    cmp ax, 0
    je Y8X0
    cmp ax, 8
    je Y8X8
    jmp Y8X_

    Y_:
    cmp ax, 0
    je Y_X0
    cmp ax, 8
    je Y_X8
    jmp Y_X_

    Y0X0:
    mov al, '0'
    jmp RETURN
    Y0X8:
    mov al, '2'
    jmp RETURN
    Y0X_:
    mov al, '1'
    jmp RETURN
    Y8X0:
    mov al, '6'
    jmp RETURN
    Y8X8:
    mov al, '8'
    jmp RETURN
    Y8X_:
    mov al, '7'
    jmp RETURN
    Y_X0:
    mov al, '3'
    jmp RETURN
    Y_X8:
    mov al, '5'
    jmp RETURN
    Y_X_:
    mov al, '4'
    jmp RETURN

    RETURN:
    mov tdNumber, al

    pop bp
    ret ;sin parametros en stack
writeImgNumber endp

;params: ax: x. dx: y
writeImgLetter proc
    push bp
    mov bp, sp

    call getPieceAt
    
    cmp al, 0
    je VACIA

    cmp al, 2
    je BLACK

    cmp al, 3
    je WHITE

    cmp al, 4
    je CIRCLE

    cmp al, 5
    je SQUARE

    VACIA:
    mov al, 'E'
    jmp RETURN
    
    BLACK:
    mov al, 'B'
    jmp RETURN
    
    WHITE:
    mov al, 'W'
    jmp RETURN
    
    CIRCLE:
    mov al, 'C'
    jmp RETURN
    
    SQUARE:
    mov al, 'S'
    jmp RETURN

    RETURN:
    mov tdLetter, al

    pop bp
    ret ;sin parametros en stack
writeImgLetter endp


htmlWriteDateAndScore proc
    push bp
    mov bp, sp
    ;reservamos espacio en el stack para:
    ;[bp - 2] dia
    ;[bp - 4] mes
    ;[bp - 6] anno
    ;[bp - 8] hora
    ;[bp - 10] min
    ;[bp - 12] seg
    sub sp, 12

    mov ah, 2ah  ;conseguir dia, mes, anno
    int 21h

    movzx ax, dl;dl contiene el dia, movzx: move zero-extends
    mov [bp - 2], ax
    movzx ax, dh;dh contiene el mes
    mov [bp - 4], ax
    sub cx, 2000;cx contiene el anno pero es un numero de 16 bits entonces le restamos 2000
    mov [bp - 6], cx

    mov ah, 2Ch
    int 21h
    
    movzx ax, ch ;contiene la hora
    mov [bp - 8], ax
    movzx ax, cl ;contiene el minuto
    mov [bp - 10], ax
    movzx ax, dh ;contiene el segundo
    mov [bp - 12], ax

    ;el dia
    lea bx, decBuffer
    push bx
    mov ax, [bp - 2]
    call byteToDecAscii
    ;Llamando a copy string
    lea si, decBuffer
    inc si
    lea di, htmlDay
    mov cx, 2
    call copyString


    ;el mes
    lea bx, decBuffer
    push bx
    mov ax, [bp - 4]
    call byteToDecAscii
    ;Llamando a copy string
    lea si, decBuffer
    inc si
    lea di, htmlMonth
    mov cx, 2
    call copyString


    ;el anno
    lea bx, decBuffer
    push bx
    mov ax, [bp - 6]
    call byteToDecAscii
    ;Llamando a copy string
    lea si, decBuffer
    inc si
    lea di, htmlYear
    mov cx, 2
    call copyString


    ;hora
    lea bx, decBuffer
    push bx
    mov ax, [bp - 8]
    call byteToDecAscii
    ;Llamando a copy string
    lea si, decBuffer
    inc si
    lea di, htmlHour
    mov cx, 2
    call copyString


    ;minuto
    lea bx, decBuffer
    push bx
    mov ax, [bp - 10]
    call byteToDecAscii
    ;Llamando a copy string
    lea si, decBuffer
    inc si
    lea di, htmlMinute
    mov cx, 2
    call copyString


    ;segundo
    lea bx, decBuffer
    push bx
    mov ax, [bp - 12]
    call byteToDecAscii
    ;Llamando a copy string
    lea si, decBuffer
    inc si
    lea di, htmlSecond
    mov cx, 2
    call copyString

    ;puntuacion negras
    lea bx, decBuffer
    push bx
    movzx ax, bScore
    call byteToDecAscii
    lea si, decBuffer
    lea di, htmlBScore
    mov cx, 3
    call copyString

    ;puntuacion blancas
    lea bx, decBuffer
    push bx
    movzx ax, wScore
    call byteToDecAscii
    lea si, decBuffer
    lea di, htmlWScore
    mov cx, 3
    call copyString

    mov sp, bp
    pop bp
    ret ;sin parametros en stack
htmlWriteDateAndScore endp

