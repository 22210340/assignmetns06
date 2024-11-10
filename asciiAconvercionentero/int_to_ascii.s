    .data
msg_ingreso:    .string "Ingrese un número entero (0-9): "
msg_resultado:  .string "El carácter ASCII es: %c\n"
formato_int:    .string "%d"     // Formato para leer entero
numero:         .word 0          // Variable para almacenar el número

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

    // Leer número entero
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Convertir entero a ASCII
    adr     x0, numero
    ldr     w0, [x0]            // Cargar el número
    add     w1, w0, #48         // Sumar 48 (ASCII '0') para obtener el carácter

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
        string msgIngreso = "Ingrese un número entero (0-9): ";
        string msgResultado = "El carácter ASCII es: {0}\n";

        // Mostrar mensaje de ingreso
        Console.Write(msgIngreso);

        // Leer número entero ingresado por el usuario
        if (int.TryParse(Console.ReadLine(), out int numero) && numero >= 0 && numero <= 9)
        {
            // Convertir entero a carácter ASCII
            char caracterASCII = (char)(numero + '0');

            // Mostrar resultado
            Console.WriteLine(msgResultado, caracterASCII);
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingrese un número entre 0 y 9.");
        }
    }
}
*/
