//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que transpone una matriz 2D
// Toma una matriz 3x3 y crea su transpuesta
//************************************************

    .data
    // Matriz original 3x3
matriz:     .quad   1, 2, 3
           .quad   4, 5, 6
           .quad   7, 8, 9

    // Matriz resultado para la transpuesta
transpuesta: .zero   72          // 9 elementos * 8 bytes = 72 bytes

    // Dimensiones de la matriz
filas:      .quad   3
columnas:   .quad   3

    // Mensajes para imprimir
msg_original:    .string "\nMatriz Original:\n"
msg_transpuesta: .string "\nMatriz Transpuesta:\n"
msg_elemento:    .string "%3d "
msg_newline:     .string "\n"

    .text
    .global main
    .align 2
main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Mostrar matriz original
    adr     x0, msg_original
    bl      printf
    adr     x0, matriz
    bl      imprimir_matriz

    // Transponer matriz
    bl      transponer_matriz

    // Mostrar matriz transpuesta
    adr     x0, msg_transpuesta
    bl      printf
    adr     x0, transpuesta
    bl      imprimir_matriz

    // Salir
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

// Función para transponer matriz
transponer_matriz:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp

    // Inicializar contadores
    mov     x19, #0              // i = 0
    adr     x20, filas
    ldr     x20, [x20]          // Cargar número de filas
    adr     x21, columnas
    ldr     x21, [x21]          // Cargar número de columnas

bucle_externo_t:
    cmp     x19, x20            // Comparar i con filas
    b.ge    fin_transponer
    mov     x22, #0             // j = 0

bucle_interno_t:
    cmp     x22, x21            // Comparar j con columnas
    b.ge    siguiente_fila_t

    // Calcular offset origen = (i * columnas + j) * 8
    mul     x23, x19, x21       // i * columnas
    add     x23, x23, x22       // + j
    lsl     x23, x23, #3        // * 8 (tamaño de quad)

    // Calcular offset destino = (j * filas + i) * 8
    mul     x24, x22, x20       // j * filas
    add     x24, x24, x19       // + i
    lsl     x24, x24, #3        // * 8

    // Cargar elemento de matriz original
    adr     x25, matriz
    ldr     x26, [x25, x23]     // elemento matriz[i][j]

    // Almacenar en posición transpuesta
    adr     x25, transpuesta
    str     x26, [x25, x24]     // transpuesta[j][i] = matriz[i][j]

    // Incrementar j
    add     x22, x22, #1
    b       bucle_interno_t

siguiente_fila_t:
    add     x19, x19, #1        // Incrementar i
    b       bucle_externo_t

fin_transponer:
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
/*
using System;

class MatrixTranspose
{
    static void Main()
    {
        // Matriz original 3x3
        long[,] matriz = {
            { 1, 2, 3 },
            { 4, 5, 6 },
            { 7, 8, 9 }
        };

        // Matriz para almacenar la transpuesta
        long[,] transpuesta = new long[3, 3];

        // Imprimir la matriz original
        Console.WriteLine("\nMatriz Original:");
        ImprimirMatriz(matriz);

        // Transponer la matriz
        TransponerMatriz(matriz, transpuesta);

        // Imprimir la matriz transpuesta
        Console.WriteLine("\nMatriz Transpuesta:");
        ImprimirMatriz(transpuesta);
    }

    // Función para transponer una matriz
    static void TransponerMatriz(long[,] matriz, long[,] transpuesta)
    {
        int filas = matriz.GetLength(0);
        int columnas = matriz.GetLength(1);

        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                transpuesta[j, i] = matriz[i, j];
            }
        }
    }

    // Función para imprimir una matriz
    static void ImprimirMatriz(long[,] matriz)
    {
        int filas = matriz.GetLength(0);
        int columnas = matriz.GetLength(1);

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
