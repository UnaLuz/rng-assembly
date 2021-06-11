;Genera un unico valor random de 2bytes y lo imprime por pantalla en Hexa
.8086
.model small
.stack 100h
.data
  randNum db "0000", 24h
  salto db 0dh, 0ah, 24h
.code
extrn seedInicial:proc
extrn toAscii:proc
extrn contar:proc

main proc

  mov ax, @data
  mov ds, ax

  int 80h   ;Limpio la pantalla

  xor ax, ax

  call seedInicial
  mov si, ax    ;Inicializo SI
  mov di, ax    ;Inicializo DI
  ;Uso la semilla para inicializarlos pero el random "anterior" puede ser cualquier numero para empezar
  int 81h   ;Genero un numero random

  mov bx, offset randNum
  mov dl, 24h
  call contar     ;Cuento la cantidad de caracteres en randNum
  mov cl, 16      ;Base 16
  call toAscii    ;Paso el numero a ascii

  mov ah, 9
  mov dx, offset randNum
  int 21h

  mov ah, 9
  mov dx, offset salto
  int 21h

  mov ax, 4C00h
  int 21h

main endp


end main
