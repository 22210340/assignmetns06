//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que realiza operaciones AND, OR, XOR
// a nivel de bits entre dos números
// VIDEO: https://asciinema.org/a/UmcYv0G69R3nH3RMORoTUbqlk
//************************************************

    .data
msg_menu:       .string "\nOperaciones a nivel de bits\n"
                .string "1. AND\n"
                .string "2. OR\n"
                .string "3. XOR\n"
                .string "4. Salir\n"
                .string "Seleccione una opción: "

msg_num1:       .string "Ingrese el primer número: "
msg_num2:       .string "Ingrese el segundo número: "
msg_resultado:  .string "Resultado: %d\n"
msg_binario:    .string "En binario: "
msg_bit:        .string "%d"
msg_newline:    .string "\n"
formato_int:    .string "%d"

opcion:         .word 0
numero1:        .word 0
numero2:        .word 0

    .text
    .global main
    .align 2

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

menu_loop:
    // Mostrar menú
    adr     x0, msg_menu
    bl      printf

    // Leer opción
    adr     x0, formato_int
    adr     x1, opcion
    bl      scanf

    // Verificar si es opción de salida
    adr     x0, opcion
    ldr     w0, [x0]
    cmp     w0, #4
    b.eq    fin_programa

    // Leer primer número
    adr     x0, msg_num1
    bl      printf
    adr     x0, formato_int
    adr     x1, numero1
    bl      scanf

    // Leer segundo número
    adr     x0, msg_num2
    bl      printf
    adr     x0, formato_int
    adr     x1, numero2
    bl      scanf

    // Cargar números en registros
    adr     x0, numero1
    ldr     w1, [x0]
    adr     x0, numero2
    ldr     w2, [x0]

    // Verificar operación seleccionada
    adr     x0, opcion
    ldr     w0, [x0]

    cmp     w0, #1
    b.eq    hacer_and
    cmp     w0, #2
    b.eq    hacer_or
    cmp     w0, #3
    b.eq    hacer_xor
    b       menu_loop

hacer_and:
    and     w1, w1, w2
    b       mostrar_resultado

hacer_or:
    orr     w1, w1, w2
    b       mostrar_resultado

hacer_xor:
    eor     w1, w1, w2

mostrar_resultado:
    // Guardar resultado para mostrar
    mov     w19, w1             // Guardar resultado para mostrar en binario después

    // Mostrar resultado en decimal
    adr     x0, msg_resultado
    bl      printf

    // Mostrar resultado en binario
    adr     x0, msg_binario
    bl      printf

    mov     w20, #32            // Contador de bits
mostrar_bits:
    sub     w20, w20, #1        // Decrementar contador
    lsr     w21, w19, w20       // Desplazar a la derecha
    and     w1, w21, #1         // Obtener bit menos significativo
    
    // Imprimir bit
    adr     x0, msg_bit
    bl      printf

    cmp     w20, #0
    b.ne    mostrar_bits

    // Nueva línea
    adr     x0, msg_newline
    bl      printf

    b       menu_loop

fin_programa:
    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

//C#

/*using System;

class Program
{
    static void Main()
    {
        int opcion, numero1, numero2, resultado;

        // Menú de operaciones
        while (true)
        {
            Console.WriteLine("\nOperaciones a nivel de bits");
            Console.WriteLine("1. AND");
            Console.WriteLine("2. OR");
            Console.WriteLine("3. XOR");
            Console.WriteLine("4. Salir");
            Console.Write("Seleccione una opción: ");

            // Leer opción
            opcion = int.Parse(Console.ReadLine());

            // Verificar si se quiere salir
            if (opcion == 4)
                break;

            // Leer primer número
            Console.Write("Ingrese el primer número: ");
            numero1 = int.Parse(Console.ReadLine());

            // Leer segundo número
            Console.Write("Ingrese el segundo número: ");
            numero2 = int.Parse(Console.ReadLine());

            // Realizar operación según la opción seleccionada
            switch (opcion)
            {
                case 1: // AND
                    resultado = numero1 & numero2;
                    break;
                case 2: // OR
                    resultado = numero1 | numero2;
                    break;
                case 3: // XOR
                    resultado = numero1 ^ numero2;
                    break;
                default:
                    continue;
            }

            // Mostrar resultado en decimal
            Console.WriteLine("Resultado: " + resultado);

            // Mostrar resultado en binario
            Console.Write("En binario: ");
            MostrarEnBinario(resultado);
        }
    }

    static void MostrarEnBinario(int numero)
    {
        for (int i = 31; i >= 0; i--)
        {
            int bit = (numero >> i) & 1; // Obtener el bit correspondiente
            Console.Write(bit);
        }
        Console.WriteLine();
    }
}
*/
