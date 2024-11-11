// VIDEO: https://asciinema.org/a/G6UljcGGyYlVyaxki7PuLxb4K

.arch armv8-a
    .text
    .align 2
    .global main
    .type main, @function

main:
    // Guardar enlace de retorno y frame pointer
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Imprimir mensaje para primer número
    adrp    x0, msg_num1
    add     x0, x0, :lo12:msg_num1
    bl      printf

    // Leer primer número
    adrp    x0, formato_int
    add     x0, x0, :lo12:formato_int
    adrp    x1, numero1
    add     x1, x1, :lo12:numero1
    bl      scanf

    // Imprimir mensaje para segundo número
    adrp    x0, msg_num2
    add     x0, x0, :lo12:msg_num2
    bl      printf

    // Leer segundo número
    adrp    x0, formato_int
    add     x0, x0, :lo12:formato_int
    adrp    x1, numero2
    add     x1, x1, :lo12:numero2
    bl      scanf

    // Cargar números
    adrp    x0, numero1
    add     x0, x0, :lo12:numero1
    ldr     w1, [x0]
    adrp    x0, numero2
    add     x0, x0, :lo12:numero2
    ldr     w2, [x0]

    // Realizar suma y verificar overflow
    adds    w3, w1, w2
    b.vs    1f  // Si hay overflow, salta

    // Imprimir resultado sin overflow
    adrp    x0, msg_resultado
    add     x0, x0, :lo12:msg_resultado
    bl      printf
    b       2f

1:  // Caso de overflow
    adrp    x0, msg_overflow
    add     x0, x0, :lo12:msg_overflow
    bl      printf

2:  // Fin del programa
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

    .section    .rodata
msg_num1:       .string "Ingrese el primer número: "
msg_num2:       .string "Ingrese el segundo número: "
msg_resultado:  .string "Resultado: %d + %d = %d\n"
msg_overflow:   .string "¡Se detectó overflow!\n"
formato_int:    .string "%d"
    
    .data
numero1:        .word 0
numero2:        .word 0


//C# 

/*using System;

class SumaConDeteccionDeOverflow
{
    static void Main()
    {
        Console.Write("Ingrese el primer número: ");
        int numero1 = int.Parse(Console.ReadLine());

        Console.Write("Ingrese el segundo número: ");
        int numero2 = int.Parse(Console.ReadLine());

        // Realizar la suma con manejo de overflow
        try
        {
            int resultado = checked(numero1 + numero2); // "checked" para detectar overflow
            Console.WriteLine($"La suma de {numero1} + {numero2} es: {resultado}");
            Console.WriteLine("No hubo desbordamiento en la operación");
        }
        catch (OverflowException)
        {
            Console.WriteLine("¡Advertencia! Se ha detectado desbordamiento");
        }
    }
}
*/
