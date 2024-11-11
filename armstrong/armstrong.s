//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que verifica si un número es
// Armstrong (ej: 153 = 1^3 + 5^3 + 3^3)
// VIDEO: https://asciinema.org/a/WT05OdM5SMw5HuqPv6eEk607S
//************************************************

.data
msg_input: .string "Ingrese un número para verificar si es Armstrong: "
msg_es_armstrong: .string "¡%d ES un número Armstrong!\n"
msg_no_armstrong: .string "%d NO es un número Armstrong.\n"
msg_explicacion: .string "Un número Armstrong es igual a la suma de sus dígitos\n"
                .string "elevados a la potencia de la cantidad de dígitos.\n"
                .string "Ejemplo: 153 = 1^3 + 5^3 + 3^3 = 1 + 125 + 27\n\n"
msg_desglose: .string "Desglose de %d:\n"
msg_digito: .string "Dígito %d elevado a %d = %d\n"
msg_suma: .string "Suma total = %d\n\n"
formato_int: .string "%d"
numero: .word 0

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -48]!
    mov x29, sp
    
    // Mostrar explicación
    adr x0, msg_explicacion
    bl printf
    
    // Solicitar número
    adr x0, msg_input
    bl printf
    
    adr x0, formato_int
    adr x1, numero
    bl scanf
    
    // Cargar número en w19
    adr x0, numero
    ldr w19, [x0]
    mov w20, w19    // Copia para contar dígitos
    
    // Contar dígitos
    mov w21, #0     // Contador de dígitos
    mov w22, #10    // Divisor
contar_digitos:
    udiv w23, w20, w22    // Dividir por 10
    add w21, w21, #1      // Incrementar contador
    mov w20, w23          // Actualizar número
    cbnz w20, contar_digitos
    
    // Mostrar desglose
    adr x0, msg_desglose
    mov w1, w19
    bl printf
    
    // Calcular suma de potencias
    mov w20, w19    // Restaurar número original
    mov w22, #0     // Suma total
    mov w23, #10    // Divisor
    mov w24, #0     // Contador de posición actual
calcular_suma:
    // Obtener último dígito
    udiv w25, w20, w23    // División por 10
    msub w26, w25, w23, w20   // Residuo (dígito actual)
    
    // Calcular potencia
    mov w27, #1     // Resultado de la potencia
    mov w28, w21    // Exponente (cantidad de dígitos)
calcular_potencia:
    cbz w28, fin_potencia
    mul w27, w27, w26     // Multiplicar por el dígito
    sub w28, w28, #1
    b calcular_potencia
fin_potencia:
    // Mostrar cálculo del dígito
    stp w22, w20, [sp, #16]   // Guardar registros
    adr x0, msg_digito
    mov w1, w26            // Dígito
    mov w2, w21            // Exponente
    mov w3, w27            // Resultado
    bl printf
    ldp w22, w20, [sp, #16]   // Restaurar registros
    
    // Sumar al total
    add w22, w22, w27
    
    // Preparar siguiente dígito
    udiv w20, w20, w23
    cbnz w20, calcular_suma
    
    // Mostrar suma total
    adr x0, msg_suma
    mov w1, w22
    bl printf
    
    // Verificar si es Armstrong
    cmp w22, w19
    b.ne no_es_armstrong
    
    // Es Armstrong
    adr x0, msg_es_armstrong
    mov w1, w19
    bl printf
    b fin_programa
    
no_es_armstrong:
    adr x0, msg_no_armstrong
    mov w1, w19
    bl printf
    
fin_programa:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 48
    ret

//C#

/*using System;

class NumeroArmstrong
{
    static void Main()
    {
        // Mostrar explicación
        Console.WriteLine("Un número Armstrong es igual a la suma de sus dígitos");
        Console.WriteLine("elevados a la potencia de la cantidad de dígitos.");
        Console.WriteLine("Ejemplo: 153 = 1^3 + 5^3 + 3^3 = 1 + 125 + 27\n");

        // Solicitar número al usuario
        Console.Write("Ingrese un número para verificar si es Armstrong: ");
        if (!int.TryParse(Console.ReadLine(), out int numero) || numero < 0)
        {
            Console.WriteLine("Error: Debe ingresar un número entero positivo.");
            return;
        }

        // Contar los dígitos del número
        int cantidadDigitos = ContarDigitos(numero);
        
        // Mostrar desglose de cada dígito elevado a la potencia de cantidad de dígitos
        Console.WriteLine($"\nDesglose de {numero}:");
        int sumaTotal = CalcularSumaDePotencias(numero, cantidadDigitos);

        // Mostrar la suma total y verificar si es un número Armstrong
        Console.WriteLine($"Suma total = {sumaTotal}\n");
        if (sumaTotal == numero)
        {
            Console.WriteLine($"¡{numero} ES un número Armstrong!");
        }
        else
        {
            Console.WriteLine($"{numero} NO es un número Armstrong.");
        }
    }

    // Función para contar la cantidad de dígitos
    static int ContarDigitos(int num)
    {
        int contador = 0;
        while (num > 0)
        {
            num /= 10;
            contador++;
        }
        return contador;
    }

    // Función para calcular la suma de los dígitos elevados a la cantidad de dígitos
    static int CalcularSumaDePotencias(int num, int exponente)
    {
        int suma = 0;
        int temp = num;

        while (temp > 0)
        {
            int digito = temp % 10;
            int potencia = CalcularPotencia(digito, exponente);
            Console.WriteLine($"Dígito {digito} elevado a {exponente} = {potencia}");
            suma += potencia;
            temp /= 10;
        }
        return suma;
    }

    // Función para calcular potencia
    static int CalcularPotencia(int baseNum, int exponente)
    {
        int resultado = 1;
        for (int i = 0; i < exponente; i++)
        {
            resultado *= baseNum;
        }
        return resultado;
    }
}
*/
