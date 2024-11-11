//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que encuentra el valor máximo en un arreglo de números.
// El usuario ingresa la cantidad de números y luego los números uno por uno.
// El programa muestra el arreglo completo y encuentra el valor máximo.
// VIDEO: https://asciinema.org/a/fwHVCTscf5o0E4ujqyQkSQaxE
//************************************************

.data
msg1:       .string "Ingrese la cantidad de números (máximo 20): "
msg2:       .string "Ingrese el número %d: "
msg3:       .string "\nArreglo ingresado: "
msg4:       .string "%d "
msg5:       .string "\nEl valor máximo es: %d\n"
formato:    .string "%d"
array:      .skip 80                // Espacio para 20 números (4 bytes cada uno)
size:       .word 0                 // Tamaño del arreglo

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Solicitar tamaño del arreglo
    adr     x0, msg1
    bl      printf

    // Leer tamaño
    adr     x0, formato
    adr     x1, size
    bl      scanf

    // Verificar que el tamaño sea válido (entre 1 y 20)
    adr     x19, size
    ldr     w19, [x19]              // w19 = tamaño del arreglo
    cmp     w19, #1
    blt     fin                     // Si es menor que 1, terminar
    cmp     w19, #20
    bgt     fin                     // Si es mayor que 20, terminar

    // Inicializar variables
    adr     x20, array              // x20 = dirección base del array
    mov     w21, #0                 // w21 = contador
    str     w21, [x20]              // Inicializar primer elemento

leer_numeros:
    cmp     w21, w19                // Comparar contador con tamaño
    bge     mostrar_array           // Si terminamos de leer, mostrar array

    // Imprimir mensaje para cada número
    adr     x0, msg2
    add     w1, w21, #1             // Número actual + 1 para mostrar
    bl      printf

    // Leer número
    adr     x0, formato
    add     x1, x20, w21, uxtw #2   // Calcular dirección del elemento actual
    bl      scanf

    add     w21, w21, #1            // Incrementar contador
    b       leer_numeros

mostrar_array:
    // Mostrar mensaje inicial
    adr     x0, msg3
    bl      printf

    // Reiniciar contador
    mov     w21, #0

imprimir_array:
    cmp     w21, w19                // Comparar contador con tamaño
    bge     encontrar_maximo        // Si terminamos de imprimir, buscar máximo

    // Imprimir número actual
    adr     x0, msg4
    ldr     w1, [x20, w21, uxtw #2]
    bl      printf

    add     w21, w21, #1            // Incrementar contador
    b       imprimir_array

encontrar_maximo:
    // Inicializar máximo con primer elemento
    ldr     w22, [x20]              // w22 = máximo actual
    mov     w21, #1                 // Empezar desde el segundo elemento

buscar_maximo:
    cmp     w21, w19                // Comparar contador con tamaño
    bge     mostrar_maximo          // Si terminamos, mostrar resultado

    // Cargar elemento actual
    ldr     w23, [x20, w21, uxtw #2]
    
    // Comparar con máximo actual
    cmp     w23, w22
    ble     siguiente               // Si es menor o igual, siguiente
    mov     w22, w23                // Si es mayor, actualizar máximo

siguiente:
    add     w21, w21, #1            // Incrementar contador
    b       buscar_maximo

mostrar_maximo:
    // Mostrar el máximo encontrado
    adr     x0, msg5
    mov     w1, w22
    bl      printf

fin:
    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

    //C# 

    /* using System;

class Program
{
    static void Main()
    {
        // Solicitar tamaño del arreglo
        Console.WriteLine("Ingrese la cantidad de números (máximo 20): ");
        int size = int.Parse(Console.ReadLine());

        // Verificar que el tamaño sea válido (entre 1 y 20)
        if (size < 1 || size > 20)
        {
            Console.WriteLine("El tamaño debe estar entre 1 y 20.");
            return;
        }

        // Inicializar el arreglo
        int[] array = new int[size];

        // Leer los números
        for (int i = 0; i < size; i++)
        {
            Console.WriteLine($"Ingrese el número {i + 1}: ");
            array[i] = int.Parse(Console.ReadLine());
        }

        // Mostrar el arreglo ingresado
        Console.WriteLine("\nArreglo ingresado:");
        for (int i = 0; i < size; i++)
        {
            Console.Write(array[i] + " ");
        }
        Console.WriteLine();

        // Encontrar el valor máximo en el arreglo
        int max = array[0]; // Inicializar el máximo con el primer elemento
        for (int i = 1; i < size; i++)
        {
            if (array[i] > max)
            {
                max = array[i];
            }
        }

        // Mostrar el valor máximo encontrado
        Console.WriteLine($"\nEl valor máximo es: {max}");
    }
}
*/ 
