//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que permite establecer, borrar
// y alternar bits específicos en un número
// VIDEO: https://asciinema.org/a/yZRtHNyo6NU835U87Lxr7GsPL
//************************************************

    .data
msg_menu:       .string "\nManipulación de bits\n"
                .string "1. Establecer bit (SET)\n"
                .string "2. Borrar bit (CLEAR)\n"
                .string "3. Alternar bit (TOGGLE)\n"
                .string "4. Salir\n"
                .string "Seleccione una opción: "

msg_num:        .string "Ingrese el número: "
msg_pos:        .string "Ingrese la posición del bit (0-31): "
msg_resultado:  .string "Resultado: %d\n"
msg_binario:    .string "En binario: "
msg_bit:        .string "%d"
msg_newline:    .string "\n"
formato_int:    .string "%d"

opcion:         .word 0
numero:         .word 0
posicion:       .word 0

    .text
    .global main
    .align 2

main:
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

    // Verificar salida
    adr     x0, opcion
    ldr     w0, [x0]
    cmp     w0, #4
    b.eq    fin_programa

    // Leer número
    adr     x0, msg_num
    bl      printf
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Leer posición
    adr     x0, msg_pos
    bl      printf
    adr     x0, formato_int
    adr     x1, posicion
    bl      scanf

    // Cargar valores
    adr     x0, numero
    ldr     w1, [x0]        // Número original
    adr     x0, posicion
    ldr     w2, [x0]        // Posición
    adr     x0, opcion
    ldr     w0, [x0]        // Opción

    // Seleccionar operación
    cmp     w0, #1
    b.eq    set_bit
    cmp     w0, #2
    b.eq    clear_bit
    cmp     w0, #3
    b.eq    toggle_bit
    b       menu_loop

set_bit:
    mov     w3, #1          // Crear máscara
    lsl     w3, w3, w2      // Desplazar 1 a la posición
    orr     w1, w1, w3      // OR con la máscara
    b       mostrar_resultado

clear_bit:
    mov     w3, #1          // Crear máscara
    lsl     w3, w3, w2      // Desplazar 1 a la posición
    mvn     w3, w3          // Invertir bits
    and     w1, w1, w3      // AND con la máscara
    b       mostrar_resultado

toggle_bit:
    mov     w3, #1          // Crear máscara
    lsl     w3, w3, w2      // Desplazar 1 a la posición
    eor     w1, w1, w3      // XOR con la máscara

mostrar_resultado:
    // Guardar resultado
    mov     w19, w1

    // Mostrar en decimal
    adr     x0, msg_resultado
    bl      printf

    // Mostrar en binario
    adr     x0, msg_binario
    bl      printf

    mov     w20, #32
mostrar_bits:
    sub     w20, w20, #1
    lsr     w21, w19, w20
    and     w1, w21, #1
    adr     x0, msg_bit
    bl      printf

    cmp     w20, #0
    b.ne    mostrar_bits

    adr     x0, msg_newline
    bl      printf

    b       menu_loop

fin_programa:
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

//C#

/*using System;

class Program
{
    static void Main()
    {
        int opcion, numero, posicion, resultado;

        // Menú de manipulación de bits
        while (true)
        {
            Console.WriteLine("\nManipulación de bits");
            Console.WriteLine("1. Establecer bit (SET)");
            Console.WriteLine("2. Borrar bit (CLEAR)");
            Console.WriteLine("3. Alternar bit (TOGGLE)");
            Console.WriteLine("4. Salir");
            Console.Write("Seleccione una opción: ");

            // Leer opción
            opcion = int.Parse(Console.ReadLine());

            // Verificar si se quiere salir
            if (opcion == 4)
                break;

            // Leer número
            Console.Write("Ingrese el número: ");
            numero = int.Parse(Console.ReadLine());

            // Leer posición del bit
            Console.Write("Ingrese la posición del bit (0-31): ");
            posicion = int.Parse(Console.ReadLine());

            // Realizar la operación según la opción seleccionada
            switch (opcion)
            {
                case 1: // Establecer bit (SET)
                    resultado = EstablecerBit(numero, posicion);
                    break;
                case 2: // Borrar bit (CLEAR)
                    resultado = BorrarBit(numero, posicion);
                    break;
                case 3: // Alternar bit (TOGGLE)
                    resultado = AlternarBit(numero, posicion);
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

    static int EstablecerBit(int numero, int posicion)
    {
        return numero | (1 << posicion); // Establecer el bit en la posición dada
    }

    static int BorrarBit(int numero, int posicion)
    {
        return numero & ~(1 << posicion); // Borrar el bit en la posición dada
    }

    static int AlternarBit(int numero, int posicion)
    {
        return numero ^ (1 << posicion); // Alternar el bit en la posición dada
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
