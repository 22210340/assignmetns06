//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que verifica si una cadena es un palíndromo.
// Un palíndromo es una palabra o frase que se lee igual de izquierda a derecha
// que de derecha a izquierda, ignorando espacios y mayúsculas/minúsculas.
// Ejemplos: "ana", "Anita lava la tina", "A man a plan a canal Panama"
// VIDEO: https://asciinema.org/a/TD00PqFaW9fQNZZINuGwC40tH
//************************************************

.data
msg1:       .string "Ingrese una cadena (máximo 100 caracteres): "
msgPal:     .string "La cadena \"%s\" ES un palindromo\n"
msgNoPal:   .string "La cadena \"%s\" NO es un palindromo\n"
formato:    .string "%99[^\n]"      // Lee hasta 99 chars incluyendo espacios
buffer:     .skip 100               // Buffer para la cadena original
limpia:     .skip 100               // Buffer para la cadena sin espacios

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

    // Limpiar buffer de entrada
    mov     x0, #0
    bl      getchar

    // Preparar para limpiar la cadena
    adr     x19, buffer             // x19 = dirección de cadena original
    adr     x20, limpia             // x20 = dirección de cadena limpia
    mov     x21, x20                // x21 = copia de dirección limpia

limpiar_cadena:
    ldrb    w22, [x19]              // Cargar carácter actual
    cbz     w22, fin_limpieza       // Si es null, terminar limpieza
    
    // Convertir a minúscula si es mayúscula
    cmp     w22, #'A'
    blt     no_es_letra
    cmp     w22, #'Z'
    bgt     no_es_letra
    add     w22, w22, #32           // Convertir a minúscula

no_es_letra:
    // Verificar si es letra o número
    cmp     w22, #'a'
    blt     siguiente_char
    cmp     w22, #'z'
    bgt     siguiente_char
    
    // Guardar carácter si es letra
    strb    w22, [x20]
    add     x20, x20, #1

siguiente_char:
    add     x19, x19, #1
    b       limpiar_cadena

fin_limpieza:
    // Agregar null terminator
    mov     w22, #0
    strb    w22, [x20]

    // Preparar para verificar palíndromo
    mov     x19, x21                // x19 = inicio de cadena limpia
    mov     x20, x20                // x20 = fin de cadena limpia
    sub     x20, x20, #1            // Retroceder antes del null

verificar_palindromo:
    cmp     x19, x20                // Comparar punteros
    bge     es_palindromo           // Si se cruzaron, es palíndromo
    
    ldrb    w22, [x19]              // Cargar carácter del inicio
    ldrb    w23, [x20]              // Cargar carácter del final
    
    cmp     w22, w23                // Comparar caracteres
    bne     no_es_palindromo        // Si son diferentes, no es palíndromo
    
    add     x19, x19, #1            // Avanzar puntero inicio
    sub     x20, x20, #1            // Retroceder puntero final
    b       verificar_palindromo

es_palindromo:
    // Imprimir mensaje de que es palíndromo
    adr     x0, msgPal
    adr     x1, buffer
    bl      printf
    b       fin

no_es_palindromo:
    // Imprimir mensaje de que no es palíndromo
    adr     x0, msgNoPal
    adr     x1, buffer
    bl      printf

fin:
    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
//C# 

/* #include <stdio.h>
#include <ctype.h>
#include <string.h>

int main() {
    char buffer[100], limpia[100];
    
    // Solicitar la cadena
    printf("Ingrese una cadena (máximo 100 caracteres): ");
    fgets(buffer, 100, stdin);  // Leer la cadena incluyendo espacios
    
    // Limpiar la cadena (eliminar no alfabéticos y convertir a minúsculas)
    int j = 0;
    for (int i = 0; buffer[i] != '\0'; i++) {
        if (isalpha(buffer[i])) {
            limpia[j++] = tolower(buffer[i]);
        }
    }
    limpia[j] = '\0';  // Terminar la cadena limpia
    
    // Verificar si la cadena es un palíndromo
    int len = strlen(limpia);
    int is_palindrome = 1;
    for (int i = 0; i < len / 2; i++) {
        if (limpia[i] != limpia[len - 1 - i]) {
            is_palindrome = 0;
            break;
        }
    }
    
    // Imprimir el resultado
    if (is_palindrome) {
        printf("La cadena \"%s\" ES un palindromo\n", buffer);
    } else {
        printf("La cadena \"%s\" NO es un palindromo\n", buffer);
    }
    
    return 0;
}
*/
