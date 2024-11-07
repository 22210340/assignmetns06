//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Implementación de búsqueda binaria en ARM64
// El programa busca un número en un arreglo ordenado
// dividiendo repetidamente el espacio de búsqueda a la mitad
//************************************************

    .data
array:  .quad   1, 3, 5, 7, 9, 11, 13, 15, 17, 19    // Array ordenado de números
size:   .quad   10                                    // Tamaño del array
target: .quad   11                                    // Número a buscar
msg_found:    .string "Elemento encontrado en el índice: %d\n"
msg_not_found:.string "Elemento no encontrado\n"

    .text
    .global main
    .align 2

main:
    // Guardar registros
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Inicializar parámetros
    adr     x0, array                        // Cargar dirección base del array
    mov     x1, 0                            // left = 0
    adr     x4, size                         // Cargar dirección de size
    ldr     x2, [x4]                         // right = size - 1
    sub     x2, x2, 1
    adr     x4, target                       // Cargar dirección de target
    ldr     x3, [x4]                         // Valor a buscar

binary_search:
    // Verificar si left > right
    cmp     x1, x2
    b.gt    not_found

    // Calcular mid = (left + right) / 2
    add     x4, x1, x2                       // x4 = left + right
    lsr     x4, x4, 1                        // x4 = (left + right) / 2

    // Cargar array[mid]
    ldr     x5, [x0, x4, lsl 3]             // x5 = array[mid]

    // Comparar array[mid] con target
    cmp     x5, x3
    b.eq    found                            // Si son iguales, elemento encontrado
    b.gt    search_left                      // Si array[mid] > target, buscar en mitad izquierda
    b.lt    search_right                     // Si array[mid] < target, buscar en mitad derecha

search_left:
    sub     x2, x4, 1                        // right = mid - 1
    b       binary_search

search_right:
    add     x1, x4, 1                        // left = mid + 1
    b       binary_search

found:
    // Imprimir mensaje de éxito
    adr     x0, msg_found
    mov     x1, x4                           // Índice donde se encontró
    bl      printf
    b       exit

not_found:
    // Imprimir mensaje de no encontrado
    adr     x0, msg_not_found
    bl      printf

exit:
    // Restaurar registros y retornar
    ldp     x29, x30, [sp], 16
    mov     w0, 0                            // Código de retorno 0
    ret


//C#

/*using System;

class Program
{
    static void Main()
    {
        // Array ordenado de números
        long[] array = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
        int size = array.Length;
        long target = 11; // Número a buscar

        int index = BinarySearch(array, target, 0, size - 1);

        if (index != -1)
        {
            Console.WriteLine($"Elemento encontrado en el índice: {index}");
        }
        else
        {
            Console.WriteLine("Elemento no encontrado");
        }
    }

    static int BinarySearch(long[] array, long target, int left, int right)
    {
        while (left <= right)
        {
            int mid = (left + right) / 2;

            if (array[mid] == target)
            {
                return mid; // Elemento encontrado
            }
            else if (array[mid] > target)
            {
                right = mid - 1; // Buscar en mitad izquierda
            }
            else
            {
                left = mid + 1; // Buscar en mitad derecha
            }
        }

        return -1; // Elemento no encontrado
    }
}
*/
