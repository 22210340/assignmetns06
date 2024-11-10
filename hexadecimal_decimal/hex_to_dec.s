//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que convierte un número
// hexadecimal a decimal
//************************************************

.data
msg_input: .string "Ingrese un número hexadecimal (sin 0x): "
msg_output: .string "El número en decimal es: %d\n"
msg_error: .string "Error: Carácter hexadecimal inválido\n"
formato_str: .string "%s"
buffer: .space 33       // 32 caracteres + null terminator
numero: .word 0

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Solicitar número hexadecimal
    adr x0, msg_input
    bl printf
    
    // Leer string hexadecimal
    adr x0, formato_str
    adr x1, buffer
    bl scanf
    
    // Inicializar registros
    mov w19, #0          // Resultado decimal
    mov w20, #1          // Base (16^0)
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
    
    // Convertir a valor numérico
    cmp w23, #'0'
    b.lt error_input
    cmp w23, #'9'
    b.le digito_numerico
    
    // Convertir letras mayúsculas
    cmp w23, #'A'
    b.lt error_input
    cmp w23, #'F'
    b.le letra_mayuscula
    
    // Convertir letras minúsculas
    cmp w23, #'a'
    b.lt error_input
    cmp w23, #'f'
    b.gt error_input
    
    // Convertir a-f
    sub w23, w23, #'a'
    add w23, w23, #10
    b procesar_digito

letra_mayuscula:
    // Convertir A-F
    sub w23, w23, #'A'
    add w23, w23, #10
    b procesar_digito

digito_numerico:
    // Convertir 0-9
    sub w23, w23, #'0'

procesar_digito:
    // Multiplicar por la potencia actual y sumar
    mul w24, w23, w20
    add w19, w19, w24
    
    // Siguiente potencia de 16
    mov w25, #16
    mul w20, w20, w25
    
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

class HexadecimalADecimal
{
    static void Main()
    {
        // Solicitar número hexadecimal
        Console.Write("Ingrese un número hexadecimal (sin 0x): ");
        string input = Console.ReadLine();
        
        try
        {
            // Intentar convertir el número hexadecimal a decimal
            int decimalValue = Convert.ToInt32(input, 16);
            
            // Mostrar el resultado
            Console.WriteLine("El número en decimal es: {0}", decimalValue);
        }
        catch (FormatException)
        {
            // Manejo de error para caracteres hexadecimales inválidos
            Console.WriteLine("Error: Carácter hexadecimal inválido");
        }
        catch (OverflowException)
        {
            // Manejo de error si el valor es demasiado grande
            Console.WriteLine("Error: El número es demasiado grande para un entero de 32 bits");
        }
    }
}
*/
