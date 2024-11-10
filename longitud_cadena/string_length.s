//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que calcula la longitud de
// una cadena ingresada por el usuario
//************************************************

    .data
msg_ingreso:    .string "Ingrese una cadena: "
msg_resultado:  .string "La longitud de la cadena es: %d\n"
buffer:         .skip 100        // Buffer para almacenar la cadena
formato_str:    .string "%[^\n]" // Leer hasta encontrar newline

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

    // Leer cadena
    adr     x0, formato_str
    adr     x1, buffer
    bl      scanf

    // Calcular longitud
    adr     x0, buffer
    mov     x1, #0              // Contador de caracteres

contar_loop:
    ldrb    w2, [x0, x1]       // Cargar carácter
    cbz     w2, fin_conteo      // Si es 0, fin de cadena
    add     x1, x1, #1         // Incrementar contador
    b       contar_loop

fin_conteo:
    // Mostrar resultado
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
        string msgIngreso = "Ingrese una cadena: ";
        string msgResultado = "La longitud de la cadena es: {0}\n";

        // Mostrar mensaje de ingreso
        Console.Write(msgIngreso);

        // Leer cadena ingresada por el usuario
        string input = Console.ReadLine();

        // Calcular longitud de la cadena
        int longitud = input.Length;

        // Mostrar resultado
        Console.WriteLine(msgResultado, longitud);
    }
}
*/
