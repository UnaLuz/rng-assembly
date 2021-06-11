.8086
.model small
.stack 100h
.data
.code
public toAscii
public seedInicial
public printar
public contar

;Recibe en AX el numero a convertir
;Recibe en BX el offset de la variable (de dos caracteres)
;Recibe en CL la base, (10d si es decimal, 16d si es hexa, 2d si es binario)
;Recibe en DI la cantidad de caracteres
;Es necesario que la base sea menor o igual a 16 para que el resto de la division sea de 8bitsy pueda ser usado como caracter
toAscii proc
  push ax
  push dx
  push di
  pushf

  inicio:
    dec di
  	xor dx, dx
    div cx    			;Divido por la base (en 16bits)

    cmp dl, 9				;Me fijo si es un numero o una letra (en el caso de que la base sea 16)
    jbe num
    add dl, 07h   	;sumo 11h para luego sumar 30h y obtener 41h
    num:
    add dl, 30h

    mov [bx+di], dl ;Guardo el digito
    
    cmp ax, 0				;Termino una vez que el cociente es 0
    je finConv
    
    jmp inicio
  finConv:
  popf
  pop di
  pop dx
  pop ax
  ret
toAscii endp


;Genera una semilla a partir de la fecha y hora del sistema
;Devuelve por AX la semilla generada
seedInicial proc
  push bx
  push cx
  push dx
  pushf

  xor ax, ax
  xor bx, bx
  xor cx, cx
  xor dx, dx

  mov ah, 2ah   ;Obtengo la fecha
  int 21h       ;CX = YY, DH = M, DL = D, AL = w (dia de la semana, ej: 00h = Domingo) 

  xor ah, ah    ;Limpio AH, no me interesa el 2Ah

  ;Sumo todo en BX
  add bx, cx
  add bx, dx
  add bx, ax
  mov ax, bx    ;Pongo una copia de lo obtenido hasta ahora en AX
  shl ax, 1     ;Shifteo y luego xoreo para extra "randomness"
  xor bx, ax
  
  mov ah, 2ch   ;Obtengo la hora, CH = Hr, CL = Min, DH = Sec, DL = 1/100sec
  int 21h

  add bx, cx
  add bx, dx
  or bx, 8101h  ;Necesito que el seed sea distinto de cero e impar en el bit menos significativo de cada byte
                ;y por las dudas, tambien seteo el bit más significativo en 1
  mov ax, bx

  popf
  pop dx
  pop cx
  pop bx
  ret
seedInicial endp


;Recibe por BX el offset del texto a imprimir
;Recibe por CL el caracter de finalizacion del texto (ej: CL = 24h)
;Recibe por CH el caracter a imprimir al finalizar de imprimir el texto (caracter separador)
  ; ej: CH = 0dh (se imprimirá 0ah tambien para imprimir un salto de linea),
  ;     CH = 24h (para no hacer nada),
  ;     CH = 20h (para imprimir un espacio)
printar proc
  push ax
  push bx
  push cx
  pushf

  print:
    cmp byte ptr [bx], cl
    je finPrint

    ;Imprimo el caracter que está en la posicion de SI
    mov ah, 2
    mov dl, [bx]
    int 21h

    ;Incremento SI para pasar el caracter siguiente
    inc bx
  jmp print

  finPrint:
  ;Imprimo el caracter separador
  mov ah, 2
  mov dl, ch
  int 21h

  cmp ch, 0dh
  jne finPrintar
  ;Si es un caracter 0dh (\r) imprimo un 0ah (\n) 
  mov ah, 2
  mov dl, 0ah
  int 21h
  
  finPrintar:
  popf
  pop cx
  pop bx
  pop ax
  ret
printar endp


;Recibe por BX un offset
;Recibe por DL el caracter de finalizacion (no es incluido)
;Devuelve por DI la cantidad de caracteres
contar proc
  push dx
  pushf

  xor di, di
  contarChars:
  cmp [bx+di], dl
  je finContar

  inc di
  jmp contarChars
  finContar:

  popf
  pop dx
  ret
contar endp

end