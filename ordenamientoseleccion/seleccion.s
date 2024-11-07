//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Implementación del algoritmo de ordenamiento por selección
// El programa encuentra el elemento más pequeño del arreglo y lo 
// intercambia con el primer elemento, luego encuentra el segundo
// más pequeño y lo intercambia con el segundo elemento, y así sucesivamente
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

    // Realizar ordenamiento por selección
    bl      selection_sort

    // Imprimir mensaje final
    adr     x0, msg_after
    bl      printf

    // Imprimir array ordenado
    bl      print_array

    // Restaurar y salir
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

selection_sort:
    stp     x29, x30, [sp, -32]!    // Guardar registros
    mov     x29, sp
    
    adr     x8, size                // Cargar dirección de size
    ldr     x9, [x8]                // Cargar tamaño del array
    sub     x9, x9, #1              // size - 1 para el bucle externo
    mov     x10, #0                 // i = 0 (contador bucle externo)

outer_loop:
    cmp     x10, x9                 // Comparar i con size-1
    b.ge    sort_done               // Si i >= size-1, terminar
    
    mov     x11, x10                // min_idx = i
    add     x12, x10, #1            // j = i + 1

inner_loop:
    adr     x13, size
    ldr     x13, [x13]              // Cargar tamaño para comparación
    cmp     x12, x13                // Comparar j con size
    b.ge    do_swap                 // Si j >= size, hacer swap
    
    // Cargar elementos a comparar
    adr     x13, array
    ldr     x14, [x13, x12, lsl #3]    // array[j]
    ldr     x15, [x13, x11, lsl #3]    // array[min_idx]
    
    // Comparar elementos
    cmp     x14, x15
    b.ge    inner_next              // Si array[j] >= array[min_idx], siguiente
    
    // Actualizar min_idx
    mov     x11, x12

inner_next:
    add     x12, x12, #1            // j++
    b       inner_loop

do_swap:
    // Realizar intercambio si min_idx != i
    cmp     x11, x10
    b.eq    outer_next
    
    // Cargar elementos para intercambio
    adr     x13, array
    ldr     x14, [x13, x10, lsl #3]    // temp = array[i]
    ldr     x15, [x13, x11, lsl #3]    // array[min_idx]
    
    // Intercambiar elementos
    str     x15, [x13, x10, lsl #3]
    str     x14, [x13, x11, lsl #3]

outer_next:
    add     x10, x10, #1            // i++
    b       outer_loop

sort_done:
    ldp     x29, x30, [sp], 32      // Restaurar registros
    ret

print_array:
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
    
    mov     x19, #0                 // Contador
    adr     x20, size               // Cargar dirección de size
    ldr     x20, [x20]              // Cargar tamaño del array

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

//C#

/*using System;

class Program
{
    static void Main()
    {
        // Array desordenado inicial
        int[] array = { 64, 34, 25, 12, 22, 11, 90, 45 };
        
        Console.WriteLine("Array antes del ordenamiento:");
        PrintArray(array);

        // Realizar el ordenamiento por selección
        SelectionSort(array);

        Console.WriteLine("Array después del ordenamiento:");
        PrintArray(array);
    }

    static void SelectionSort(int[] array)
    {
        int n = array.Length;
        
        for (int i = 0; i < n - 1; i++)
        {
            int minIdx = i; // Índice del valor mínimo
            for (int j = i + 1; j < n; j++)
            {
                if (array[j] < array[minIdx])
                {
                    minIdx = j; // Actualizar índice del mínimo
                }
            }

            // Intercambiar array[minIdx] y array[i] si minIdx ha cambiado
            if (minIdx != i)
            {
                int temp = array[i];
                array[i] = array[minIdx];
                array[minIdx] = temp;
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
