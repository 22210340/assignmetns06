//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que calcula la potencia de
// un número (x^n) usando multiplicaciones sucesivas
VIDEO: https://asciinema.org/a/kctY4J401HcnX0UArjGNyLRhQ
//************************************************

    .data
msg_base:       .string "Ingrese la base (x): "
msg_exp:        .string "Ingrese el exponente (n): "
msg_resultado:  .string "El resultado de %d^%d es: %d\n"
msg_error:      .string "Error: exponente negativo no soportado\n"
formato_int:    .string "%d"

base:           .word 0
exponente:      .word 0

    .text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Solicitar base
    adr     x0, msg_base
    bl      printf

    adr     x0, formato_int
    adr     x1, base
    bl      scanf

    // Solicitar exponente
    adr     x0, msg_exp
    bl      printf

    adr     x0, formato_int
    adr     x1, exponente
    bl      scanf

    // Cargar valores
    adr     x0, base
    ldr     w19, [x0]        // Base en w19
    adr     x0, exponente
    ldr     w20, [x0]        // Exponente en w20

    // Verificar si exponente es negativo
    cmp     w20, #0
    b.lt    error_exp

    // Caso especial: exponente = 0
    cmp     w20, #0
    b.eq    exp_cero

    // Calcular potencia
    mov     w21, w19         // Resultado inicial = base
    mov     w22, #1          // Contador

potencia_loop:
    cmp     w22, w20
    b.eq    mostrar_resultado
    mul     w21, w21, w19
    add     w22, w22, #1
    b       potencia_loop

exp_cero:
    mov     w21, #1
    b       mostrar_resultado

error_exp:
    adr     x0, msg_error
    bl      printf
    b       fin_programa

mostrar_resultado:
    adr     x0, msg_resultado
    mov     w1, w19          // Base
    mov     w2, w20          // Exponente
    mov     w3, w21          // Resultado
    bl      printf

fin_programa:
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

//c#

/*using System;

class Program
{
    static void Main()
    {
        // Solicitar base y exponente
        Console.Write("Ingrese la base (x): ");
        int baseNum = int.Parse(Console.ReadLine());

        Console.Write("Ingrese el exponente (n): ");
        int exponent = int.Parse(Console.ReadLine());

        // Verificar si el exponente es negativo
        if (exponent < 0)
        {
            Console.WriteLine("Error: exponente negativo no soportado");
            return;
        }

        // Caso especial: exponente = 0
        if (exponent == 0)
        {
            Console.WriteLine($"El resultado de {baseNum}^{exponent} es: 1");
            return;
        }

        // Calcular la potencia
        int result = 1;
        for (int i = 1; i <= exponent; i++)
        {
            result *= baseNum;
        }

        // Mostrar el resultado
        Console.WriteLine($"El resultado de {baseNum}^{exponent} es: {result}");
    }
}
*/
