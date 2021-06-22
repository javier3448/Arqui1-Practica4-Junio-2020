.code
;Primer parametro de 2 byte:
;DS:[bp + 2 + 2]
; + 2 porque acabamos de meter el bp(16 bits) en la pila
; + 2 porque necesitamos el puntero al inicio de la variable y tiene de tamanno 1 byte

;My primer proc funciona :D

;No sigue la convencion jstdcall
;Parameters:    [bp+4] puntero a string a evaluar
;               [bp+6] string length 
;               [bp+8] char buscado (solo se usara la parte alta de los 16 bits)
;Returns:       FLAGS en equals si el caracter esta presente en el string al menos 1 vez (la flag que indica si fue son iguales es ZF)
;Registers:     ax, bx, cx
;Comments:      16 bit mode only
stringContains proc
    ;Esto lo vamos a hacer casi siempre. Que tamanno de registro metemos en el stack va afectar cuanto le tenemos que sumar al bp. Si usamos 16 bits el primer parametro estaria en [bp + ]
    push bp
    mov bp, sp

    mov bx, [bp + 4]
    mov cx, [bp + 6]
    mov ax, [bp + 8]

    LOOP_START:
    cmp al, [bx] ;Chapuz estamos usando la parte baja porque le damos a los caracteres despues de pasar al stack
    je END_PROC
    inc bx
    loop LOOP_START

    END_PROC:
    ;mov sp,bp  ;solo es necesario si usamos variables locales, esta linea las librea (NO OLVIDARLA DE SER NECESARIA)
    pop bp ;regreso el ebp a donde estaba originalmente
    ret 6 ;ret n:  popea n veces y luego hace ret normal. ;n es el numero de bytes que ocupaban los parametros (hay que eliminarlos por eso es necesaria esta linea)
stringContains endp

;Parameters:   [bp+4] (ref) Direccion del string donde se almacenara el resultado
;              al     Byte a convertir
;Registers:    al, dh, bx
;Comments:     ([bp + 4] direccion del caracter que representa los 4 bits mas significativos, [bp + 4] + 1 direccion del caracter que representa los 4 bits menos significativos)
;              creo que no funciona si el string esta en el stack porque va a estar al revez
byteToHexAscii proc
    push bp
    mov bp, sp
    
    mov bx, [bp + 4]
    ;al van a ser los 4 bits mas significativos y dh van aser los 4 bits menos significativos
    mov dh, al
    shr al, 4
    and dh, 00001111b

    ;"if else de los 4 bits mas significativos"
    cmp al, 10
    jb MSD_0to9 ;msd: most significant digit
    add al, 57h
    jmp END_MSD

    MSD_0to9:
    add al, 30h

    END_MSD: 
    mov [bx], al
    ;end if else"

    ;"if else de los 4 bits menos significativos"
    cmp dh, 10
    jb LSD_0to9 ;lsd: least significant digit
    add dh, 57h
    jmp END_LSD

    LSD_0TO9:
    add dh, 30h

    END_LSD:
    mov [bx + 1], dh
    ;end if else

    pop bp
    ret 2
byteToHexAscii endp


;Parameters:    [bp+4] (ref) Direccion del string donde se almacenara el resultado
;               ax     Byte a convertir
;Registers:     ax, bx, di, dx
;Comments:      ([bp + 4] direccion del caracter que representa el digito mas significativo, [bp + 4] + 2 direccion del caracter que representa el digito menos significativo)
;               creo que no funciona si el string esta en el stack porque va a estar al revez
;               si ax es mayor a ff va a retornar una cadena con caracteres raros
byteToDecAscii proc
    push bp
    mov bp, sp

    xor dx, dx ;ponemos dx en 0

    mov di, [bp + 4];chapuz medio, vamos a usar di porque bx lo va a usar div
    mov bx, 100 ;La potencia maxima en decimal que se puede alcanzar con 1 byte
    mov cx, 3 ;maximo numero de digitos decimales

    LOOP_START:
    mov byte ptr[di], "0";Ponemos el caracter del string en ascii 0
    div bx
    add byte ptr[di], al
    
    push dx ;le hacemos backup al residuo porque va a ser el divisor la siguiente iteracion del ciclo
    xor dx, dx
    mov ax, bx
    mov bx, 10
    div bx
    mov bx, ax
    pop ax
    inc di
    loop LOOP_START

    pop bp
    ret 2
byteToDecAscii endp

;Parameters:    al     Byte a comparar
;Registers:     al, dl
;returns:       FLAGS en ZF = 1 si es letra, ZF = 0 si no
isLetter proc
    push bp
    mov bp, sp

    cmp al, 41h
    jb FALSE_LETTER
    cmp al, 7ah
    ja FALSE_LETTER
    cmp al, 5ah
    jbe TRUE_LETTER
    cmp al, 61h
    jae TRUE_LETTER
    jmp FALSE_LETTER

    TRUE_LETTER:
    cmp al, al ;para que retorne equal en la comparacion
    pop bp
    ret ;sin parametros
    FALSE_LETTER:;talvez podemos mejorar el uso de registros para que la comparacion de dos de ellos nos de not equals siempre
    mov dl, al;para que siempre retorne not equal la comparacion
    not dl
    cmp al, dl    
    pop bp
    ret ;sin parametros
isLetter endp

;Parameters:    si     Inicio de cadena
;               di     fin de cadena
;               cx     string size (se asume que ambos size son iguales)
;Registers:     si, di, cx, ax
;returns:       FLAGS en ZF = 1 si son iguales, ZF = 0 si no
compareString proc
    push bp
    mov bp, sp

    LOOP_START:
    mov al, [si]
    mov ah, [di]
    inc si ;los incs se hacen antes de la comparacion porque la comparacion debe ser la ultima operacion artimetica que realiza el proc
    inc di
    cmp al, ah
    jne RETURN
    loop LOOP_START

    RETURN:
    pop bp
    ret
compareString endp

;Parameters:    si     Inicio de cadena
;               di     fin de cadena
;Registers:     si, di, ax
;returns:       FLAGS en ZF = 1 si es letra, ZF = 0 si no
reverseString proc
    push bp
    mov bp, sp

    INICIO:
    cmp di, si
    jbe END_PROC
    mov al, [si]
    mov ah, [di]
    mov [si], ah
    mov [di], al
    inc si
    dec di
    jmp INICIO

    END_PROC:
    pop bp
    ret ;sin parametros
reverseString endp

;Parameters:    si     Inicio de cadena (source)
;               di     Inicio de cadena (destination)
;               cx     Tamanno de cadena a copiar
;Registers:     al, si, di, cx, 
;returns:       FLAGS en ZF = 1 si es letra, ZF = 0 si no
copyString proc

    push bp
    mov bp, sp

    LOOP_START:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop LOOP_START

    pop bp
    ret
copyString endp