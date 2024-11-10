//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que cuenta el número de bits
// activados (1's) en un número
//************************************************

    .data
msg_ingreso:    .string "Ingrese un número: "
msg_resultado:  .string "Número de bits activados: %d\n"
msg_binario:    .string "Representación binaria: "
msg_bit:        .string "%d"
msg_newline:    .string "\n"
formato_int:    .string "%d"

numero:         .word 0

    .text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Solicitar número
    adr     x0, msg_ingreso
    bl      printf

    // Leer número
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Cargar número
    adr     x0, numero
    ldr     w1, [x0]
    mov     w19, w1          // Guardar copia para mostrar binario

    // Contador de bits
    mov     w2, #0          // Inicializar contador

contar_loop:
    cbz     w1, fin_conteo  // Si el número es 0, terminar
    and     w3, w1, #1      // Obtener bit menos significativo
    add     w2, w2, w3      // Sumar al contador si es 1
    lsr     w1, w1, #1      // Desplazar a la derecha
    b       contar_loop

fin_conteo:
    // Mostrar resultado
    mov     w1, w2
    adr     x0, msg_resultado
    bl      printf

    // Mostrar representación binaria
    adr     x0, msg_binario
    bl      printf

    mov     w20, #32
mostrar_bits:
    sub     w20, w20, #1
    lsr     w21, w19, w20
    and     w1, w21, #1
    adr     x0, msg_bit
    bl      printf

    cmp     w20, #0
    b.ne    mostrar_bits

    adr     x0, msg_newline
    bl      printf

    // Retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

//C#

/*using System;

class Program
{
    static void Main()
    {
        int numero;

        // Solicitar número
        Console.Write("Ingrese un número: ");
        numero = int.Parse(Console.ReadLine());

        // Contar bits activados (1)
        int contador = ContarBitsActivados(numero);

        // Mostrar resultado
        Console.WriteLine($"Número de bits activados: {contador}");

        // Mostrar representación binaria
        Console.Write("Representación binaria: ");
        MostrarEnBinario(numero);
    }

    static int ContarBitsActivados(int numero)
    {
        int contador = 0;
        
        while (numero != 0)
        {
            // Obtener el bit menos significativo
            contador += numero & 1;
            // Desplazar el número a la derecha
            numero >>= 1;
        }

        return contador;
    }

    static void MostrarEnBinario(int numero)
    {
        // Mostrar cada bit en la representación binaria de 32 bits
        for (int i = 31; i >= 0; i--)
        {
            int bit = (numero >> i) & 1; // Obtener el bit correspondiente
            Console.Write(bit);
        }
        Console.WriteLine();
    }
}
*/
