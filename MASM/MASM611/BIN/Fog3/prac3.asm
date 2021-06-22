;Contiene el main, compilar este archivo. No se nombro main.asm porque asi saca un .exe diferente para cada practica


include macros.asm
include mFiles.asm
include mFilts.asm
include mRep.asm

.model small, stdcall
.286
.stack 100h
    include pString.inc
    include pCmd.inc
.data
;file data:
filePath db 0ffh dup(1), "$" ;null terminated
fileContent db 08000h dup(0), "$" 
fileSize dw 0ffffh ;ffff significa que no se ha cargado un archivo valido todavia, el tamanno maixmo que puede tener un archivo es 8000h
reportPath db 255 dup(0), "$" ;null terminated

;find and replace:
searchedString db 08fh
replacementString db 08fh

;String data:
newLine db 0ah, 0dh, "$" ;TODO: 2Quitar si no usamos!

;Menu data TODO pasara cad parte de data a otros archivos
menuMsg0 db  0ah, 0dh, 
             "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0ah, 0dh,
             "FACULTAD DE INGENIERIA", 0ah, 0dh,
             "CIENCIAS Y SISTEMAS", 0ah, 0dh,
             "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 0ah, 0dh,
             "SECCION (A|B)", 0ah, 0dh
menuMsg1 db  "NOMBRE: OSCAR RENE CUELLAR MANCILLA", 0ah, 0dh,
             "CARNET: 201503712", 0ah, 0dh, 
             0ah, 0dh,
             "TAREA PRACTICA 3", 0ah, 0dh, 
             0ah, 0dh,
             "MENU PRINCIPAL", 0ah, 0dh,
             "1) CARGAR TEXTO", 0ah, 0dh
menuMsg2 db  "2) A MAYUSCULA", 0ah, 0dh,
             "3) A MINUSCULA", 0ah, 0dh,
             "4) A CAPITAL", 0ah, 0dh,
             "5) BUSCAR Y REEMPLAZAR", 0ah, 0dh,
             "6) INVERTIR PALABRAS", 0ah, 0dh
menuMsg3 db  "7) REPORTE DIPTONGOS", 0ah, 0dh,
             "8) REPORTE HIATOS", 0ah, 0dh,
             "9) REPORTE TRIPTONGOS", 0ah, 0dh,
             "a) REPORTE FINAL", 0ah, 0dh,
             "b) SALIR", 0ah, 0dh, "$"
wrongCharMsg db 0ah, 0dh, "Caracter no valido.", "$"
ErrorCargarTextoMsg db 0ah, 0dh, "Error Cargando Texto", "$"
ExitoCargarTextoMsg db 0ah, 0dh, "Texto cargado exitosamente", "$"
ErrorReporteFinalMsg db 0ah, 0dh, "Error creando reporte final", "$"
ErrorSinArchivoMsg db 0ah, 0dh, "Error. Abrir archivo antes.", "$"
ExitoReporteFinalMsg db 0ah, 0dh, "Reporte final creado exitosamente", "$"
IngresarDireccionMsg db 0ah, 0dh, "Ingrese la direccion del archivo:", "$";FUNCIONA PARA LAS INSTRUCCIONES DEL REPORTE FINAL TAMBIEN
ExitoAMayusculaMsg db 0ah, 0dh, "Filtro: A MAYUSCULA completado exitosamente", "$"
ExitoAMinusculaMsg db 0ah, 0dh, "Filtro: A MINUSCULA completado exitosamente", "$"
ExitoACapitalMsg db 0ah, 0dh, "Filtro: A CAPITAL completado exitosamente", "$" ; se desperdicia un moton de memoria en estos mensajes
ExitoInvertirMsg db 0ah, 0dh, "Filtro: INVERTIR completado exitosamente", "$" 

debString db "Nvp 8 vE9Nd yyB mRhH b0o c8A ElB%mdKb$"
debString1 db "Nvp"
debStringSize dw 37
debChar dw 06161h ;aa
dipCrecCount db 0
dipDecCount db 0
dipHomoCount db 0
debByteString db "ffh$"
debChar1 db "A"
debCopyBx dw 0ffh
debAddress dw 0ffffh
;Other data:
include dRep.asm
include dFilts.asm


