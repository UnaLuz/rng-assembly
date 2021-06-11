;-----------------------------------------------------------------------
; Programa TSR que se instala en el vector de interrupciones 80h
; que suma AX a BX a traves de la int 80h
; Se debe generar el ejecutable .COM con los siguientes comandos:
; tasm tsr2.asm
; tlink /t tsr2.obj
;-----------------------------------------------------------------------
.8086
.model tiny   ; Definicion para generar un archivo .COM
.code
   org 100h   ; Definicion para generar un archivo .COM
start:
  jmp main   ; Comienza con un salto para dejar la parte residente primero

;------------------------------------------------------------------------
;- Part que queda residente en memoria y contine las ISR
;- de las interrupcion capturadas
;------------------------------------------------------------------------
Funcion PROC FAR
  sti
  ; La funcion ISR que atendera la interrupcion capturada
  push ax
  push es
  push cx
  push di
  mov ax,3
  int 10h
  mov ax,0b800h
  mov es,ax
  mov cx,1000
  mov ax,7
  mov di,ax
  cld
  rep stosw
  pop di
  pop cx
  pop es
  pop ax
  iret
endp

; Datos usados dentro de la ISR ya que no hay DS dentro de una ISR
DespIntXX dw 0
SegIntXX  dw 0

FinResidente LABEL BYTE   ; Marca el fin de la porción a dejar residente
;------------------------------------------------------------------------
; Datos a ser usados por el Instalador
;------------------------------------------------------------------------
Cartel    DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$'

main:         ; Se apuntan todos los registros de segmentos al mismo lugar CS.
  mov ax,CS
  mov DS,ax
  mov ES,ax

InstalarInt:
  mov AX,3580h        ; Obtiene la ISR que esta instalada en la interrupcion
  int 21h    
       
  mov DespIntXX,BX    
  mov SegIntXX,ES

  mov AX,2580h    ; Coloca la nueva ISR en el vector de interrupciones
  mov DX,Offset Funcion 
  int 21h

MostrarCartel:
  mov dx, offset Cartel
  mov ah,9
  int 21h

DejarResidente:   
  Mov     AX,(15 + offset FinResidente) ;Sumo 15 para asegurarme un parágrafo más
  Shr     AX,1            
  Shr     AX,1        ;Se obtiene la cantidad de parágrafos
  Shr     AX,1    ;ocupado por el codigo dividiendo por 16
  Shr     AX,1
  Mov     DX,AX           
  Mov     AX,3100h    ;y termina sin error 0, dejando el
  Int     21h         ;programa residente
end start
