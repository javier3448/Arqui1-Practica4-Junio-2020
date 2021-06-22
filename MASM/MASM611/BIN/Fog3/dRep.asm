vocalesAbiertas db "aeoAEO"
;vocalesAbiertasLength db 6 ;TODO: cuando aprendamos a hacer constantes agregar esta linea como constante
vocalesCerradas db "iuIU"
;vocalesCerradasLength db 4 ;TODO: cuando aprendamos a hacer constantes agregar esta linea como constante

reporteDipMsgCrec db 0ah, 0dh, "Crecientes:   "
reporteDipCrecCount db "00"
reporteDipMsgDec db 0ah, 0dh, "Decrecientes: "
reporteDipDecCount db "00"
reporteDipMsgHomo db 0ah, 0dh, "Homogeneos:   "
reporteDipHomoCount db "00$"