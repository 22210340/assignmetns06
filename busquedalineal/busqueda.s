//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que realiza una búsqueda lineal en un arreglo.
// El usuario ingresa los números del arreglo y luego un número a buscar.
// El programa muestra si el número fue encontrado y en qué posición.
// VIDEO: https://asciinema.org/a/amJBhToyB87bUn3PtliAwHxd5
//************************************************

.data
msg1:       .string "Ingrese la cantidad de números (máximo 20): "
msg2:       .string "Ingrese el número %d: "
msg3:       .string "\nArreglo ingresado: "
msg4:       .string "%d "
msg5:       .string "\nIngrese el número a buscar: "
msgFound:   .string "\nEl número %d fue encontrado en la posición %d\n"
msgNotFound: .string "\nEl número %d no fue encontrado en el arreglo\n"
formato:    .string "%d"
array:      .skip 80                // Espacio para 20 números (4 bytes cada uno)
size:       .word 0                 // Tamaño del arreglo
buscar:     .word 0                 // Número a buscar

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
    bge     pedir_busqueda          // Si terminamos de imprimir, pedir número a buscar

    // Imprimir número actual
    adr     x0, msg4
    ldr     w1, [x20, w21, uxtw #2]
    bl      printf

    add     w21, w21, #1            // Incrementar contador
    b       imprimir_array

pedir_busqueda:
    // Solicitar número a buscar
    adr     x0, msg5
    bl      printf

    // Leer número a buscar
    adr     x0, formato
    adr     x1, buscar
    bl      scanf

    // Iniciar búsqueda
    mov     w21, #0                 // Reiniciar contador
    adr     x22, buscar
    ldr     w22, [x22]              // w22 = número a buscar

busqueda_lineal:
    cmp     w21, w19                // Comparar contador con tamaño
    bge     no_encontrado           // Si llegamos al final, no se encontró

    // Cargar elemento actual
    ldr     w23, [x20, w21, uxtw #2]
    
    // Comparar con número buscado
    cmp     w23, w22
    beq     encontrado              // Si son iguales, encontramos el número

    add     w21, w21, #1            // Incrementar contador
    b       busqueda_lineal

encontrado:
    // Mostrar mensaje de éxito
    adr     x0, msgFound
    mov     w1, w22                 // Número buscado
    add     w2, w21, #1             // Posición (añadir 1 para mostrar desde 1)
    bl      printf
    b       fin

no_encontrado:
    // Mostrar mensaje de no encontrado
    adr     x0, msgNotFound
    mov     w1, w22                 // Número buscado
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

        // Leer los números en el arreglo
        for (int i = 0; i < size; i++)
        {
            Console.WriteLine($"Ingrese el número {i + 1}: ");
            array[i] = int.Parse(Console.ReadLine());
        }

        // Mostrar el arreglo ingresado
        Console.WriteLine("\nArreglo ingresado:");
        foreach (int num in array)
        {
            Console.Write(num + " ");
        }
        Console.WriteLine();

        // Solicitar número a buscar
        Console.WriteLine("\nIngrese el número a buscar: ");
        int buscar = int.Parse(Console.ReadLine());

        // Buscar el número en el arreglo
        int position = -1; // -1 indica que no se ha encontrado

        for (int i = 0; i < size; i++)
        {
            if (array[i] == buscar)
            {
                position = i; // Encontrado en la posición i
                break;
            }
        }

        // Mostrar el resultado de la búsqueda
        if (position >= 0)
        {
            Console.WriteLine($"\nEl número {buscar} fue encontrado en la posición {position + 1}");
        }
        else
        {
            Console.WriteLine($"\nEl número {buscar} no fue encontrado en el arreglo");
        }
    }
}
*/
