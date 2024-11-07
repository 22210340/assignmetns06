//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que suma dos matrices 2D
// Suma dos matrices de 3x3 y muestra el resultado
//************************************************

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

    // Mensajes para imprimir
msg_matriz1:    .string "\nMatriz 1:\n"
msg_matriz2:    .string "\nMatriz 2:\n"
msg_resultado:  .string "\nMatriz Resultado:\n"
msg_elemento:   .string "%3d "  // Formato para imprimir cada elemento
msg_newline:    .string "\n"

    .text
    .global main
    .align 2

main:
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

    // Sumar matrices
    bl      sumar_matrices

    // Mostrar resultado
    adr     x0, msg_resultado
    bl      printf
    adr     x0, resultado
    bl      imprimir_matriz

    // Salir
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

// Función para sumar matrices
sumar_matrices:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp

    // Inicializar contadores
    mov     x19, #0              // i = 0
    adr     x20, filas
    ldr     x20, [x20]          // Cargar número de filas
    adr     x21, columnas
    ldr     x21, [x21]          // Cargar número de columnas

bucle_externo:
    cmp     x19, x20            // Comparar i con filas
    b.ge    fin_suma
    mov     x22, #0             // j = 0

bucle_interno:
    cmp     x22, x21            // Comparar j con columnas
    b.ge    siguiente_fila

    // Calcular offset = (i * columnas + j) * 8
    mul     x23, x19, x21       // i * columnas
    add     x23, x23, x22       // + j
    lsl     x23, x23, #3        // * 8 (tamaño de quad)

    // Cargar elementos de ambas matrices
    adr     x24, matriz1
    adr     x25, matriz2
    ldr     x26, [x24, x23]     // elemento matriz1[i][j]
    ldr     x27, [x25, x23]     // elemento matriz2[i][j]

    // Sumar elementos
    add     x28, x26, x27

    // Almacenar resultado
    adr     x24, resultado
    str     x28, [x24, x23]

    // Incrementar j
    add     x22, x22, #1
    b       bucle_interno

siguiente_fila:
    add     x19, x19, #1        // Incrementar i
    b       bucle_externo

fin_suma:
    ldp     x29, x30, [sp], 48
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

/*using System;

class MatrixAddition
{
    static void Main()
    {
        int[,] matriz1 = {
            { 1, 2, 3 },
            { 4, 5, 6 },
            { 7, 8, 9 }
        };

        int[,] matriz2 = {
            { 9, 8, 7 },
            { 6, 5, 4 },
            { 3, 2, 1 }
        };

        int filas = 3, columnas = 3;
        int[,] resultado = new int[filas, columnas];

        Console.WriteLine("\nMatriz 1:");
        ImprimirMatriz(matriz1, filas, columnas);

        Console.WriteLine("\nMatriz 2:");
        ImprimirMatriz(matriz2, filas, columnas);

        SumarMatrices(matriz1, matriz2, resultado, filas, columnas);

        Console.WriteLine("\nMatriz Resultado:");
        ImprimirMatriz(resultado, filas, columnas);
    }

    // Función para sumar dos matrices
    static void SumarMatrices(int[,] matriz1, int[,] matriz2, int[,] resultado, int filas, int columnas)
    {
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                resultado[i, j] = matriz1[i, j] + matriz2[i, j];
            }
        }
    }

    // Función para imprimir una matriz
    static void ImprimirMatriz(int[,] matriz, int filas, int columnas)
    {
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                Console.Write($"{matriz[i, j],3} ");
            }
            Console.WriteLine();
        }
    }
}
*/
