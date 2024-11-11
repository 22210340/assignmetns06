//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que mide el tiempo de ejecucion
// VIDEO: https://asciinema.org/a/cbR7Fg4Dh94Bq4t1TfJhZvLaO
//************************************************

.arch armv8-a
    .text
    .align 2
    .global main
    .type main, @function

    // Definir constantes
    .equ    CLOCK_MONOTONIC, 1
    .equ    MILLION, 1000000
    .equ    THOUSAND, 1000
    .equ    MAX_ITER, 1000000

main:
    // Guardar registros
    stp     x29, x30, [sp, -48]!
    mov     x29, sp

    // Reservar espacio para estructuras timespec
    sub     sp, sp, #32     // Espacio para dos estructuras timespec

    // Obtener tiempo inicial
    mov     w0, #CLOCK_MONOTONIC    // CLOCK_MONOTONIC = 1
    mov     x1, sp          // Primera estructura timespec
    bl      clock_gettime

    // Llamar a la función que queremos medir
    bl      funcion_a_medir

    // Obtener tiempo final
    mov     w0, #CLOCK_MONOTONIC
    add     x1, sp, #16     // Segunda estructura timespec
    bl      clock_gettime

    // Calcular la diferencia de tiempo
    // Cargar tiempos iniciales
    ldr     x0, [sp]        // Segundos iniciales
    ldr     x1, [sp, #8]    // Nanosegundos iniciales
    // Cargar tiempos finales
    ldr     x2, [sp, #16]   // Segundos finales
    ldr     x3, [sp, #24]   // Nanosegundos finales

    // Calcular diferencia
    sub     x2, x2, x0      // Diferencia en segundos
    sub     x3, x3, x1      // Diferencia en nanosegundos

    // Convertir a microsegundos totales
    // Manejar los segundos
    movz    x4, #MILLION & 0xFFFF
    movk    x4, #(MILLION >> 16) & 0xFFFF, lsl #16
    mul     x2, x2, x4      // Convertir segundos a microsegundos

    // Manejar los nanosegundos
    mov     x4, #THOUSAND
    udiv    x3, x3, x4      // Convertir nanosegundos a microsegundos
    
    // Sumar ambas partes
    add     x1, x2, x3      // Tiempo total en microsegundos

    // Imprimir resultado
    adrp    x0, msg_tiempo
    add     x0, x0, :lo12:msg_tiempo
    bl      printf

    // Restaurar y salir
    mov     w0, #0
    add     sp, sp, #32     // Liberar espacio de estructuras timespec
    ldp     x29, x30, [sp], 48
    ret

// Función que vamos a medir (ejemplo: bucle simple)
funcion_a_medir:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    mov     x0, #0          // Contador
    // Cargar el valor máximo de iteraciones
    movz    x1, #MAX_ITER & 0xFFFF
    movk    x1, #(MAX_ITER >> 16) & 0xFFFF, lsl #16

1:  add     x0, x0, #1      // Incrementar contador
    cmp     x0, x1          // Comparar con límite
    b.lt    1b              // Repetir si es menor

    // Imprimir mensaje de finalización
    adrp    x0, msg_funcion
    add     x0, x0, :lo12:msg_funcion
    bl      printf

    ldp     x29, x30, [sp], 16
    ret

    .section    .rodata
msg_tiempo:     .string "Tiempo de ejecución: %ld microsegundos\n"
msg_funcion:    .string "Función completada\n"

//c#

/*using System;
using System.Diagnostics;

class Program
{
    static void Main()
    {
        // Mensaje de inicio
        Console.WriteLine("\n=== MEDIDOR DE TIEMPO DE EJECUCIÓN ===");

        // Obtener el tiempo inicial
        Stopwatch stopwatch = Stopwatch.StartNew();

        // Llamar a la función que queremos medir
        FuncionAMedir();

        // Detener el cronómetro
        stopwatch.Stop();

        // Calcular el tiempo en microsegundos
        long tiempoMicrosegundos = stopwatch.ElapsedTicks * 1000000 / Stopwatch.Frequency;

        // Imprimir el tiempo de ejecución en microsegundos
        Console.WriteLine($"Tiempo de ejecución: {tiempoMicrosegundos} microsegundos");
    }

    static void FuncionAMedir()
    {
        // Función que simula una tarea intensiva (ejemplo: bucle de conteo)
        int contador = 0;
        int iteraciones = 10000000;

        for (int i = 0; i < iteraciones; i++)
        {
            contador++; // Incrementar el contador en cada iteración
        }

        // Imprimir mensaje de finalización
        Console.WriteLine("Función completada");
    }
}
*/
