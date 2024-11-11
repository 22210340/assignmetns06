//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que convierte un carácter ASCII
// a su valor entero correspondiente
// VIDEO: https://asciinema.org/a/JtHpTZ9UBVj6Ws04usaw3aBtO
//************************************************

    .data
msg_ingreso:    .string "Ingrese un número (0-9): "
msg_resultado:  .string "El valor entero es: %d\n"
formato_char:   .string " %c"    // Espacio antes de %c para ignorar whitespace
buffer:         .skip 2          // Buffer para almacenar el carácter

    .text
    .global main
    .align 2

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Mostrar mensaje de ingreso
    adr     x0, msg_ingreso
    bl      printf

    // Leer carácter
    adr     x0, formato_char
    adr     x1, buffer
    bl      scanf

    // Convertir ASCII a entero
    adr     x0, buffer
    ldrb    w0, [x0]            // Cargar el carácter
    sub     w0, w0, #48         // Restar 48 (ASCII '0') para obtener el valor

    // Mostrar resultado
    mov     w1, w0              // Mover resultado a w1 para printf
    adr     x0, msg_resultado
    bl      printf

    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

//C#

/*using System;

class Program
{
    static void Main()
    {
        // Mensajes
        string msgIngreso = "Ingrese un número (0-9): ";
        string msgResultado = "El valor entero es: {0}\n";

        // Mostrar mensaje de ingreso
        Console.Write(msgIngreso);

        // Leer carácter y convertir a número entero
        char inputChar = Console.ReadKey().KeyChar;
        Console.WriteLine(); // Salto de línea para el resultado

        // Convertir ASCII a entero
        int valorEntero = inputChar - '0';

        // Mostrar resultado
        Console.WriteLine(msgResultado, valorEntero);
    }
}
*/
