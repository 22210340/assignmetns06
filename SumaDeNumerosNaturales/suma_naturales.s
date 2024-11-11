// *********************************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa en ensamblador ARM64 que solicita un número N 
//              al usuario y calcula la suma de los primeros N números
//              naturales (1 + 2 + 3 + ... + N), mostrando el resultado.
// VIDEO: https://asciinema.org/a/jzEm0aJd05N0lDI4erAd8DZTY
// *********************************************************************

.global _start

.data
    msgInput:   .ascii "Ingrese un número N: "
    lenInput = . - msgInput
    msgResult:  .ascii "La suma de los primeros "
    lenResult = . - msgResult
    msgResult2: .ascii " números naturales es: "
    lenResult2 = . - msgResult2
    newline:    .ascii "\n"
    buffer:     .skip 12
    num:        .quad 0

.text
_start:
    // Mostrar mensaje de entrada
    mov x0, #1              // fd = 1 (stdout)
    adr x1, msgInput       // dirección del mensaje
    mov x2, lenInput       // longitud del mensaje
    mov x8, #64            // syscall write
    svc #0

    // Leer número N
    mov x0, #0              // fd = 0 (stdin)
    adr x1, buffer         // buffer para almacenar entrada
    mov x2, #12            // tamaño máximo a leer
    mov x8, #63            // syscall read
    svc #0
    
    // Convertir entrada de ASCII a entero
    adr x1, buffer
    bl ascii_to_int
    adr x1, num
    str x0, [x1]           // Guardar N
    mov x19, x0            // Guardar N en x19 para usarlo después

    // Calcular la suma usando la fórmula: suma = n(n+1)/2
    add x1, x0, #1         // n + 1
    mul x2, x0, x1         // n(n+1)
    mov x3, #2
    udiv x4, x2, x3        // n(n+1)/2 - resultado final

    // Mostrar primera parte del mensaje de resultado
    mov x0, #1
    adr x1, msgResult
    mov x2, lenResult
    mov x8, #64
    svc #0

    // Mostrar N
    mov x5, x19            // Recuperar N para mostrarlo
    adr x6, buffer
    mov x7, #0

convert_n:
    mov x9, #10
    udiv x10, x5, x9
    msub x11, x10, x9, x5
    add x11, x11, #48
    strb w11, [x6, x7]
    add x7, x7, #1
    mov x5, x10
    cbnz x5, convert_n

    // Invertir dígitos de N
    mov x9, #0
    sub x10, x7, #1
reverse_n:
    cmp x9, x10
    bge end_reverse_n
    ldrb w11, [x6, x9]
    ldrb w12, [x6, x10]
    strb w12, [x6, x9]
    strb w11, [x6, x10]
    add x9, x9, #1
    sub x10, x10, #1
    b reverse_n

end_reverse_n:
    // Mostrar N
    mov x0, #1
    mov x1, x6
    mov x2, x7
    mov x8, #64
    svc #0

    // Mostrar segunda parte del mensaje
    mov x0, #1
    adr x1, msgResult2
    mov x2, lenResult2
    mov x8, #64
    svc #0

    // Convertir resultado a ASCII
    mov x5, x4             // Copiar resultado
    adr x6, buffer
    mov x7, #0

convert_result:
    mov x9, #10
    udiv x10, x5, x9
    msub x11, x10, x9, x5
    add x11, x11, #48
    strb w11, [x6, x7]
    add x7, x7, #1
    mov x5, x10
    cbnz x5, convert_result

    // Invertir dígitos del resultado
    mov x9, #0
    sub x10, x7, #1
reverse_result:
    cmp x9, x10
    bge end_reverse_result
    ldrb w11, [x6, x9]
    ldrb w12, [x6, x10]
    strb w12, [x6, x9]
    strb w11, [x6, x10]
    add x9, x9, #1
    sub x10, x10, #1
    b reverse_result

end_reverse_result:
    // Mostrar resultado
    mov x0, #1
    mov x1, x6
    mov x2, x7
    mov x8, #64
    svc #0

    // Mostrar nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0

    // Salir del programa
    mov x8, #93
    mov x0, #0
    svc #0

// Función para convertir ASCII a entero
ascii_to_int:
    mov x0, #0             // Resultado
    mov x2, #0             // Índice
convert_digit:
    ldrb w3, [x1, x2]      // Cargar byte
    cmp w3, #10            // Comprobar si es nueva línea
    beq end_convert
    cmp w3, #0             // Comprobar si es fin de cadena
    beq end_convert
    sub w3, w3, #48        // Convertir ASCII a número
    mov x4, #10
    mul x0, x0, x4         // Multiplicar resultado por 10
    add x0, x0, x3         // Añadir nuevo dígito
    add x2, x2, #1         // Siguiente dígito
    b convert_digit
end_convert:
    ret

    //C# 
    /* using System;

class Program
{
    static void Main()
    {
        try
        {
            // Solicitar al usuario el número N
            Console.Write("Ingrese un número N: ");
            string input = Console.ReadLine();
            int n = AsciiToInt(input);

            // Calcular la suma de los primeros N números naturales usando la fórmula suma = n * (n + 1) / 2
            int suma = n * (n + 1) / 2;

            // Mostrar el resultado
            Console.WriteLine($"La suma de los primeros {n} números naturales es: {suma}");
        }
        catch (FormatException)
        {
            Console.WriteLine("Error: La entrada no es un número válido.");
        }
        catch (OverflowException)
        {
            Console.WriteLine("Error: El número ingresado es demasiado grande.");
        }
    }

    // Función para convertir una cadena ASCII a un entero
    static int AsciiToInt(string asciiInput)
    {
        int result = 0;

        foreach (char digitChar in asciiInput)
        {
            if (digitChar == '\n' || digitChar == '\r') continue; // Ignorar saltos de línea
            int digit = digitChar - '0'; // Convertir carácter a dígito
            if (digit < 0 || digit > 9)
            {
                throw new FormatException("Caracter no válido en la entrada.");
            }
            result = result * 10 + digit;
        }

        return result;
    }
}
*/
