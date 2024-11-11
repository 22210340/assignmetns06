//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que encuentra el prefijo común
// más largo entre varias cadenas
// VIDEO: https://asciinema.org/a/zExf9WmOOIAo1uw5eMEppFxfH
//************************************************
.data
msg_bienvenida: .string "\n=== BUSCADOR DE PREFIJO COMÚN MÁS LARGO ===\n"
msg_cantidad: .string "¿Cuántas cadenas desea comparar? (2-10): "
msg_ingresar: .string "Ingrese la cadena %d: "
msg_resultado: .string "\nEl prefijo común más largo es: \"%s\"\n"
msg_no_prefijo: .string "\nNo hay prefijo común entre las cadenas.\n"
msg_error_cant: .string "Error: Ingrese una cantidad entre 2 y 10\n"
formato_str: .string "%s"
formato_int: .string "%d"
nueva_linea: .string "\n"
// Buffer para almacenar las cadenas
buffer: .space 1024        // Espacio para todas las cadenas
prefijo: .space 100        // Espacio para el prefijo común
cantidad: .word 0
max_cadenas: .word 10      // Máximo número de cadenas
max_longitud: .word 100    // Máxima longitud por cadena
// Array de punteros a las cadenas
cadenas: .space 80         // 10 punteros * 8 bytes

.text
.global main
.align 2
main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Mostrar bienvenida
    adr x0, msg_bienvenida
    bl printf
    
solicitar_cantidad:
    // Solicitar cantidad de cadenas
    adr x0, msg_cantidad
    bl printf
    
    adr x0, formato_int
    adr x1, cantidad
    bl scanf
    
    // Limpiar buffer de entrada
    mov w0, #0
    bl getchar
    
    // Verificar rango válido (2-10)
    adr x0, cantidad
    ldr w19, [x0]        // w19 = cantidad de cadenas
    cmp w19, #2
    b.lt cantidad_invalida
    adr x0, max_cadenas
    ldr w0, [x0]
    cmp w19, w0
    b.gt cantidad_invalida
    
    // Inicializar variables
    mov w20, #0          // Contador de cadenas
    adr x21, cadenas     // Array de punteros
    adr x22, buffer      // Buffer para cadenas
    
leer_cadenas:
    // Mostrar prompt
    adr x0, msg_ingresar
    add w1, w20, #1
    bl printf
    
    // Guardar puntero actual
    str x22, [x21, x20, lsl #3]
    
    // Leer cadena usando scanf
    adr x0, formato_str
    mov x1, x22
    bl scanf
    
    // Limpiar buffer de entrada
    mov w0, #0
    bl getchar
    
    // Buscar el final de la cadena
    mov x0, x22
buscar_fin:
    ldrb w1, [x0]
    cbz w1, siguiente_cadena
    add x0, x0, #1
    b buscar_fin
    
siguiente_cadena:
    add x22, x22, #1     // Saltar el null terminator
    add w20, w20, #1
    cmp w20, w19
    b.lt leer_cadenas
    
    // Encontrar prefijo común
    adr x23, prefijo     // Buffer para prefijo
    mov w24, #0          // Posición actual
    
comparar_caracteres:
    // Obtener carácter de primera cadena
    ldr x0, [x21]        // Primera cadena
    ldrb w25, [x0, x24]  // Carácter a comparar
    cbz w25, fin_prefijo // Si es null, terminar
    
    // Comparar con resto de cadenas
    mov w20, #1          // Iniciar desde segunda cadena
comparar_loop:
    cmp w20, w19
    b.ge guardar_caracter
    
    ldr x0, [x21, x20, lsl #3]
    ldrb w26, [x0, x24]
    
    // Comparar caracteres
    cmp w25, w26
    b.ne fin_prefijo
    
    add w20, w20, #1
    b comparar_loop
    
guardar_caracter:
    // Guardar carácter en prefijo
    strb w25, [x23, x24]
    add w24, w24, #1
    b comparar_caracteres
    
fin_prefijo:
    // Terminar string
    strb wzr, [x23, x24]
    
    // Verificar si hay prefijo
    cmp w24, #0
    b.eq no_hay_prefijo
    
    // Mostrar resultado
    adr x0, msg_resultado
    adr x1, prefijo
    bl printf
    b fin_programa
    
cantidad_invalida:
    adr x0, msg_error_cant
    bl printf
    b solicitar_cantidad
    
no_hay_prefijo:
    adr x0, msg_no_prefijo
    bl printf
    
fin_programa:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret




//c#

/*using System;

class BuscadorPrefijoComun
{
    static void Main()
    {
        Console.WriteLine("\n=== BUSCADOR DE PREFIJO COMÚN MÁS LARGO ===");

        // Solicitar la cantidad de cadenas
        int cantidad;
        while (true)
        {
            Console.Write("¿Cuántas cadenas desea comparar? (2-10): ");
            if (int.TryParse(Console.ReadLine(), out cantidad) && cantidad >= 2 && cantidad <= 10)
                break;
            Console.WriteLine("Error: Ingrese una cantidad entre 2 y 10.");
        }

        // Leer las cadenas y almacenarlas en un arreglo
        string[] cadenas = new string[cantidad];
        for (int i = 0; i < cantidad; i++)
        {
            Console.Write($"Ingrese la cadena {i + 1}: ");
            cadenas[i] = Console.ReadLine();
        }

        // Encontrar el prefijo común más largo
        string prefijoComun = EncontrarPrefijoComun(cadenas);

        // Mostrar el resultado
        if (prefijoComun.Length > 0)
        {
            Console.WriteLine($"\nEl prefijo común más largo es: \"{prefijoComun}\"");
        }
        else
        {
            Console.WriteLine("\nNo hay prefijo común entre las cadenas.");
        }
    }

    // Función para encontrar el prefijo común más largo
    static string EncontrarPrefijoComun(string[] cadenas)
    {
        if (cadenas.Length == 0) return "";

        string prefijo = cadenas[0];

        for (int i = 1; i < cadenas.Length; i++)
        {
            int j = 0;
            // Compara el prefijo con la siguiente cadena
            while (j < prefijo.Length && j < cadenas[i].Length && prefijo[j] == cadenas[i][j])
            {
                j++;
            }
            // Reduce el prefijo hasta donde coinciden todos
            prefijo = prefijo.Substring(0, j);

            // Si el prefijo es vacío, no hay prefijo común
            if (prefijo == "")
                return "";
        }

        return prefijo;
    }
}
*/
