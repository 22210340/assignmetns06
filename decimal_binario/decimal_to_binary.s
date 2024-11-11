//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que convierte números 
// decimales a su representación binaria
// VIDEO: https://asciinema.org/a/ObVo4QRL8FcrAZaVpu0DZIljx
//************************************************

.data
    msg_menu: 
        .string "\nConversor Decimal a Binario\n"
        .string "1. Convertir número\n"
        .string "2. Salir\n"
        .string "Seleccione una opción: "
    
    msg_input: .string "Ingrese un número decimal (positivo): "
    msg_result: .string "El número %d en binario es: "
    msg_negative: .string "Por favor ingrese un número positivo\n"
    msg_bit: .string "%d"
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Variables
    opcion: .word 0
    numero: .word 0
    binary: .skip 32     // Arreglo para almacenar bits (32 bits máximo)
    binary_size: .word 0

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
    
    cmp w0, #2
    b.eq fin_programa
    
    cmp w0, #1
    b.eq convertir_numero
    
    b menu_loop

convertir_numero:
    // Solicitar número
    adr x0, msg_input
    bl printf
    
    // Leer número
    adr x0, formato_int
    adr x1, numero
    bl scanf
    
    // Verificar si es positivo
    adr x0, numero
    ldr w0, [x0]
    cmp w0, #0
    b.lt numero_negativo
    
    // Preparar para conversión
    mov w19, w0          // Guardar número original
    adr x20, binary      // Dirección del arreglo de bits
    mov w21, #0          // Contador de bits
    
    // Si el número es 0, manejo especial
    cmp w19, #0
    b.eq caso_cero

conversion_loop:
    // Verificar si el número es 0
    cmp w19, #0
    b.eq mostrar_resultado
    
    // Obtener bit actual (número & 1)
    and w22, w19, #1
    
    // Guardar bit en el arreglo
    str w22, [x20, w21, SXTW #2]
    
    // Incrementar contador
    add w21, w21, #1
    
    // Dividir número por 2 (shift right)
    lsr w19, w19, #1
    
    b conversion_loop

caso_cero:
    mov w22, #0
    str w22, [x20]
    mov w21, #1
    b mostrar_resultado

mostrar_resultado:
    // Guardar tamaño del binario
    adr x22, binary_size
    str w21, [x22]
    
    // Mostrar mensaje inicial
    adr x0, msg_result
    adr x1, numero
    ldr w1, [x1]
    bl printf
    
    // Mostrar bits en orden inverso
    sub w21, w21, #1     // Índice del último bit
    
mostrar_bits:
    ldr w1, [x20, w21, SXTW #2]
    adr x0, msg_bit
    bl printf
    
    sub w21, w21, #1
    cmp w21, #-1
    b.ge mostrar_bits
    
    // Nueva línea
    adr x0, msg_newline
    bl printf
    
    b menu_loop

numero_negativo:
    adr x0, msg_negative
    bl printf
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//C#

/*using System;

class DecimalToBinaryConverter
{
    static readonly string msgMenu = "\nConversor Decimal a Binario\n" +
                                     "1. Convertir número\n" +
                                     "2. Salir\n" +
                                     "Seleccione una opción: ";
    static readonly string msgInput = "Ingrese un número decimal (positivo): ";
    static readonly string msgResult = "El número {0} en binario es: ";
    static readonly string msgNegative = "Por favor ingrese un número positivo\n";

    static void Main()
    {
        while (true)
        {
            // Mostrar menú
            Console.Write(msgMenu);
            int opcion = int.Parse(Console.ReadLine());

            if (opcion == 2)
            {
                Console.WriteLine("Saliendo del programa...");
                break;
            }
            else if (opcion == 1)
            {
                ConvertirNumero();
            }
            else
            {
                Console.WriteLine("Opción inválida, intente nuevamente.");
            }
        }
    }

    static void ConvertirNumero()
    {
        // Solicitar número
        Console.Write(msgInput);
        int numero;
        if (!int.TryParse(Console.ReadLine(), out numero) || numero < 0)
        {
            Console.WriteLine(msgNegative);
            return;
        }

        // Manejar el caso especial para el número 0
        if (numero == 0)
        {
            Console.WriteLine(msgResult, numero, "0");
            return;
        }

        // Convertir a binario
        string binario = ConvertirADecimal(numero);
        Console.WriteLine(msgResult, numero, binario);
    }

    static string ConvertirADecimal(int numero)
    {
        char[] bits = new char[32];  // Arreglo para almacenar hasta 32 bits
        int indice = 0;

        // Llenar el arreglo de bits en orden inverso
        while (numero > 0)
        {
            bits[indice++] = (char)((numero % 2) + '0');
            numero /= 2;
        }

        // Invertir el orden de los bits para la salida correcta
        Array.Reverse(bits, 0, indice);
        return new string(bits, 0, indice);
    }
}
*/
