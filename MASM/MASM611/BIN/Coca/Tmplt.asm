;template for masm510 programming using simplified segment definition BY https://cs.lmu.edu/~ray/notes/x86assembly/
 title YOUR TITLE HERE
 page 60,132 
 ;tell the assembler to create a nice .lst file for the convenience of error pruning
 .model small 
 ;maximum of 64KB for data and code respectively
 .stack 64
 .data
 ;PUT YOUR DATA DEFINITION HERE
 .code
 main proc far 
 ;This is the entry point,you can name your procedures by altering "main" according to some rules
 mov ax,@DATA 
 ;load the data segment address,"@" is the opcode for fetching the offset of "DATA","DATA" could be change according to your previous definition for data
 mov ds,ax 
 ;assign value to ds,"mov" cannot be used for copying data directly to segment registers(cs,ds,ss,es)
 ;PUT YOUR CODE HERE
 mov ah,4ch
 int 21h 
 ;terminate program by a normal way
 main endp 
 ;end the "main" procedure
 end main 
 ;end the entire program centering around the "main" procedure


 ;MY SIMPLIFIED TEMPLATE
.model small 
.stack
.data

.code
main proc far 
    mov ax,@DATA 
    mov ds,ax 

    

    mov ah,4ch
    int 21h 
main endp 
end main 
;end the entire program centering around the "main" procedure



;COMENTARIO DE DOCUMENTACION:



;Dependencies:  unMacro (cosas que se tienen que definir en otro archivo solamente)
;Parameters:    DS:[bp+4] string1
;               DS:[bp+6] string2
;Returns:       AX = tamanno de la cadena de entrada.      
;Registers:     AX, BX, CX    
;Comments:      Afecta las banderas cero y acarrero
;               de la misma forma que la instruccion cmp.

;Registers: significa que registros afectara ese procedimiento. Es responsabilidad del caller hacerle copia a esos registros en el stack si quiere guardar su info antes

;Si no tiene una vinneta se asume que es void
