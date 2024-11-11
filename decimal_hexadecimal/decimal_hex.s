//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que convierte un número
// decimal a hexadecimal
// VIDEO: https://asciinema.org/a/l00UhczpKVVN9HDl2RmBlnuOX
//************************************************

.data
msg_input: .string "Ingrese un número decimal: "
msg_output: .string "El número en hexadecimal es: %X\n"
formato_int: .string "%d"
numero: .word 0

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Solicitar número decimal
    adr x0, msg_input
    bl printf
    
    // Leer número decimal
    adr x0, formato_int
    adr x1, numero
    bl scanf
    
    // Cargar número en w19
    adr x0, numero
    ldr w19, [x0]
    
    // Mostrar resultado en hexadecimal
    adr x0, msg_output
    mov w1, w19
    bl printf
    
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//c#

/*using System;

class DecimalAHexadecimal
{
    static void Main()
    {
        // Solicitar número decimal
        Console.Write("Ingrese un número decimal: ");
        if (int.TryParse(Console.ReadLine(), out int numero))
        {
            // Convertir y mostrar el resultado en hexadecimal
            Console.WriteLine("El número en hexadecimal es: {0:X}", numero);
        }
        else
        {
            Console.WriteLine("Entrada inválida, por favor ingrese un número entero.");
        }
    }
}
*/
