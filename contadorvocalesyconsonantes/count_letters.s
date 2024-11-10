//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que cuenta vocales y consonantes
// en una cadena ingresada por el usuario
//************************************************

    .data
msg_ingreso:    .string "Ingrese una cadena: "
msg_vocales:    .string "Número de vocales: %d\n"
msg_consonantes: .string "Número de consonantes: %d\n"
buffer:         .skip 100        // Buffer para almacenar la cadena
formato_str:    .string "%[^\n]" // Leer hasta encontrar newline
vocales:        .ascii "aeiouAEIOU"

    .text
    .global main
    .align 2

main:
    // Prólogo
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
    
    // Guardar contadores en el stack
    str     xzr, [sp, 16]       // Contador vocales
    str     xzr, [sp, 24]       // Contador consonantes

    // Mostrar mensaje de ingreso
    adr     x0, msg_ingreso
    bl      printf

    // Leer cadena
    adr     x0, formato_str
    adr     x1, buffer
    bl      scanf

    // Iniciar procesamiento de la cadena
    adr     x0, buffer          // x0 = dirección de la cadena
    mov     x1, #0              // x1 = índice en la cadena

procesar_char:
    ldrb    w2, [x0, x1]       // Cargar carácter
    cbz     w2, fin_conteo      // Si es 0, fin de cadena

    // Verificar si es letra
    cmp     w2, #'A'
    b.lt    siguiente_char
    cmp     w2, #'z'
    b.gt    siguiente_char
    cmp     w2, #'Z'
    b.le    es_letra
    cmp     w2, #'a'
    b.ge    es_letra
    b       siguiente_char

es_letra:
    // Verificar si es vocal
    adr     x3, vocales         // x3 = dirección de vocales
    mov     x4, #0              // x4 = índice en vocales

check_vocal:
    ldrb    w5, [x3, x4]       // Cargar vocal
    cbz     w5, es_consonante   // Si llegamos al final, es consonante
    cmp     w2, w5             // Comparar con vocal actual
    b.eq    es_vocal
    add     x4, x4, #1
    b       check_vocal

es_vocal:
    ldr     x4, [sp, 16]       // Cargar contador de vocales
    add     x4, x4, #1         // Incrementar
    str     x4, [sp, 16]       // Guardar nuevo valor
    b       siguiente_char

es_consonante:
    ldr     x4, [sp, 24]       // Cargar contador de consonantes
    add     x4, x4, #1         // Incrementar
    str     x4, [sp, 24]       // Guardar nuevo valor

siguiente_char:
    add     x1, x1, #1         // Siguiente carácter
    b       procesar_char

fin_conteo:
    // Mostrar resultados
    adr     x0, msg_vocales
    ldr     x1, [sp, 16]
    bl      printf

    adr     x0, msg_consonantes
    ldr     x1, [sp, 24]
    bl      printf

    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 32
    ret

//C#

/*using System;

class Program
{
    static void Main()
    {
        // Mensajes
        string msgIngreso = "Ingrese una cadena: ";
        string msgVocales = "Número de vocales: {0}\n";
        string msgConsonantes = "Número de consonantes: {0}\n";
        
        // Definir vocales
        string vocales = "aeiouAEIOU";

        // Mostrar mensaje de ingreso
        Console.Write(msgIngreso);

        // Leer la cadena del usuario
        string input = Console.ReadLine();

        // Contadores
        int vocalesCount = 0;
        int consonantesCount = 0;

        // Procesar la cadena
        foreach (char c in input)
        {
            // Verificar si el carácter es una letra
            if (Char.IsLetter(c))
            {
                // Verificar si es una vocal
                if (vocales.Contains(c))
                {
                    vocalesCount++;
                }
                else
                {
                    consonantesCount++;
                }
            }
        }

        // Mostrar resultados
        Console.WriteLine(msgVocales, vocalesCount);
        Console.WriteLine(msgConsonantes, consonantesCount);
    }
}
*/