.code
main proc far
    mov ax,@DATA 
    mov ds,ax

    mov [debString], cl
    mov ax, 2
    imul ax, 2
    print debString

    MENU:
    ;este menu no se puene hacer con cmdGetChar porque 
        print menuMsg0
        
        cmdGetChar
        cmp al, "1"
        je CARGAR_TEXTO
        cmp al, "2"
        je A_MAYUSCULA
        cmp al, "3"
        je A_MINUSCULA
        cmp al, "4"
        je A_CAPITAL
        cmp al, "5"
        je BUSCAR_Y_REEMPLAZAR
        cmp al, "6"
        je INVERTIR_PALABRAS
        cmp al, "7"
        je REPORTE_DIPTONGOS
        cmp al, "8"
        je REPORTE_HIATOS
        cmp al, "9"
        je REPORTE_TRIPTONGOS
        cmp al, "a"
        je REPORTE_FINAL
        cmp al, "b"
        je SALIR
        cmp al, "d"
        je DEBUG_MODE

        print wrongCharMsg
        cmdGetChar
        jmp MENU

    CARGAR_TEXTO:
        print IngresarDireccionMsg
        int 3
        cmdGetString filePath, 0
        int 3
        getFileContent filePath, fileContent, SIZEOF fileContent, fileSize
        jc ERROR_CARGAR_TEXTO
        jnc EXITO_CARGAR_TEXTO
        ERROR_CARGAR_TEXTO:
        print ErrorCargarTextoMsg
        cmdGetChar
        jmp MENU
        EXITO_CARGAR_TEXTO:
        print ExitoCargarTextoMsg
        cmdGetChar
        jmp MENU

    A_MAYUSCULA:
        cmp fileSize, 0ffffh
        je ERROR_SIN_ARCHIVO
        toUpper fileContent, fileSize
        print ExitoAMayusculaMsg
        cmdGetChar
        jmp MENU

    A_MINUSCULA:
        cmp fileSize, 0ffffh
        je ERROR_SIN_ARCHIVO
        toLower fileContent, fileSize
        print ExitoAMinusculaMsg
        cmdGetChar
        jmp MENU

    A_CAPITAL:
        cmp fileSize, 0ffffh
        je ERROR_SIN_ARCHIVO
        toCapital fileContent, fileSize
        print ExitoACapitalMsg
        cmdGetChar
        jmp MENU

    BUSCAR_Y_REEMPLAZAR:
        debPrintln<"BUSCAR_Y_REEMPLAZAR no implementado todavia">
        cmdGetChar
        jmp MENU

    INVERTIR_PALABRAS:
        cmp fileSize, 0ffffh
        je ERROR_SIN_ARCHIVO
        invert fileContent, fileSize
        print ExitoInvertirMsg
        cmdGetChar
        jmp MENU

    REPORTE_DIPTONGOS:
        cmp fileSize, 0ffffh
        je ERROR_SIN_ARCHIVO
        getDiptongos fileContent, fileSize, dipCrecCount, dipDecCount, dipHomoCount
        lea bx, reporteDipCrecCount
        push bx
        mov al, dipCrecCount
        call byteToHexAscii
        lea bx, reporteDipDecCount
        push bx
        mov al, dipDecCount
        call byteToHexAscii
        lea bx, reporteDipHomoCount
        push bx
        mov al, dipHomoCount
        call byteToHexAscii
        print reporteDipMsgCrec
        cmdGetChar
        jmp MENU

    REPORTE_HIATOS:
        debPrintln<"REPORTE_HIATOS no implementado todavia">
        cmdGetChar
        jmp MENU

    REPORTE_TRIPTONGOS:
        debPrintln<"REPORTE_TRIPTONGOS no implementado todavia">
        cmdGetChar
        jmp MENU

    REPORTE_FINAL:
        cmp fileSize, 0ffffh
        je ERROR_SIN_ARCHIVO
        print IngresarDireccionMsg
        cmdGetString reportPath, 0
        makeAndWriteFile reportPath, fileContent, fileSize
        jc ERROR_REPORTE_FINAL
        jnc EXITO_REPORTE_FINAL
        ERROR_REPORTE_FINAL:
        print ErrorReporteFinalMsg
        cmdGetChar
        jmp MENU
        EXITO_REPORTE_FINAL:
        print ExitoReporteFinalMsg
        cmdGetChar
        jmp MENU
    
    DEBUG_MODE:
        int 3
        jmp MENU
    
    SALIR:
        mov ah,4ch
        int 21h 

    ;ERRORES QUE USAN VARIAS OPCIONES DEL MENU PRINCIPAL. 
    ERROR_SIN_ARCHIVO:
        print ErrorSinArchivoMsg
        cmdGetChar
        jmp MENU
main endp 
end main 