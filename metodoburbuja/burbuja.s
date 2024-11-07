//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Implementación del algoritmo de ordenamiento burbuja
// El programa ordena un arreglo de números enteros de menor a mayor
// usando el método de burbuja
//************************************************

    .data
array:      .quad   64, 34, 25, 12, 22, 11, 90, 45    // Array desordenado inicial
size:       .quad   8                                  // Tamaño del array
msg_before: .string "Array antes del ordenamiento:\n"
msg_after:  .string "Array después del ordenamiento:\n"
msg_format: .string "%d "                             // Formato para imprimir números
msg_newline:.string "\n"

    .text
    .global main
    .align 2

main:
    // Guardar registros
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_before
    bl      printf

    // Imprimir array inicial
    bl      print_array

    // Realizar ordenamiento burbuja
    bl      bubble_sort

    // Imprimir mensaje final
    adr     x0, msg_after
    bl      printf

    // Imprimir array ordenado
    bl      print_array

    // Restaurar y salir
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

bubble_sort:
    stp     x29, x30, [sp, -32]!    // Guardar registros
    mov     x29, sp
    
    adr     x8, size                // Cargar dirección de size
    ldr     x9, [x8]                // Cargar tamaño del array
    sub     x9, x9, #1              // size - 1 para el bucle externo
    mov     x10, #0                 // i = 0 (contador bucle externo)

outer_loop:
    cmp     x10, x9                 // Comparar i con size-1
    b.ge    sort_done               // Si i >= size-1, terminar
    
    mov     x11, #0                 // j = 0 (contador bucle interno)
    sub     x12, x9, x10           // size-1-i para límite bucle interno

inner_loop:
    cmp     x11, x12               // Comparar j con size-1-i
    b.ge    outer_next             // Si j >= size-1-i, siguiente iteración externa
    
    // Cargar elementos a comparar
    adr     x13, array
    ldr     x14, [x13, x11, lsl #3]    // array[j]
    add     x15, x11, #1
    ldr     x16, [x13, x15, lsl #3]    // array[j+1]
    
    // Comparar elementos
    cmp     x14, x16
    b.le    inner_next             // Si array[j] <= array[j+1], no intercambiar
    
    // Intercambiar elementos
    str     x16, [x13, x11, lsl #3]
    str     x14, [x13, x15, lsl #3]

inner_next:
    add     x11, x11, #1           // j++
    b       inner_loop

outer_next:
    add     x10, x10, #1           // i++
    b       outer_loop

sort_done:
    ldp     x29, x30, [sp], 32     // Restaurar registros
    ret

print_array:
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
    
    mov     x19, #0                // Contador
    adr     x20, size              // Cargar dirección de size
    ldr     x20, [x20]             // Cargar tamaño del array

print_loop:
    cmp     x19, x20
    b.ge    print_done
    
    // Imprimir elemento actual
    adr     x0, msg_format
    adr     x2, array
    ldr     x1, [x2, x19, lsl #3]
    bl      printf
    
    add     x19, x19, #1
    b       print_loop

print_done:
    // Imprimir nueva línea
    adr     x0, msg_newline
    bl      printf
    
    ldp     x29, x30, [sp], 32
    ret

//c#

/*using System;

class Program
{
    static void Main()
    {
        // Array desordenado inicial
        int[] array = { 64, 34, 25, 12, 22, 11, 90, 45 };
        int size = array.Length;

        Console.WriteLine("Array antes del ordenamiento:");
        PrintArray(array);

        // Realizar el ordenamiento burbuja
        BubbleSort(array);

        Console.WriteLine("Array después del ordenamiento:");
        PrintArray(array);
    }

    static void BubbleSort(int[] array)
    {
        int n = array.Length;
        for (int i = 0; i < n - 1; i++)
        {
            for (int j = 0; j < n - i - 1; j++)
            {
                if (array[j] > array[j + 1])
                {
                    // Intercambiar elementos
                    int temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                }
            }
        }
    }

    static void PrintArray(int[] array)
    {
        foreach (int item in array)
        {
            Console.Write($"{item} ");
        }
        Console.WriteLine();
    }
}
*/
