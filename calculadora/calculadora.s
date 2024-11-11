//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Calculadora simple que realiza
// operaciones básicas (suma, resta, multiplicación, división)
// VIDEO: https://asciinema.org/a/Df2O4ojkWfN4jPeIRJBtiqpe8
//************************************************

.data
menu:      .string "\n=== CALCULADORA SIMPLE ===\n"
           .string "1. Suma\n"
           .string "2. Resta\n"
           .string "3. Multiplicación\n"
           .string "4. División\n"
           .string "5. Salir\n"
           .string "Seleccione una opción: "

msg_num1:  .string "Ingrese el primer número: "
msg_num2:  .string "Ingrese el segundo número: "
msg_resultado: .string "Resultado: %d\n"
msg_div_resultado: .string "Resultado: %d (Cociente: %d, Residuo: %d)\n"
msg_error_div: .string "Error: No se puede dividir por cero\n"
msg_error_op: .string "Error: Opción inválida\n"
msg_despedida: .string "¡Gracias por usar la calculadora!\n"
formato_int: .string "%d"
num1: .word 0
num2: .word 0
opcion: .word 0

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

menu_loop:
    // Mostrar menú
    adr x0, menu
    bl printf
    
    // Leer opción
    adr x0, formato_int
    adr x1, opcion
    bl scanf
    
    // Cargar opción en w19
    adr x0, opcion
    ldr w19, [x0]
    
    // Verificar si es salir (opción 5)
    cmp w19, #5
    b.eq salir
    
    // Verificar opción válida (1-4)
    cmp w19, #1
    b.lt opcion_invalida
    cmp w19, #4
    b.gt opcion_invalida
    
    // Solicitar números
    adr x0, msg_num1
    bl printf
    adr x0, formato_int
    adr x1, num1
    bl scanf
    
    adr x0, msg_num2
    bl printf
    adr x0, formato_int
    adr x1, num2
    bl scanf
    
    // Cargar números en registros
    adr x0, num1
    ldr w20, [x0]    // Primer número en w20
    adr x0, num2
    ldr w21, [x0]    // Segundo número en w21
    
    // Saltar a la operación correspondiente
    cmp w19, #1
    b.eq suma
    cmp w19, #2
    b.eq resta
    cmp w19, #3
    b.eq multiplicacion
    b division

suma:
    add w22, w20, w21
    b mostrar_resultado

resta:
    sub w22, w20, w21
    b mostrar_resultado

multiplicacion:
    mul w22, w20, w21
    b mostrar_resultado

division:
    // Verificar división por cero
    cmp w21, #0
    b.eq error_division
    
    // Realizar división
    sdiv w22, w20, w21    // Cociente
    msub w23, w22, w21, w20  // Residuo
    
    // Mostrar resultado con cociente y residuo
    adr x0, msg_div_resultado
    mov w1, w22           // Resultado
    mov w2, w22           // Cociente
    mov w3, w23           // Residuo
    bl printf
    b menu_loop

mostrar_resultado:
    adr x0, msg_resultado
    mov w1, w22
    bl printf
    b menu_loop

error_division:
    adr x0, msg_error_div
    bl printf
    b menu_loop

opcion_invalida:
    adr x0, msg_error_op
    bl printf
    b menu_loop

salir:
    adr x0, msg_despedida
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//C# 
/*using System;

class CalculadoraSimple
{
    static void Main()
    {
        bool continuar = true;

        while (continuar)
        {
            // Mostrar menú
            Console.WriteLine("\n=== CALCULADORA SIMPLE ===");
            Console.WriteLine("1. Suma");
            Console.WriteLine("2. Resta");
            Console.WriteLine("3. Multiplicación");
            Console.WriteLine("4. División");
            Console.WriteLine("5. Salir");
            Console.Write("Seleccione una opción: ");

            // Leer opción
            if (!int.TryParse(Console.ReadLine(), out int opcion))
            {
                Console.WriteLine("Error: Opción inválida\n");
                continue;
            }

            // Verificar opción de salida
            if (opcion == 5)
            {
                Console.WriteLine("¡Gracias por usar la calculadora!");
                break;
            }

            // Validar opción (1-4)
            if (opcion < 1 || opcion > 4)
            {
                Console.WriteLine("Error: Opción inválida\n");
                continue;
            }

            // Solicitar números
            Console.Write("Ingrese el primer número: ");
            if (!int.TryParse(Console.ReadLine(), out int num1))
            {
                Console.WriteLine("Error: Entrada inválida para el primer número\n");
                continue;
            }

            Console.Write("Ingrese el segundo número: ");
            if (!int.TryParse(Console.ReadLine(), out int num2))
            {
                Console.WriteLine("Error: Entrada inválida para el segundo número\n");
                continue;
            }

            // Realizar la operación correspondiente
            switch (opcion)
            {
                case 1: // Suma
                    Console.WriteLine("Resultado: {0}\n", num1 + num2);
                    break;
                case 2: // Resta
                    Console.WriteLine("Resultado: {0}\n", num1 - num2);
                    break;
                case 3: // Multiplicación
                    Console.WriteLine("Resultado: {0}\n", num1 * num2);
                    break;
                case 4: // División
                    if (num2 == 0)
                    {
                        Console.WriteLine("Error: No se puede dividir por cero\n");
                    }
                    else
                    {
                        int cociente = num1 / num2;
                        int residuo = num1 % num2;
                        Console.WriteLine("Resultado: {0} (Cociente: {1}, Residuo: {2})\n", cociente, cociente, residuo);
                    }
                    break;
            }
        }
    }
}
*/
