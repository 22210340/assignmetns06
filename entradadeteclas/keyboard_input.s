//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa detecta la lectura de teclas que usa el teclado
// 
//************************************************


.arch armv8-a
    .text
    .align 2
    .global main
    .type main, @function

main:
    // Guardar registros
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Imprimir mensaje pidiendo entrada
    adrp    x0, prompt
    add     x0, x0, :lo12:prompt
    bl      printf

    // Leer entrada del teclado
    adrp    x0, buffer
    add     x0, x0, :lo12:buffer
    mov     x1, #100        // Tamaño máximo a leer
    mov     x2, #0          // stdin
    bl      fgets

    // Verificar si la lectura fue exitosa
    cmp     x0, #0
    b.eq    error_lectura

    // Buscar el salto de línea y reemplazarlo por null
    adrp    x0, buffer
    add     x0, x0, :lo12:buffer
    bl      strlen
    sub     x0, x0, #1      // Restar 1 para obtener la posición del \n
    adrp    x1, buffer
    add     x1, x1, :lo12:buffer
    strb    wzr, [x1, x0]   // Reemplazar \n con \0

    // Imprimir mensaje con la entrada
    adrp    x0, output
    add     x0, x0, :lo12:output
    adrp    x1, buffer
    add     x1, x1, :lo12:buffer
    bl      printf

    // Salir normalmente
    mov     w0, #0
    b       fin

error_lectura:
    // Imprimir mensaje de error
    adrp    x0, error_msg
    add     x0, x0, :lo12:error_msg
    bl      printf
    mov     w0, #1          // Código de error

fin:
    ldp     x29, x30, [sp], 16
    ret

    .section    .rodata
prompt:     .string "Por favor, ingrese un texto: "
output:     .string "Has escrito: %s\n"
error_msg:  .string "Error al leer la entrada\n"

    .section    .bss
    .align  4
buffer:     .skip   100     // Reservar 100 bytes para el buffer


//C#

/*using System;

class Program
{
    static void Main()
    {
        // Solicitar al usuario que ingrese un texto
        Console.Write("Por favor, ingrese un texto: ");

        // Leer la entrada del usuario
        string? input = Console.ReadLine();

        // Verificar si la entrada fue nula o vacía
        if (string.IsNullOrEmpty(input))
        {
            Console.WriteLine("Error al leer la entrada");
            Environment.Exit(1); // Código de error
        }

        // Remover el salto de línea final si existe
        input = input.TrimEnd('\n', '\r');

        // Imprimir el mensaje con la entrada
        Console.WriteLine($"Has escrito: {input}");
    }
}
*/
