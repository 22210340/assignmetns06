//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que verifica si un número ingresado por el usuario
// es primo o no. Un número primo es aquel que solo es divisible por 1 y
// por sí mismo. El programa verifica esto probando divisiones desde 2
// hasta la raíz cuadrada del número.
// VIDEO: https://asciinema.org/a/0RYw9zXLVMRkOudRfWjDc2DHf
//************************************************

.data
msg1:    .string "Ingrese un numero para verificar si es primo: "
msgPrimo: .string "El numero %d ES primo\n"
msgNoPrimo: .string "El numero %d NO es primo\n"
msgError: .string "El numero debe ser mayor que 1\n"
fmt:     .string "%d"
numero:  .word 0

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Imprimir mensaje solicitando número
    adr     x0, msg1
    bl      printf

    // Leer número del usuario
    adr     x0, fmt
    adr     x1, numero
    bl      scanf

    // Cargar número en x19
    adr     x19, numero
    ldr     w19, [x19]

    // Verificar si el número es menor o igual a 1
    cmp     w19, #1
    ble     numero_invalido

    // Inicializar divisor en 2
    mov     w20, #2                  // w20 será nuestro divisor

verificar_primo:
    // Calcular w20 * w20 para comparar con el número
    mul     w21, w20, w20
    
    // Si w20 * w20 > número, entonces es primo
    cmp     w21, w19
    bgt     es_primo

    // Verificar si el número es divisible por el divisor actual
    sdiv    w21, w19, w20           // w21 = número / divisor
    mul     w21, w21, w20           // w21 = (número / divisor) * divisor
    
    // Si w21 == número original, entonces es divisible
    cmp     w21, w19
    beq     no_es_primo

    // Incrementar divisor y continuar
    add     w20, w20, #1
    b       verificar_primo

es_primo:
    // Imprimir mensaje de que es primo
    adr     x0, msgPrimo
    mov     w1, w19
    bl      printf
    b       fin

no_es_primo:
    // Imprimir mensaje de que no es primo
    adr     x0, msgNoPrimo
    mov     w1, w19
    bl      printf
    b       fin

numero_invalido:
    // Imprimir mensaje de error
    adr     x0, msgError
    bl      printf

fin:
    // Epílogo
    mov     w0, #0                  // Retornar 0
    ldp     x29, x30, [sp], 16      // Restaurar frame pointer y link register
    ret

//C#

/* using System;

class Program
{
    static void Main()
    {
        try
        {
            // Solicitar al usuario que ingrese un número
            Console.Write("Ingrese un número para verificar si es primo: ");
            int numero = int.Parse(Console.ReadLine());

            // Verificar que el número sea mayor que 1
            if (numero <= 1)
            {
                Console.WriteLine("Error: Debe ingresar un número mayor que 1.");
                return;
            }

            // Determinar si el número es primo
            bool esPrimo = EsPrimo(numero);

            // Mostrar el resultado
            if (esPrimo)
            {
                Console.WriteLine($"El número {numero} es primo.");
            }
            else
            {
                Console.WriteLine($"El número {numero} no es primo.");
            }
        }
        catch (FormatException)
        {
            Console.WriteLine("Error: Entrada no válida. Por favor ingrese un número entero.");
        }
    }

    static bool EsPrimo(int numero)
    {
        // Inicializar el divisor en 2
        int divisor = 2;

        // Iterar hasta la raíz cuadrada del número
        while (divisor * divisor <= numero)
        {
            // Si el número es divisible por el divisor, no es primo
            if (numero % divisor == 0)
            {
                return false;
            }

            divisor++;
        }

        // Si no fue divisible por ningún número, es primo
        return true;
    }
}
*/
