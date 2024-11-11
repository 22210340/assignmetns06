//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que genera la serie de Fibonacci hasta el n-ésimo término
// ingresado por el usuario. La serie de Fibonacci es una secuencia donde cada
// número es la suma de los dos anteriores, comenzando con 0 y 1.
// Ejemplo: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
// VIDEO: https://asciinema.org/a/JBfTbkzuK7XdoQX1aHa8blBNk
//************************************************

.data
msg1:    .string "Ingrese el numero de terminos de Fibonacci a generar (1-47): "
msg2:    .string "Serie de Fibonacci hasta el termino %d:\n"
msg3:    .string "%d, "             // Para imprimir números con coma
msg4:    .string "%d\n"             // Para el último número
fmt:     .string "%d"
numero:  .word 0

.text
.global main

main:
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Imprimir mensaje solicitando número
    adr     x0, msg1
    bl      printf

    // Leer número del usuario
    adr     x0, fmt
    adr     x1, numero
    bl      scanf

    // Imprimir mensaje inicial
    adr     x0, msg2
    adr     x1, numero
    ldr     w1, [x1]
    bl      printf

    // Inicializar variables
    mov     x19, xzr                // x19 = 0 (primer número)
    mov     x20, #1                 // x20 = 1 (segundo número)
    mov     x21, xzr                // x21 = 0 (contador)
    adr     x22, numero
    ldr     w22, [x22]              // x22 = n (número de términos)

fibonacci_loop:
    // Verificar si hemos terminado
    cmp     x21, x22
    bge     end_program

    // Imprimir número actual
    cmp     x21, x22
    beq     print_last              // Si es el último, no imprimir coma

    // Imprimir con coma
    adr     x0, msg3
    mov     x1, x19
    bl      printf

    // Calcular siguiente número
    mov     x23, x20                // Temporal = segundo
    add     x20, x19, x20           // segundo = primero + segundo
    mov     x19, x23                // primero = temporal

    // Incrementar contador
    add     x21, x21, #1
    b       fibonacci_loop

print_last:
    // Imprimir último número sin coma
    adr     x0, msg4
    mov     x1, x19
    bl      printf

end_program:
    // Restaurar y retornar
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

//C#

/* using System;

class Program
{
    static void Main()
    {
        try
        {
            // Solicitar al usuario el número de términos de la serie de Fibonacci
            Console.Write("Ingrese el número de términos de Fibonacci a generar (1-47): ");
            int n = int.Parse(Console.ReadLine());

            // Verificar que el número esté en el rango permitido
            if (n < 1 || n > 47)
            {
                Console.WriteLine("Error: El número debe estar entre 1 y 47.");
                return;
            }

            Console.WriteLine($"Serie de Fibonacci hasta el término {n}:");

            // Inicializar los primeros términos de la serie
            long first = 0, second = 1;

            for (int i = 1; i <= n; i++)
            {
                // Imprimir el término actual, con o sin coma según sea el último
                if (i == n)
                    Console.WriteLine(first);
                else
                    Console.Write($"{first}, ");

                // Calcular el siguiente término de la serie
                long next = first + second;
                first = second;
                second = next;
            }
        }
        catch (FormatException)
        {
            Console.WriteLine("Error: Entrada no válida. Por favor ingrese un número entero.");
        }
    }
}
*/
