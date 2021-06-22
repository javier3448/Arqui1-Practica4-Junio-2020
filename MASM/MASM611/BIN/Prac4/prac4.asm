include macros.asm
include filesM.asm
include stringM.asm
include gameM.asm
include htmlM.asm
include goStrM.asm

.model small, stdcall
.386
.stack 400h
    
.data
    include htmlD.asm
    include goStrD.asm

    newLine db 0ah, 0dh

    ;no se porque poner los mensajes abaj del menuMsg1 hace
    ;que se imprima el menuMsg0 con todo y este mensaje
    suicideMsg db 0ah, 0dh, "El movimiento causaria un suicidio$"
    koMsg db 0ah, 0dh, "Movimiento KO$"

    menuMsg0 db 0ah, 0dh, 
             "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0ah, 0dh,
             "FACULTAD DE INGENIERIA", 0ah, 0dh,
             "CIENCIAS Y SISTEMAS", 0ah, 0dh,
             "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 0ah, 0dh
    menuMsg1 db 0ah, 0dh,
             "NOMBRE: JAVIER ANTONIO ALAVREZ GONZALEZ", 0ah, 0dh,
             "CARNET: 201612383", 0ah, 0dh,
             "SECCION A", 0ah, 0dh, 0ah, 0dh,
             "1) Iniciar Juego", 0ah, 0dh,
             "2) Cargar Juego", 0ah, 0dh,
             "3) Salir", 0ah, 0dh, '$'
    wrongCharMsg db 0ah, 0dh, "Caracter no valido.", '$'

    usrInput db 16 dup('$')

    gameLineJumps db 0ah, 0dh,  0ah, 0dh,  0ah, 0dh,  0ah, 0dh, 0ah, 0dh,  0ah, 0dh,  0ah, 0dh,  0ah, 0dh,"$"

    lastLastBoard db 877 dup("$")
    lastBoard db 877 dup("$")

	board0 db "1   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,;Usamos mas variables de las necesarias
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh,
              "2   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh
    board1 db "3   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh,
              "4   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh
    board2 db "5   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh,
              "6   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh
    board3 db "7   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh,
              "8   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh,
              "  |    |    |    |    |    |    |    |    | " , 0ah, 0dh,
              "9   ---  ---  ---  ---  ---  ---  ---  ---  " , 0ah, 0dh
    board4 db "                                            " , 0ah, 0dh,
              "  A    B    C    D    E    F    G    H    I " , "$"
    currTurn db 0 ;0 = black, 1 = white, empizan negras ; conviene tener el truno continuo a el string con el tablero porque asi lo podemos guardar en el archivo facilmente
    lastTurn db 0 ;indica si el turno anterior fue PASS (0 hubo pass, 1 se jugo una pieza)
    bScore db 0
    wScore db 0

    FB db    "FN"
    FW db    "FB"
    EMPTY db "  "

    wTurnMsg db 0ah, 0dh, "Turno blancas:  ", "$"
    bTurnMsg db 0ah, 0dh, "Turno negras:   ", "$"


.code 
    include htmlP.inc
    include stringP.inc
    include cmdP.inc
    include gameP.inc
    include filesP.inc
    include goStrP.inc
