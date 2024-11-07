//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Implementación del algoritmo de ordenamiento por mezcla
// El programa divide recursivamente el array en mitades, ordena cada mitad
// y luego combina (merge) las mitades ordenadas
//************************************************

    .data
array:      .quad   64, 34, 25, 12, 22, 11, 90, 45    // Array desordenado inicial
size:       .quad   8                                  // Tamaño del array
temp_array: .zero   64                                // Array temporal para mezcla (8 elementos * 8 bytes)
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

    // Preparar parámetros para merge sort
    adr     x0, array              // Dirección del array
    mov     x1, #0                 // left = 0
    adr     x2, size
    ldr     x2, [x2]               // right = size
    sub     x2, x2, #1             // right = size - 1
    
    // Llamar a merge sort
    bl      merge_sort

    // Imprimir mensaje final
    adr     x0, msg_after
    bl      printf

    // Imprimir array ordenado
    bl      print_array

    // Restaurar y salir
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

// merge_sort(array, left, right)
merge_sort:
    stp     x29, x30, [sp, -48]!   // Guardar registros y hacer espacio para variables locales
    mov     x29, sp
    
    // Guardar parámetros
    str     x0, [sp, 16]           // array
    str     x1, [sp, 24]           // left
    str     x2, [sp, 32]           // right
    
    // Verificar si left < right
    cmp     x1, x2
    b.ge    merge_sort_end
    
    // Calcular mid = (left + right) / 2
    add     x3, x1, x2             // x3 = left + right
    lsr     x3, x3, #1             // x3 = (left + right) / 2
    str     x3, [sp, 40]           // Guardar mid
    
    // Llamada recursiva para primera mitad
    // merge_sort(array, left, mid)
    ldr     x0, [sp, 16]           // array
    ldr     x1, [sp, 24]           // left
    ldr     x2, [sp, 40]           // mid
    bl      merge_sort
    
    // Llamada recursiva para segunda mitad
    // merge_sort(array, mid + 1, right)
    ldr     x0, [sp, 16]           // array
    ldr     x1, [sp, 40]           // mid
    add     x1, x1, #1             // mid + 1
    ldr     x2, [sp, 32]           // right
    bl      merge_sort
    
    // Mezclar las mitades ordenadas
    ldr     x0, [sp, 16]           // array
    ldr     x1, [sp, 24]           // left
    ldr     x2, [sp, 40]           // mid
    ldr     x3, [sp, 32]           // right
    bl      merge

merge_sort_end:
    ldp     x29, x30, [sp], 48
    ret

// merge(array, left, mid, right)
merge:
    stp     x29, x30, [sp, -64]!
    mov     x29, sp
    
    // Guardar parámetros
    str     x0, [sp, 16]           // array
    str     x1, [sp, 24]           // left
    str     x2, [sp, 32]           // mid
    str     x3, [sp, 40]           // right
    
    mov     x9, x1                 // i = left
    add     x10, x2, #1            // j = mid + 1
    mov     x11, x1                // k = left
    
