# rng-assembly

Implementación del método Middle square-Weyl sequence para generar números random en Aseembly language x86 (TASM)

---

## Numeros random

La implementación del algoritmo se realiza en parte en la interrupción 81 creada.<br>
Aún así es necesario generar una primera semilla al inicio del programa y en caso de necesitar más de un numero random, se debe guardar la semilla, la sumatoria de la semilla (secuencia de Weyl) y el número random generado anteriormente.

Para la generación de la semilla hay algunas ***restricciones***.<br>
En todos los lugares en los que encontré información decían que la semilla **no puede ser par**.<br>
Además en algunos lugares decían que el **bit menos significativo** de la parte alta **no puede ser cero** mientras que en otros decía que el **bit más significativo** no puede ser cero.<br>
Por eso en mi función me aseguro que ninguno de los 3 sea cero, por las dudas.

## Ejemplos

Junto con la interrupcion que contiene el algoritmo y la librería que contiene pricipalmente la funcion que genera una semilla basada en la fecha y hora, hay dos ejemplos: **rands.asm** y **randint.asm**

### randint.asm

Genera un numero random de 16 bits y lo imprime por pantalla en hexa

### rands.asm

Genera 10 numeros random de 16 bits y los imprime por pantalla en hexa separados por un espacio

## Compilar y ejecutar

Primero se deben instalar las interrupciones, para eso uso el archivo intrs.bat

```DOS
intrs

```

Luego se compila el archivo que se desea ejecutar junto con la libreria, para esto se puede ejecutar el archivo complib.bat

```DOS
complib nombre_del_archivo

```

Con esto se debería compilar y ejecutar el archivo deseado (rands.asm o randint.asm en este caso) sin problemas