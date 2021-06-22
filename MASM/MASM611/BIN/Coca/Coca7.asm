;Crear y escribir en archivo

include macros.asm

.model small 
.stack
.data
filePath db 255 dup("$") ;255 bytes
filePathDeb db "c:\MASM611\BIN\Coca\archs\arch0.txt", 0, "$"
newFilePathDeb db "c:\MASM611\BIN\Coca\archs\new.txt", 0, "$"
fileHandler dw ? ; ? significa que no esta 'inicializado' todavia
fileContent db 255 dup("$") 
errorMsg1 db "Error leyendo el archivo", "$"
errorMsg2 db "Error cerrando el archivo", "$"
errorMsg3 db "Error creando el archivo", "$"
errorMsg4 db "Error escribiendo el archivo", "$"

.code
main proc far
    Inicio:
    mov ax,@DATA 
    mov ds,ax 

    println filePathDeb    
    openFile filePathDeb, fileHandler
    readFile fileHandler, fileContent, SIZEOF fileContent ;Imagino que el sizeof solo funciona como en c y no se puede utilizar en arrays que se pasaron como parametro

    getChar

    println fileContent

    closeFile fileHandler

    makeFile newFilePathDeb, filehandler

    fillString fileContent, SIZEOF fileContent, "0"

    getCString fileContent ;Consigue el nuevo string para escribir en el archivo

    writeFile fileHandler, SIZEOF fileContent, fileContent

    mov ah,4ch
    int 21h 
main endp 
end main 