merge_loop:
    ldr     x1, [sp, 24]           // Cargar left
    ldr     x2, [sp, 32]           // Cargar mid
    ldr     x3, [sp, 40]           // Cargar right
    
    cmp     x9, x2                 // if i > mid
    b.gt    copy_remaining_right
    cmp     x10, x3                // if j > right
    b.gt    copy_remaining_left
    
    // Comparar elementos
    ldr     x0, [sp, 16]           // Cargar dirección del array
    ldr     x12, [x0, x9, lsl #3]  // array[i]
    ldr     x13, [x0, x10, lsl #3] // array[j]
    
    cmp     x12, x13
    b.gt    copy_right
    
copy_left:
    adr     x14, temp_array
    str     x12, [x14, x11, lsl #3]
    add     x9, x9, #1
    b       next_iter

copy_right:
    adr     x14, temp_array
    str     x13, [x14, x11, lsl #3]
    add     x10, x10, #1
    
next_iter:
    add     x11, x11, #1
    b       merge_loop

copy_remaining_left:
    cmp     x9, x2                 // if i > mid
    b.gt    copy_back
    ldr     x0, [sp, 16]           // Cargar dirección del array
    ldr     x12, [x0, x9, lsl #3]  // array[i]
    adr     x14, temp_array
    str     x12, [x14, x11, lsl #3]
    add     x9, x9, #1
    add     x11, x11, #1
    b       copy_remaining_left

copy_remaining_right:
    cmp     x10, x3                // if j > right
    b.gt    copy_back
    ldr     x0, [sp, 16]           // Cargar dirección del array
    ldr     x13, [x0, x10, lsl #3] // array[j]
    adr     x14, temp_array
    str     x13, [x14, x11, lsl #3]
    add     x10, x10, #1
    add     x11, x11, #1
    b       copy_remaining_right

copy_back:
    ldr     x1, [sp, 24]           // Cargar left
    ldr     x2, [sp, 40]           // Cargar right
    mov     x9, x1                 // i = left

copy_back_loop:
    cmp     x9, x2
    b.gt    merge_end
    adr     x14, temp_array
    ldr     x12, [x14, x9, lsl #3]
    ldr     x0, [sp, 16]           // Cargar dirección del array
    str     x12, [x0, x9, lsl #3]
    add     x9, x9, #1
    b       copy_back_loop

merge_end:
    ldp     x29, x30, [sp], 64
    ret

print_array:
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
    
    mov     x19, #0                // Contador
    adr     x20, size
    ldr     x20, [x20]             // Tamaño del array

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
    adr     x0, msg_newline
    bl      printf
    
    ldp     x29, x30, [sp], 32
    ret
//C#

/*using System;

class MergeSortExample
{
    static void Main()
    {
        int[] array = { 64, 34, 25, 12, 22, 11, 90, 45 };
        
        Console.WriteLine("Array antes del ordenamiento:");
        PrintArray(array);

        MergeSort(array, 0, array.Length - 1);
        
        Console.WriteLine("Array después del ordenamiento:");
        PrintArray(array);
    }

    // Función principal de Merge Sort
    static void MergeSort(int[] array, int left, int right)
    {
        if (left < right)
        {
            int mid = (left + right) / 2;

            // Ordenar la primera y segunda mitad recursivamente
            MergeSort(array, left, mid);
            MergeSort(array, mid + 1, right);

            // Mezclar las mitades ordenadas
            Merge(array, left, mid, right);
        }
    }

    // Función para mezclar dos mitades ordenadas
    static void Merge(int[] array, int left, int mid, int right)
    {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        // Crear arreglos temporales para ambas mitades
        int[] leftArray = new int[n1];
        int[] rightArray = new int[n2];

        // Copiar datos a los arreglos temporales
        for (int i = 0; i < n1; i++)
            leftArray[i] = array[left + i];
        for (int j = 0; j < n2; j++)
            rightArray[j] = array[mid + 1 + j];

        // Índices iniciales para mezclar los arreglos
        int iIndex = 0, jIndex = 0, kIndex = left;

        // Mezclar los arreglos temporales de vuelta en el array principal
        while (iIndex < n1 && jIndex < n2)
        {
            if (leftArray[iIndex] <= rightArray[jIndex])
            {
                array[kIndex] = leftArray[iIndex];
                iIndex++;
            }
            else
            {
                array[kIndex] = rightArray[jIndex];
                jIndex++;
            }
            kIndex++;
        }

        // Copiar los elementos restantes de leftArray, si los hay
        while (iIndex < n1)
        {
            array[kIndex] = leftArray[iIndex];
            iIndex++;
            kIndex++;
        }

        // Copiar los elementos restantes de rightArray, si los hay
        while (jIndex < n2)
        {
            array[kIndex] = rightArray[jIndex];
            jIndex++;
            kIndex++;
        }
    }

    // Función para imprimir el array
    static void PrintArray(int[] array)
    {
        foreach (int value in array)
            Console.Write(value + " ");
        Console.WriteLine();
    }
}
*/
