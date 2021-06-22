htmlFileName db "c:\c_game.htm", 0 ;null terminated, tambien puede ser end.htlm, si necesitamos dos archivos html para los reportes

head db "<!DOCTYPE html>",
        "<html>",
        "<head>",
        "</head>",
        "<body><center>",
        "<table border=0 cellspacing=0 cellpadding=0>",
            "Javier Antonio Alvarez Gonzalez<br/>",
            "201612383",
            "<br/>",
            "<h1>"
htmlDay db  "DD/"
htmlMonth db "MM/"
htmlYear db "YY-"
htmlHour db "hh:"
htmlMinute db "mm:"
htmlSecond db "ss</h1><br/>Puntuacion negras: "
htmlBScore db "bbb<br/>Puntuacion blancas: "
htmlWScore db "www"

closing db "</table>",
           "</center></body></html>",
           "</html>"

_sizeHtlm dw 4249
_sizeHead dw 223
_sizeClosing dw 31

trOpen db "<tr>", 0ah
trClose db "</tr>", 0ah

td db "<td width=75 height=75 background=img"
tdNumber db "1"
tdLetter db "W.png></td>"
_sizeTd dw 49

decBuffer db "000"

; 1   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 2   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 3   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 4   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 5   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 6   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 7   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 8   ---  ---  ---  ---  ---  ---  ---  ---  a
;   |    |    |    |    |    |    |    |    | a
; 9   ---  ---  ---  ---  ---  ---  ---  ---  a
;                                             a
;   A    B    C    D    E    F    G    H    I aclbw