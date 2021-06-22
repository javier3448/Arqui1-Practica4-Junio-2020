;Loop

include macJon.asm
.model small
.286
.stack

include proc.inc

.data
    include datJon.asm
    
.code
main proc far 
    mov ax,@DATA 
    mov ds,ax 

    printReg bp
    printReg ss
    printReg sp

    mov ax,4c00h
    int 21h 
main endp 
end main 