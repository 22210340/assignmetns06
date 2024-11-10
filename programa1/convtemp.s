// *********************************************************************
// Autor: Rivas Perez Kevin Jonathan / CHATGPT
// Descripción: Conversión de temperatura de Celsius a Fahrenheit
// Fórmula en C/C++: 
//    float celsius = 25.0;
//    float fahrenheit = (celsius * 9.0 / 5.0) + 32.0;
//   VIDEO: https://asciinema.org/a/otyO8vwkSPwaFejIZoZErDiCM
// *********************************************************************

    .data                   
celsius_value:  .float 25.0         // Valor en Celsius (puedes cambiarlo)
output_msg:     .asciz "Fahrenheit: "  // Mensaje de salida
newline:        .asciz "\n"            // Salto de línea

    .text                   
    .global _start          

_start:
    // Cargar la dirección de la variable Celsius en un registro general
    ADRP    X0, celsius_value           // Cargar la página base de celsius_value en X0
    ADD     X0, X0, :lo12:celsius_value // Cargar la dirección completa en X0
    LDR     S1, [X0]                    // Cargar el valor de Celsius en S1 (punto flotante)

    // Calcular C * 9
    MOV     W2, #9                      // W2 = 9
    SCVTF   S2, W2                      // Convertir W2 a float y almacenar en S2
    FMUL    S1, S1, S2                  // S1 = Celsius * 9

    // Dividir el resultado por 5
    MOV     W3, #5                      // W3 = 5
    SCVTF   S3, W3                      // Convertir W3 a float y almacenar en S3
    FDIV    S1, S1, S3                  // S1 = (Celsius * 9) / 5

    // Sumar 32 al resultado
    MOV     W4, #32                     // W4 = 32
    SCVTF   S4, W4                      // Convertir W4 a float y almacenar en S4
    FADD    S1, S1, S4                  // S1 = ((Celsius * 9) / 5) + 32

    // Convertir el resultado a entero (redondeo hacia abajo)
    FCVTZS  W5, S1                      // Convertir de float (S1) a int (W5)

    // Mostrar el mensaje "Fahrenheit: "
    ADRP    X0, output_msg              // Dirección de "Fahrenheit: "
    ADD     X0, X0, :lo12:output_msg
    MOV     X1, #1                      // File descriptor 1 (stdout)
    MOV     X2, #12                     // Tamaño del mensaje (12 bytes)
    MOV     X8, #64                     // Syscall number para write
    SVC     #0                          // Llamada al sistema para escribir mensaje

    // Convertir el número en W5 a caracteres ASCII y mostrarlo
    MOV     X1, #1                      // File descriptor 1 (stdout)
    MOV     W9, #10                     // Cargar el valor 10 en W9 para la división y el módulo

convert_loop:
    UDIV    W6, W5, W9                  // W6 = W5 / 10
    MADD    W7, W6, W9, WZR             // W7 = W6 * 10
    SUB     W7, W5, W7                  // W7 = W5 - (W6 * 10) (obtener el dígito)
    ADD     W7, W7, #'0'                // Convertir el dígito a ASCII
    MOV     X2, #1                      // Tamaño del carácter
    MOV     X0, X1                      // stdout
    MOV     W5, W6                      // Actualizar W5 con el cociente
    MOV     X8, #64                     // Syscall para write
    SVC     #0                          // Escribir el dígito
    CMP     W5, #0                      // ¿Quedan dígitos?
    BNE     convert_loop                // Si no es 0, continuar el bucle

    // Escribir un salto de línea
    ADRP    X0, newline                 // Cargar la dirección del salto de línea
    ADD     X0, X0, :lo12:newline
    MOV     X2, #1                      // Tamaño del salto de línea
    MOV     X8, #64                     // Syscall para write
    SVC     #0                          // Escribir salto de línea

    // Salida del programa
    MOV     X8, #93                     // Llamada al sistema para salir (exit)
    SVC     #0                          // Ejecutar llamada al sistema

//C#

/* using System;

class Program
{
    static void Main()
    {
        // Valor en Celsius
        float celsius = 25.0f;

        // Convertir Celsius a Fahrenheit
        float fahrenheit = ((celsius * 9) / 5) + 32;

        // Mostrar el mensaje de salida
        Console.WriteLine("Fahrenheit: " + fahrenheit);
    }
}
*/
