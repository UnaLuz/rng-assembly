;Imprime por pantalla 10 numeros random en Hexa de 2bytes separados por un espacio
.8086
.model small
.stack 100h
.data
  randNum db "0000", 24h
  seed        dw 0
  weylseq     dw 0
  prevRandInt dw 0
  salto db 0dh, 0ah, 24h
.code
;Imports
extrn toAscii:proc
extrn seedInicial:proc
extrn printar:proc
extrn contar:proc

main proc

  mov ax, @data
  mov ds, ax

  int 80h               ;CLS

  call seedInicial      ;Obtengo una semilla inicial
  mov seed, ax
  mov weylseq, ax
  mov prevRandInt, ax

  mov cx, 10            ;Cantidad de numeros random a generar
  GRN:
    mov ax, seed
    mov si, weylseq     ;Secuencia de Weyl
    mov di, prevRandInt
    int 81h             ;Genero un numero random
    mov weylseq, si
    mov prevRandInt, ax

    push cx             ;Necesito usar CX asi que lo mando al stack
    
    mov bx, offset randNum
    mov dl, 24h
    call contar         ;Cuento la cantidad de caracteres donde quiero guardar el num
    mov cl, 16          ;Quiero el numero en hexa (base 16)
    call toAscii
    mov cx, 2024h       ;Indico que quiero imprimir hasta un 24h, e imprimir un 20h al final
    call printar

    pop cx              ;Recupero el valor de CX que habia mandado al stack
  loop GRN

  mov ah, 9
  mov dx, offset salto
  int 21h

  mov ax, 4C00h
  int 21h

main endp

end main