main proc far
    mov ax,@DATA 
    mov ds,ax

    MENU:
        print menuMsg0

        cmdGetChar
        cmp al, "1"
        je GAME
        cmp al, "2"
        je CARGAR_JUEGO
        cmp al, "3"
        je SALIR
        cmp al, "4"
        je DEBUG_MODE

        print wrongCharMsg
        cmdGetChar ;Nada mas para esperar el enter del usuario
        jmp MENU
    
    GAME:
        paintGame
        
        cmp currTurn, 0
        je BLACK_TURN
        cmp currTurn, 1
        je WHITE_TURN

        BLACK_TURN:
            print bTurnMsg
            cmdGetString usrInput, "$"
            mPlayBlackPiece usrInput
            cmp ax, 0
            je PLAYED_PIECE 
            cmp ax, 1
            je SPECIAL_COMMAND
            cmp ax, 2
            je OVER_OTHER_PIECE
            cmp ax, 3
            je SUICIDE
            cmp ax, 4
            je KO
            cmdGetChar
            jmp GAME

        WHITE_TURN:
            print wTurnMsg
            cmdGetString usrInput, "$"
            mPlayWhitePiece usrInput
            cmp ax, 0
            je PLAYED_PIECE 
            cmp ax, 1
            je SPECIAL_COMMAND
            cmp ax, 2
            je OVER_OTHER_PIECE
            cmp ax, 3
            je SUICIDE
            cmp ax, 4
            je KO
            cmdGetChar
            jmp GAME

        OVER_OTHER_PIECE:
            debPrintln "No se puede colocar una pieza sobre otra"
            cmdGetChar
            jmp GAME

        SUICIDE:
            print suicideMsg
            cmdGetChar
            jmp GAME

        KO:
            print koMsg
            cmdGetChar
            jmp GAME

        SPECIAL_COMMAND:
            debPrintln <"Special command">
            cmdGetString usrInput, "$"
            lea bx, usrInput
            mov al, [bx + 2]
            cmp al, 'S'
            je PASS
            cmp al, 'I'
            je EXIT
            cmp al, 'V'
            je SAVE
            cmp al, 'O'
            je SHOW
            ;TODO: revisar que comando es ejecutarlo

            WRONG_COMMAND:
            debPrintln <"Comando no reconocido">
            cmdGetChar
            jmp GAME

            PASS:
            mov al, lastTurn
            cmp al, 0 ;el paso en el ultimo turno tambien terminamos el juego
            je END_GAME
            mov lastTurn, 0
            xor currTurn, 1 ;le hacemos toggle
            jmp GAME

            EXIT:
            ;Reiniciar los last y lastlast
            debPrintln <"Exit">
            mResetBoards
            jmp MENU

            SAVE:
            debPrintln <"Ingrese nombre para guardar: ">
            cmdGetString usrInput, 0
            mMakeAndWriteFile usrInput, board0, 877
            jc ERROR_SAVE
            jnc EXITO_SAVE
            ERROR_SAVE:
            debPrintln <"Error al guardar partida">
            EXITO_SAVE:
            debPrintln <"Partida guarda exitosamente">
            cmdGetChar
            jmp GAME

            SHOW:
            debPrintln <"Show">
            lea bx, htmlFileName
            mov byte ptr[bx + 3], 'c';para que tenga nombre diferente al reporte final
            mMkHtml
            jmp GAME

        PLAYED_PIECE:
            mov lastTurn, 1 ;sirve para indicar que el turno anterior no fue PASS
            xor currTurn, 1 ;le hacemos toggle
            jmp GAME

        END_GAME:
            mEndScanBoard

            mov al, bScore
            cmp al, wScore
            ja NEGRAS_GANAN
            ;else:
            debPrintln <"blancas ganan!">
            jmp END_IF

            NEGRAS_GANAN:
            debPrintln <"negras ganan!">
            
            END_IF:
            lea bx, htmlFileName
            mov byte ptr[bx + 3], 'e';para que tenga nombre diferente al reporte final
            mMkHtml
            mResetBoards
            debPrintln <"Temino el juego">
            cmdGetChar
            jmp MENU

    CARGAR_JUEGO:
        debPrintln <"Ingrese nombre del archivo: ">
        cmdGetString usrInput, 0
        mGetFileContent usrInput, board0, 877, ax
        jc ERROR_CARGAR_PARTIDA
        jnc EXITO_CARGAR_PARTIDA
        ERROR_CARGAR_PARTIDA:
        debPrintln<"Error al cargar partida">
        cmdGetChar
        jmp MENU
        EXITO_CARGAR_PARTIDA:
        debPrintln<"Exito al cargar partida">
        cmdGetChar
        jmp GAME

    SALIR:
        mResetBoard
        debPrintln <"SALIR">
        cmdGetChar
        mov ah,4ch
        int 21h 

    DEBUG_MODE:
        paintGame
        int 3
        mScanBoard
        paintGame
        int 3

        jmp MENU

    mov ah,4ch
    int 21h 

main endp 
end main 