//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que suma elementos de un arreglo
// y permite invertir el orden de los elementos
// VIDEO: https://asciinema.org/a/nT2uPXfVRc468kZ68s0J2bOqt
//************************************************

.data
    // Mensajes del menú
    msg_menu: 
        .string "\nOperaciones con Arreglos\n"
        .string "1. Sumar elementos del arreglo\n"
        .string "2. Invertir arreglo\n"
        .string "3. Salir\n"
        .string "Seleccione una opción: "
    
    msg_resultado: .string "Resultado de la suma: %d\n"
    msg_array: .string "Arreglo: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Arreglo de ejemplo y variables
    array: .word 1, 2, 3, 4, 5  // Arreglo de 5 elementos
    array_size: .word 5
    opcion: .word 0
    suma: .word 0

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

menu_loop:
    // Mostrar menú
    adr x0, msg_menu
    bl printf

    // Leer opción
    adr x0, formato_int
    adr x1, opcion
    bl scanf

    // Verificar opción
    adr x0, opcion
    ldr w0, [x0]
    
    cmp w0, #3
    b.eq fin_programa
    
    cmp w0, #1
    b.eq sumar_array
    
    cmp w0, #2
    b.eq invertir_array
    
    b menu_loop

sumar_array:
    // Inicializar suma en 0
    mov w19, #0
    
    // Cargar dirección base del array y tamaño
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    mov w22, #0  // índice
    
suma_loop:
    // Sumar elemento actual
    ldr w23, [x20, w22, SXTW #2]
    add w19, w19, w23
    
    // Incrementar índice
    add w22, w22, #1
    
    // Verificar si terminamos
    cmp w22, w21
    b.lt suma_loop
    
    // Mostrar resultado
    adr x0, msg_resultado
    mov w1, w19
    bl printf
    
    b menu_loop

invertir_array:
    // Cargar dirección base y tamaño
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    
    // Inicializar índices
    mov w22, #0  // inicio
    sub w23, w21, #1  // fin
    
invertir_loop:
    // Verificar si terminamos
    cmp w22, w23
    b.ge mostrar_array
    
    // Intercambiar elementos
    ldr w24, [x20, w22, SXTW #2]  // temp1
    ldr w25, [x20, w23, SXTW #2]  // temp2
    
    str w25, [x20, w22, SXTW #2]
    str w24, [x20, w23, SXTW #2]
    
    // Actualizar índices
    add w22, w22, #1
    sub w23, w23, #1
    
    b invertir_loop

mostrar_array:
    // Mostrar mensaje
    adr x0, msg_array
    bl printf
    
    // Inicializar índice
    mov w22, #0
    
mostrar_loop:
    // Mostrar elemento actual
    ldr w1, [x20, w22, SXTW #2]
    adr x0, msg_num
    bl printf
    
    // Incrementar índice
    add w22, w22, #1
    
    // Verificar si terminamos
    cmp w22, w21
    b.lt mostrar_loop
    
    // Nueva línea
    adr x0, msg_newline
    bl printf
    
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//C#

/*using System;

class Program
{
    // Mensajes del menú
    static readonly string msgMenu = "\nOperaciones con Arreglos\n" +
                                      "1. Sumar elementos del arreglo\n" +
                                      "2. Invertir arreglo\n" +
                                      "3. Salir\n" +
                                      "Seleccione una opción: ";
    static readonly string msgResultado = "Resultado de la suma: {0}\n";
    static readonly string msgArray = "Arreglo: ";
    static readonly string msgNewline = "\n";

    // Arreglo de ejemplo
    static int[] array = { 1, 2, 3, 4, 5 };

    static void Main()
    {
        while (true)
        {
            // Mostrar menú y leer opción
            Console.Write(msgMenu);
            int opcion = int.Parse(Console.ReadLine());

            switch (opcion)
            {
                case 1:
                    SumarArray();
                    break;
                case 2:
                    InvertirArray();
                    break;
                case 3:
                    Console.WriteLine("Saliendo del programa...");
                    return;
                default:
                    Console.WriteLine("Opción inválida, intente nuevamente.");
                    break;
            }
        }
    }

    static void SumarArray()
    {
        int suma = 0;
        foreach (int num in array)
        {
            suma += num;
        }

        // Mostrar resultado
        Console.WriteLine(msgResultado, suma);
    }

    static void InvertirArray()
    {
        // Invertir el arreglo
        Array.Reverse(array);

        // Mostrar arreglo invertido
        MostrarArray();
    }

    static void MostrarArray()
    {
        Console.Write(msgArray);
        foreach (int num in array)
        {
            Console.Write($"{num} ");
        }
        Console.WriteLine(msgNewline);
    }
}
*/
