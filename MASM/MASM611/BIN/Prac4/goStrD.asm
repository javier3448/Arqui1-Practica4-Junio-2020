markedArray db 81 dup(0) ;81d = 51h

;Puede representar goString o goTeritory
;[0] Color 
;[1] size (numero de coordenadas con fichas, cada coordenada ocupa 2 bytes)
;[2] libs (numero de libertades, cada coordenada representa una ficha, cada coordenada ocupa 2 bytes)
;[3 ... 164] parejas de coordenadas de fichas ;164d = A4h, size: 162d = A2h
;[165 ... 204] parejas de coordenadas de libertades ;165d = A5h 100d = 64h
goObj db 205 dup(0ffh)

adyacentOffsets db 0, -1,
                   1, 0,
                   0, 1,
                   -1, 0
