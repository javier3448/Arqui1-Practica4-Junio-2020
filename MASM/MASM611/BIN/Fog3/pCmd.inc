;Procesos del cmd

;Dependencies:  supone que se tiene un macro cmdGetChar
;Parameters:    [bp+4] (ref) Direccion del string donde se almacenara el resultado
;               dl string termination character (no usamos al porque la llamada al sistema en cmdGetChar lo usa)
;Registers:     ax, bx, dl, si
;Returns:       ax numero de caracteres ingresados por el usuario (no incluye string termination)
;Comments:      No verifica que no escriba mas alla del tamanno del string enviado, si
;               si el usuario escribe mas alla de el se escribira en memoria no propia
pCmdGetString proc

    push bp
    mov bp, sp

    mov bx, [bp + 4]
    mov si, bx ;guarda el bx incial

    ObtenerCaracter:
        ;obtener caracter por caracter hasta que lleguemos a salto de linea
        cmdGetChar
        cmp al, 0dh ;0dh es enter
        je EndObtenerCaracter
        cmp al, 08h ;08h es backspace
        je BackSpace
        mov [bx], al
        inc bx
        jmp ObtenerCaracter
    BackSpace:
        cmp bx, si
        je Continue
        dec bx
    Continue:
        jmp ObtenerCaracter
    EndObtenerCaracter:
        mov [bx], dl
        mov ax, bx ;el valor actual de bx
        sub ax, si ;actual - incial = size ;Estamos usando registros de mas solo necesitamos restar bx y bx en stack

        pop bp
        ret 2
pCmdGetString endp