//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que convierte un número
// binario a decimal
//************************************************

.data
msg_input: .string "Ingrese un número binario: "
msg_output: .string "El número en decimal es: %d\n"
msg_error: .string "Error: Ingrese solo 0s y 1s\n"
formato_str: .string "%s"  
buffer: .space 33        // 32 bits + null terminator
numero: .word 0

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Solicitar número binario
    adr x0, msg_input
    bl printf
    
    // Leer string binario
    adr x0, formato_str
    adr x1, buffer
    bl scanf
    
    // Inicializar registros
    mov w19, #0          // Resultado decimal
    mov w20, #1          // Potencia de 2 actual
    adr x21, buffer      // Puntero al string
    
    // Obtener longitud del string
    mov x22, x21        // Copiar dirección inicial
longitud_loop:
    ldrb w23, [x22]     // Cargar byte actual
    cbz w23, comenzar_conversion  // Si es null, terminar
    add x22, x22, #1    // Siguiente carácter
    b longitud_loop

comenzar_conversion:
    sub x22, x22, #1    // Retroceder al último dígito

conversion_loop:
    cmp x22, x21        // ¿Llegamos al inicio?
    b.lt fin_conversion
    
    // Cargar dígito actual
    ldrb w23, [x22]
    
    // Verificar si es válido (0 o 1)
    cmp w23, #'0'
    b.lt error_input
    cmp w23, #'1'
    b.gt error_input
    
    // Convertir ASCII a valor numérico
    sub w23, w23, #'0'
    
    // Si es 1, sumar la potencia actual
    cbz w23, siguiente_digito
    add w19, w19, w20
    
siguiente_digito:
    lsl w20, w20, #1    // Multiplicar potencia por 2
    sub x22, x22, #1    // Retroceder un dígito
    b conversion_loop

error_input:
    adr x0, msg_error
    bl printf
    b fin_programa

fin_conversion:
    // Mostrar resultado
    adr x0, msg_output
    mov w1, w19
    bl printf
    
fin_programa:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//C# 

/*using System;

class BinarioADecimal
{
    static void Main()
    {
        // Solicitar número binario
        Console.Write("Ingrese un número binario: ");
        string buffer = Console.ReadLine();

        // Inicializar variables
        int resultadoDecimal = 0;
        int potenciaActual = 1;

        // Validar y convertir cada dígito de derecha a izquierda
        for (int i = buffer.Length - 1; i >= 0; i--)
        {
            char digito = buffer[i];

            // Verificar si el dígito es válido (0 o 1)
            if (digito != '0' && digito != '1')
            {
                Console.WriteLine("Error: Ingrese solo 0s y 1s");
                return;
            }

            // Si el dígito es '1', sumar la potencia actual al resultado
            if (digito == '1')
            {
                resultadoDecimal += potenciaActual;
            }

            // Multiplicar la potencia actual por 2 para el siguiente dígito
            potenciaActual *= 2;
        }

        // Mostrar el resultado en decimal
        Console.WriteLine("El número en decimal es: " + resultadoDecimal);
    }
}
*/
