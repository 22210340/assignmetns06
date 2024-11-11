//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que invierte una cadena ingresada por el usuario.
// Por ejemplo: "Hola" -> "aloH"
// El programa lee una cadena, la invierte y muestra el resultado.
// VIDEO: https://asciinema.org/a/tTX7U3CHpXlC6zQICH3HrKeK2
//************************************************

.data
msg1:       .string "Ingrese una cadena (máximo 100 caracteres): "
msg2:       .string "Cadena original: %s\n"
msg3:       .string "Cadena invertida: %s\n"
formato:    .string "%99s"           // Limita la entrada a 99 caracteres + null
buffer:     .skip 100               // Buffer para almacenar la cadena
invertida:  .skip 100               // Buffer para la cadena invertida

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Imprimir mensaje solicitando la cadena
    adr     x0, msg1
    bl      printf

    // Leer la cadena del usuario
    adr     x0, formato
    adr     x1, buffer
    bl      scanf

    // Mostrar cadena original
    adr     x0, msg2
    adr     x1, buffer
    bl      printf

    // Preparar para invertir la cadena
    adr     x19, buffer             // x19 = dirección de la cadena original
    adr     x20, invertida          // x20 = dirección donde guardaremos la invertida
    
    // Calcular longitud de la cadena
    mov     x21, x19                // x21 = puntero temporal a la cadena
    mov     x22, #0                 // x22 = contador de longitud

contar_longitud:
    ldrb    w23, [x21]              // Cargar byte actual
    cbz     w23, fin_conteo         // Si es 0, terminamos
    add     x21, x21, #1            // Avanzar al siguiente carácter
    add     x22, x22, #1            // Incrementar contador
    b       contar_longitud

fin_conteo:
    // x22 ahora contiene la longitud de la cadena
    sub     x21, x21, #1            // Apuntar al último carácter (antes del null)

invertir_cadena:
    cmp     x21, x19                // Comparar con inicio de la cadena
    blt     fin_inversion           // Si ya procesamos toda la cadena, terminar
    
    ldrb    w23, [x21]              // Cargar carácter actual
    strb    w23, [x20]              // Guardarlo en la nueva posición
    
    sub     x21, x21, #1            // Retroceder en cadena original
    add     x20, x20, #1            // Avanzar en cadena invertida
    b       invertir_cadena

fin_inversion:
    // Agregar null terminator
    mov     w23, #0
    strb    w23, [x20]

    // Mostrar cadena invertida
    adr     x0, msg3
    adr     x1, invertida
    bl      printf

    // Epílogo
    mov     w0, #0                  // Retornar 0
    ldp     x29, x30, [sp], 16      // Restaurar frame pointer y link register
    ret

    //C# 

    /* #include <stdio.h>
#include <string.h>

int main() {
    char buffer[100], invertida[100];
    
    // Solicitar la cadena
    printf("Ingrese una cadena (máximo 100 caracteres): ");
    scanf("%99s", buffer);  // Leer hasta 99 caracteres
    
    // Mostrar la cadena original
    printf("Cadena original: %s\n", buffer);
    
    // Invertir la cadena
    int len = strlen(buffer);
    for (int i = 0; i < len; i++) {
        invertida[i] = buffer[len - 1 - i];
    }
    invertida[len] = '\0';  // Agregar el terminador nulo
    
    // Mostrar la cadena invertida
    printf("Cadena invertida: %s\n", invertida);
    
    return 0;
}
*/
