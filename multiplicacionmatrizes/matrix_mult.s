//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que multiplica dos matrices 2D
// Sistema: Linux ARM64
// Compilación: 
//    as -g matriz_mult.s -o matriz_mult.o
//    gcc matriz_mult.o -o matriz_mult
// Ejecución:
//    ./matriz_mult
//************************************************

    .arch armv8-a              // Especifica la arquitectura ARMv8-A

    .data
    // Primera matriz 3x3
matriz1:    .quad   1, 2, 3
           .quad   4, 5, 6
           .quad   7, 8, 9
    // Segunda matriz 3x3
matriz2:    .quad   9, 8, 7
           .quad   6, 5, 4
           .quad   3, 2, 1
    // Matriz resultado 3x3
resultado:  .zero   72          // 9 elementos * 8 bytes = 72 bytes
    // Dimensiones de las matrices
filas:      .quad   3
columnas:   .quad   3
    // Mensajes para imprimir (formato Linux)
msg_matriz1:    .string "\nMatriz 1:\n"
msg_matriz2:    .string "\nMatriz 2:\n"
msg_resultado:  .string "\nMatriz Resultado:\n"
msg_elemento:   .string "%3ld "  // Formato para long int en Linux
msg_newline:    .string "\n"

    .text
    .global main               // Punto de entrada para Linux
    .type main, %function      // Declara main como función
    .align 2
main:
    // Prólogo de la función - guarda registros según ABI de Linux
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Mostrar matriz 1
    adr     x0, msg_matriz1
    bl      printf
    adr     x0, matriz1
    bl      imprimir_matriz
    
    // Mostrar matriz 2
    adr     x0, msg_matriz2
    bl      printf
    adr     x0, matriz2
    bl      imprimir_matriz
    
    // Multiplicar matrices
    bl      multiplicar_matrices
    
    // Mostrar resultado
    adr     x0, msg_resultado
    bl      printf
    adr     x0, resultado
    bl      imprimir_matriz
    
    // Epílogo y retorno
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

// Función para multiplicar matrices
multiplicar_matrices:
    stp     x29, x30, [sp, -64]!
    mov     x29, sp
    // Inicializar contadores
    mov     x19, #0              // i = 0
    adr     x20, filas
    ldr     x20, [x20]          // Cargar número de filas
    adr     x21, columnas
    ldr     x21, [x21]          // Cargar número de columnas

bucle_i:
    cmp     x19, x20            // Comparar i con filas
    b.ge    fin_multiplicacion
    mov     x22, #0             // j = 0

bucle_j:
    cmp     x22, x21            // Comparar j con columnas
    b.ge    siguiente_i
    mov     x25, #0             // Acumulador para el resultado
    mov     x23, #0             // k = 0

bucle_k:
    cmp     x23, x21            // Comparar k con columnas
    b.ge    guardar_resultado
    
    // Calcular índices
    mul     x24, x19, x21       // i * columnas
    add     x24, x24, x23       // + k
    lsl     x24, x24, #3        // * 8 (tamaño de quad)
    
    mul     x26, x23, x21       // k * columnas
    add     x26, x26, x22       // + j
    lsl     x26, x26, #3        // * 8
    
    // Cargar elementos y multiplicar
    adr     x27, matriz1
    ldr     x27, [x27, x24]     // elemento matriz1[i][k]
    adr     x28, matriz2
    ldr     x28, [x28, x26]     // elemento matriz2[k][j]
    mul     x27, x27, x28       // multiplicar elementos
    add     x25, x25, x27       // acumular resultado
    
    add     x23, x23, #1        // k++
    b       bucle_k

guardar_resultado:
    mul     x24, x19, x21       // i * columnas
    add     x24, x24, x22       // + j
    lsl     x24, x24, #3        // * 8
    
    adr     x27, resultado
    str     x25, [x27, x24]
    
    add     x22, x22, #1        // j++
    b       bucle_j

siguiente_i:
    add     x19, x19, #1        // i++
    b       bucle_i

fin_multiplicacion:
    ldp     x29, x30, [sp], 64
    ret

// Función para imprimir matriz
imprimir_matriz:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp
    str     x0, [sp, 16]        // Guardar dirección de la matriz
    mov     x19, #0             // i = 0
    adr     x20, filas
    ldr     x20, [x20]          // Cargar número de filas
    adr     x21, columnas
    ldr     x21, [x21]          // Cargar número de columnas

bucle_imprimir_ext:
    cmp     x19, x20
    b.ge    fin_imprimir
    mov     x22, #0             // j = 0

bucle_imprimir_int:
    cmp     x22, x21
    b.ge    nueva_linea
    // Calcular offset
    mul     x23, x19, x21
    add     x23, x23, x22
    lsl     x23, x23, #3
    // Imprimir elemento
    adr     x0, msg_elemento
    ldr     x24, [sp, 16]
    ldr     x1, [x24, x23]
    bl      printf
    add     x22, x22, #1
    b       bucle_imprimir_int

nueva_linea:
    adr     x0, msg_newline
    bl      printf
    add     x19, x19, #1
    b       bucle_imprimir_ext

fin_imprimir:
    ldp     x29, x30, [sp], 48
    ret

//C#

/*
using System;

class MatrixMultiplication
{
    static void Main()
    {
        int[,] matrix1 = {
            { 1, 2, 3 },
            { 4, 5, 6 },
            { 7, 8, 9 }
        };

        int[,] matrix2 = {
            { 9, 8, 7 },
            { 6, 5, 4 },
            { 3, 2, 1 }
        };

        int N = 3;
        int[,] result = new int[N, N];

        // Realizar la multiplicación de matrices
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N; j++)
            {
                int sum = 0;
                for (int k = 0; k < N; k++)
                {
                    sum += matrix1[i, k] * matrix2[k, j];
                }
                result[i, j] = sum;
            }
        }

        // Imprimir el resultado
        Console.WriteLine("\nMatriz Resultado:");
        ImprimirMatriz(result, N);
    }

    // Función para imprimir una matriz
    static void ImprimirMatriz(int[,] matriz, int N)
    {
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N; j++)
            {
                Console.Write($"{matriz[i, j],4}");
            }
            Console.WriteLine();
        }
    }
}
*/
