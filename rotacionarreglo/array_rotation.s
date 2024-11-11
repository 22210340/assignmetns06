//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que realiza rotaciones
// a la izquierda y derecha de un arreglo
// VIDEO: https://asciinema.org/a/D8MJXCH62pJ1rLEd0xVa72tOU
//************************************************

.data
    // Mensajes del menú
    msg_menu: 
        .string "\nRotación de Arreglos\n"
        .string "1. Rotar a la izquierda\n"
        .string "2. Rotar a la derecha\n"
        .string "3. Salir\n"
        .string "Seleccione una opción: "
    
    msg_pos: .string "Ingrese posiciones a rotar: "
    msg_array: .string "Arreglo: "
    msg_resultado: .string "Resultado: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Arreglo y variables
    array: .word 1, 2, 3, 4, 5  // Arreglo de ejemplo
    temp_array: .skip 20        // Arreglo temporal (5 elementos * 4 bytes)
    array_size: .word 5
    opcion: .word 0
    posiciones: .word 0

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

    // Verificar salida
    adr x0, opcion
    ldr w0, [x0]
    cmp w0, #3
    b.eq fin_programa

    // Leer posiciones a rotar
    adr x0, msg_pos
    bl printf
    adr x0, formato_int
    adr x1, posiciones
    bl scanf

    // Mostrar arreglo original
    adr x0, msg_array
    bl printf
    bl mostrar_array

    // Seleccionar operación
    adr x0, opcion
    ldr w0, [x0]
    cmp w0, #1
    b.eq rotar_izquierda
    cmp w0, #2
    b.eq rotar_derecha
    b menu_loop

rotar_izquierda:
    // Cargar valores necesarios
    adr x20, array
    adr x21, temp_array
    adr x22, array_size
    ldr w22, [x22]         // Tamaño del arreglo
    adr x23, posiciones
    ldr w23, [x23]        // Posiciones a rotar
    
    // Normalizar posiciones
    sdiv w24, w23, w22    // División
    mul w24, w24, w22     // Multiplicación
    sub w23, w23, w24     // Módulo
    
    // Copiar elementos al arreglo temporal
    mov w24, #0           // Índice
copiar_izq_loop:
    ldr w25, [x20, w24, SXTW #2]
    str w25, [x21, w24, SXTW #2]
    add w24, w24, #1
    cmp w24, w22
    b.lt copiar_izq_loop
    
    // Realizar rotación
    mov w24, #0           // Índice destino
rotar_izq_loop:
    add w25, w24, w23     // Índice origen = (i + k) % n
    sdiv w26, w25, w22    // División
    mul w26, w26, w22     // Multiplicación
    sub w25, w25, w26     // Módulo
    
    ldr w27, [x21, w25, SXTW #2]
    str w27, [x20, w24, SXTW #2]
    
    add w24, w24, #1
    cmp w24, w22
    b.lt rotar_izq_loop
    
    b mostrar_resultado

rotar_derecha:
    // Cargar valores necesarios
    adr x20, array
    adr x21, temp_array
    adr x22, array_size
    ldr w22, [x22]
    adr x23, posiciones
    ldr w23, [x23]
    
    // Normalizar posiciones
    sdiv w24, w23, w22
    mul w24, w24, w22
    sub w23, w23, w24
    
    // Copiar elementos al arreglo temporal
    mov w24, #0
copiar_der_loop:
    ldr w25, [x20, w24, SXTW #2]
    str w25, [x21, w24, SXTW #2]
    add w24, w24, #1
    cmp w24, w22
    b.lt copiar_der_loop
    
    // Realizar rotación
    mov w24, #0
rotar_der_loop:
    sub w25, w22, w23     // n - k
    add w25, w25, w24     // (n - k + i)
    sdiv w26, w25, w22    // División
    mul w26, w26, w22     // Multiplicación
    sub w25, w25, w26     // Módulo
    
    ldr w27, [x21, w25, SXTW #2]
    str w27, [x20, w24, SXTW #2]
    
    add w24, w24, #1
    cmp w24, w22
    b.lt rotar_der_loop
    
    b mostrar_resultado

mostrar_array:
    // Mostrar elementos del arreglo
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    mov w22, #0

mostrar_loop:
    ldr w1, [x20, w22, SXTW #2]
    adr x0, msg_num
    bl printf
    
    add w22, w22, #1
    cmp w22, w21
    b.lt mostrar_loop
    
    adr x0, msg_newline
    bl printf
    ret

mostrar_resultado:
    // Mostrar mensaje de resultado
    adr x0, msg_resultado
    bl printf
    
    // Mostrar arreglo rotado
    bl mostrar_array
    
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

// C#

/*using System;

class Program
{
    // Mensajes del menú
    static readonly string msgMenu = "\nRotación de Arreglos\n" +
                                     "1. Rotar a la izquierda\n" +
                                     "2. Rotar a la derecha\n" +
                                     "3. Salir\n" +
                                     "Seleccione una opción: ";
    static readonly string msgPos = "Ingrese posiciones a rotar: ";
    static readonly string msgArray = "Arreglo: ";
    static readonly string msgResultado = "Resultado: ";
    static readonly string msgNewline = "\n";

    // Arreglo de ejemplo
    static int[] array = { 1, 2, 3, 4, 5 };
    static int arraySize = array.Length;

    static void Main()
    {
        while (true)
        {
            // Mostrar menú y leer opción
            Console.Write(msgMenu);
            int opcion = int.Parse(Console.ReadLine());

            // Verificar opción de salida
            if (opcion == 3)
            {
                Console.WriteLine("Saliendo del programa...");
                break;
            }

            // Leer posiciones para rotar
            Console.Write(msgPos);
            int posiciones = int.Parse(Console.ReadLine());

            // Mostrar arreglo original
            Console.Write(msgArray);
            MostrarArray();

            // Realizar la operación seleccionada
            if (opcion == 1)
            {
                RotarIzquierda(posiciones);
            }
            else if (opcion == 2)
            {
                RotarDerecha(posiciones);
            }
            else
            {
                Console.WriteLine("Opción inválida, intente nuevamente.");
            }

            // Mostrar resultado de la operación
            Console.WriteLine(msgResultado);
            MostrarArray();
        }
    }

    static void RotarIzquierda(int posiciones)
    {
        posiciones %= arraySize; // Normalizar posiciones
        int[] tempArray = new int[arraySize];

        // Copiar elementos al arreglo temporal
        Array.Copy(array, tempArray, arraySize);

        // Realizar la rotación a la izquierda
        for (int i = 0; i < arraySize; i++)
        {
            array[i] = tempArray[(i + posiciones) % arraySize];
        }
    }

    static void RotarDerecha(int posiciones)
    {
        posiciones %= arraySize; // Normalizar posiciones
        int[] tempArray = new int[arraySize];

        // Copiar elementos al arreglo temporal
        Array.Copy(array, tempArray, arraySize);

        // Realizar la rotación a la derecha
        for (int i = 0; i < arraySize; i++)
        {
            array[i] = tempArray[(i - posiciones + arraySize) % arraySize];
        }
    }

    static void MostrarArray()
    {
        foreach (int num in array)
        {
            Console.Write($"{num} ");
        }
        Console.WriteLine(msgNewline);
    }
}
*/
