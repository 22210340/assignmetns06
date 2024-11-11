//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que genera números aleatorios
// utilizando el método congruencial lineal
// Fórmula: siguiente = (multiplicador * actual + incremento) % módulo
// VIDEO: https://asciinema.org/a/wvXjeCelBvO2ob3YjgGm9IYT9
//************************************************

.data
msg_menu: .string "\n=== GENERADOR DE NÚMEROS ALEATORIOS ===\n"
          .string "1. Establecer semilla\n"
          .string "2. Generar número aleatorio\n"
          .string "3. Generar serie de números\n"
          .string "4. Salir\n"
          .string "Seleccione una opción: "

msg_semilla: .string "Ingrese la semilla (número entero positivo): "
msg_cantidad: .string "¿Cuántos números desea generar?: "
msg_rango: .string "Rango del número aleatorio: 0 a %d\n"
msg_numero: .string "Número aleatorio generado: %d\n"
msg_error: .string "Error: Ingrese un valor válido\n"
msg_despedida: .string "¡Gracias por usar el generador!\n"

formato_int: .string "%d"
nueva_linea: .string "\n"

// Variables para el generador
semilla: .word 12345    // Semilla por defecto
multiplicador: .word 1103515245  // Valores del generador congruencial
incremento: .word 12345
modulo: .word 2147483647  // 2^31 - 1

// Variables de uso general
opcion: .word 0
cantidad: .word 0
temp: .word 0

.text
.global main
.align 2

main:
    // Prólogo
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
    
    // Cargar opción
    adr x0, opcion
    ldr w19, [x0]
    
    // Procesar opción
    cmp w19, #1
    b.eq establecer_semilla
    cmp w19, #2
    b.eq generar_uno
    cmp w19, #3
    b.eq generar_serie
    cmp w19, #4
    b.eq salir
    
    // Opción inválida
    adr x0, msg_error
    bl printf
    b menu_loop

establecer_semilla:
    // Solicitar nueva semilla
    adr x0, msg_semilla
    bl printf
    
    adr x0, formato_int
    adr x1, semilla
    bl scanf
    
    b menu_loop

generar_uno:
    // Generar un solo número
    bl generar_aleatorio
    
    // Mostrar número generado
    adr x0, msg_numero
    mov w1, w0
    bl printf
    
    b menu_loop

generar_serie:
    // Solicitar cantidad
    adr x0, msg_cantidad
    bl printf
    
    adr x0, formato_int
    adr x1, cantidad
    bl scanf
    
    // Cargar cantidad en w20
    adr x0, cantidad
    ldr w20, [x0]
    
    // Verificar cantidad válida
    cmp w20, #0
    b.le menu_loop
    
generar_loop:
    // Guardar registros
    stp x20, x30, [sp, -16]!
    
    // Generar número
    bl generar_aleatorio
    
    // Mostrar número
    adr x0, msg_numero
    mov w1, w0
    bl printf
    
    // Restaurar registros
    ldp x20, x30, [sp], 16
    
    // Decrementar contador y continuar si no es cero
    subs w20, w20, #1
    b.ne generar_loop
    
    b menu_loop

generar_aleatorio:
    // Implementación del generador congruencial lineal
    // siguiente = (multiplicador * semilla + incremento) % modulo
    
    // Cargar valores
    adr x0, semilla
    ldr w1, [x0]
    adr x0, multiplicador
    ldr w2, [x0]
    adr x0, incremento
    ldr w3, [x0]
    adr x0, modulo
    ldr w4, [x0]
    
    // Realizar cálculos
    mul w5, w1, w2      // multiplicador * semilla
    add w5, w5, w3      // + incremento
    udiv w6, w5, w4     // división para el módulo
    msub w5, w6, w4, w5 // obtener el residuo
    
    // Guardar nueva semilla
    adr x0, semilla
    str w5, [x0]
    
    // Retornar valor generado en w0
    mov w0, w5
    ret

salir:
    adr x0, msg_despedida
    bl printf
    
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//C#

/*using System;

class GeneradorAleatorio
{
    private static int semilla = 12345;         // Semilla por defecto
    private const int multiplicador = 1103515245;
    private const int incremento = 12345;
    private const int modulo = 2147483647;      // 2^31 - 1
    
    static void Main()
    {
        bool continuar = true;
        
        while (continuar)
        {
            // Mostrar menú
            Console.WriteLine("\n=== GENERADOR DE NÚMEROS ALEATORIOS ===");
            Console.WriteLine("1. Establecer semilla");
            Console.WriteLine("2. Generar número aleatorio");
            Console.WriteLine("3. Generar serie de números");
            Console.WriteLine("4. Salir");
            Console.Write("Seleccione una opción: ");
            
            // Leer opción
            if (!int.TryParse(Console.ReadLine(), out int opcion))
            {
                Console.WriteLine("Error: Ingrese un valor válido\n");
                continue;
            }
            
            switch (opcion)
            {
                case 1:
                    EstablecerSemilla();
                    break;
                
                case 2:
                    GenerarUno();
                    break;
                
                case 3:
                    GenerarSerie();
                    break;
                
                case 4:
                    Console.WriteLine("¡Gracias por usar el generador!");
                    continuar = false;
                    break;
                
                default:
                    Console.WriteLine("Error: Opción inválida\n");
                    break;
            }
        }
    }

    static void EstablecerSemilla()
    {
        Console.Write("Ingrese la semilla (número entero positivo): ");
        if (int.TryParse(Console.ReadLine(), out int nuevaSemilla) && nuevaSemilla > 0)
        {
            semilla = nuevaSemilla;
        }
        else
        {
            Console.WriteLine("Error: Ingrese un valor válido\n");
        }
    }

    static void GenerarUno()
    {
        int numeroAleatorio = GenerarAleatorio();
        Console.WriteLine($"Número aleatorio generado: {numeroAleatorio}");
    }

    static void GenerarSerie()
    {
        Console.Write("¿Cuántos números desea generar?: ");
        if (!int.TryParse(Console.ReadLine(), out int cantidad) || cantidad <= 0)
        {
            Console.WriteLine("Error: Ingrese un valor válido\n");
            return;
        }

        for (int i = 0; i < cantidad; i++)
        {
            int numeroAleatorio = GenerarAleatorio();
            Console.WriteLine($"Número aleatorio generado: {numeroAleatorio}");
        }
    }

    static int GenerarAleatorio()
    {
        // siguiente = (multiplicador * semilla + incremento) % modulo
        long producto = (long)multiplicador * semilla;
        semilla = (int)((producto + incremento) % modulo);
        return semilla;
    }
}
*/
