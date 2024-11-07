//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que realiza la transposición de una matriz
// Sistema: Linux ARM64
// Compilación: 
//    as -g matriz_trans.s -o matriz_trans.o
//    gcc matriz_trans.o -o matriz_trans
// Ejecución:
//    ./matriz_trans
//************************************************

    .arch armv8-a              // Especifica la arquitectura ARMv8-A

    .data
    // Matriz original 3x3
matriz:     .quad   1, 2, 3
           .quad   4, 5, 6
           .quad   7, 8, 9
    
    // Matriz transpuesta 3x3
transpuesta: .zero   72          // 9 elementos * 8 bytes = 72 bytes
    
    // Dimensiones de la matriz
filas:      .quad   3
columnas:   .quad   3
    
    // Mensajes para imprimir
msg_original:   .string "\nMatriz Original:\n"
msg_trans:      .string "\nMatriz Transpuesta:\n"
msg_elemento:   .string "%3ld "  // Formato para long int en Linux
msg_newline:    .string "\n"

    .text
    .global main
    .type main, %function
    .align 2
main:
    // Prólogo
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
    adr     x0, msg_trans
    bl      printf
    adr     x0, transpuesta
    bl      imprimir_matriz
    
    // Epílogo y retorno
    ldp     x29, x30, [sp], 16
    mov     w0, 0
    ret

// Función para transponer matriz
transponer_matriz:
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
    b.ge    fin_transposicion
    mov     x22, #0             // j = 0

bucle_j:
    cmp     x22, x21            // Comparar j con columnas
    b.ge    siguiente_i
    
    // Calcular índice matriz original [i][j]
    mul     x23, x19, x21       // i * columnas
    add     x23, x23, x22       // + j
    lsl     x23, x23, #3        // * 8 (tamaño de quad)
    
    // Calcular índice matriz transpuesta [j][i]
    mul     x24, x22, x20       // j * filas
    add     x24, x24, x19       // + i
    lsl     x24, x24, #3        // * 8
    
    // Cargar elemento de matriz original
    adr     x25, matriz
    ldr     x26, [x25, x23]
    
    // Guardar en matriz transpuesta
    adr     x27, transpuesta
    str     x26, [x27, x24]
    
    add     x22, x22, #1        // j++
    b       bucle_j

siguiente_i:
    add     x19, x19, #1        // i++
    b       bucle_i

fin_transposicion:
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

/*using System;

class MatrixTranspose
{
    static void Main()
    {
        // Definimos la matriz original
        long[,] matriz = {
            { 1, 2, 3 },
            { 4, 5, 6 },
            { 7, 8, 9 }
        };

        int filas = 3;
        int columnas = 3;
        long[,] transpuesta = new long[filas, columnas];

        Console.WriteLine("Matriz Original:");
        ImprimirMatriz(matriz, filas, columnas);

        // Transponer la matriz
        TransponerMatriz(matriz, transpuesta, filas, columnas);

        Console.WriteLine("\nMatriz Transpuesta:");
        ImprimirMatriz(transpuesta, filas, columnas);
    }

    // Función para transponer una matriz
    static void TransponerMatriz(long[,] matriz, long[,] transpuesta, int filas, int columnas)
    {
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                transpuesta[j, i] = matriz[i, j];
            }
        }
    }

    // Función para imprimir una matriz
    static void ImprimirMatriz(long[,] matriz, int filas, int columnas)
    {
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                Console.Write($"{matriz[i, j],4} ");
            }
            Console.WriteLine();
        }
    }
}
*/
