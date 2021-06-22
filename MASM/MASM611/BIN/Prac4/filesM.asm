;mFileManager

;Parameters:  path = null terminated string con la ubicacion del archivo a leer
;             container = buffer donde se van escribir todos los bytes leidos en el archivo
;             maxsize = numero maximo de bytes a leer del archivo (usualmete sizeof buffer)
;             endsize = 'variable' donde se escribira el numero real de bytes leidos del archivo
;Returns:     CF = 1 si hubo error
;             AX = Error code si cf es 1
;             endsize = numero real de bytes leidos, se setea a ffffh en caso que no se lea el archivo exitosamente
;Comments:    Es ambiguo porque solo se sabe si hubo error,
;             No se sabe si fue error al abrir archivo, leer archivo o cerrar archivo
mGetFileContent macro path, container, maxsize, endsize
LOCAL End
    mov endsize, 0ffffh;Por ahora indicamos que endsize no se ha leyo el archivo exitosamente

    ;Open file
    mov ah, 3dh ;abrir fichero
    mov al, 02h ;Lectura y escritura
    lea dx, path ;puntero al string con la direccion
    int 21h
    jc End ;si carry es 1 hay error
    ;End Open file

    ;Read file 
    mov bx, ax ;Si abrio el archivo exitosamente ax es handler, entonces lo movemos a bx para hacer la interrupcion readfile (3fh)
    mov ah, 3fh
    mov cx, maxsize
    lea dx, container
    int 21h
    jc End
    mov endsize, ax ;3fh retorna el numero de bytes leidos realmente en el registro ax. Esta instruccion solo se ejecutarar si no occurrio error al abrir el archivo
    ;End read file

    ;Close file
    mov ah, 3eh
    ;mov bx, handler ;bx todavia contiene el handler debido a la operacion anterior por eso no es necesaria esta linea
    int 21h
    jc End
    ;End close file

    End:
endm

mMakeAndWriteFile macro path, content, contentSize
LOCAL End
    ;makeFile
    mov ah, 3ch
    xor cx, cx
    lea dx, path
    int 21h
    jc End ; Si no hubo carry no hay error entonces se salta hacia end sin imprimir el mensaje de error [???]
    ;End makeFile

    push ax ;ponemos en el stack handler [bp]

    ;writeContent
    mov bx, ax ; ax tiene el handler del archivo que se acaba de crear
    mov ah, 40h
    mov cx, contentSize
    lea dx, content
    int 21h
    ;End writeContent

    ;Close file
    mov ah, 3eh
    ;mov bx, handler ;bx todavia contiene el handler debido a la operacion anterior por eso no es necesaria esta linea [???]
    int 21h
    jc End
    ;End close file

    End:
endm

;Por alguna razon poner pusha y popa antes y despues de los macros de archivos
;No nos deja escribir en el mismo :(

;Devuelbe en ax el handler, si ocurrio error flag carry esta en 1
openFile macro path
    mov ah, 3ch
    xor cx, cx
    lea dx, path
    int 21h
endm

;returns: cx numero de bytes escritos, carry flag verdadera si ocurrio error
writeContent macro handler, _size, content
    mov bx, handler
    mov ah, 40h
    mov cx, _size
    lea dx, content
    int 21h
endm

;carry flag verdadera si ocurrio error
closeFile macro handler
    mov ah, 3eh
    mov bx, handler ;bx todavia contiene el handler debido a la operacion anterior por eso no es necesaria esta linea [???]
    int 21h
endm

;retorna en ax el handler del nuevo archivo, carry flag si ocurrio un error
newFile macro path
LOCAL End
    ;makeFile
    mov ah, 3ch
    xor cx, cx
    lea dx, path
    int 21h
endm
