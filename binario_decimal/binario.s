//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Programa que convierte números 
// decimales a binario y binarios a decimal
//************************************************

.data
    msg_menu: 
        .string "\nConversor Decimal/Binario\n"
        .string "1. Convertir número Decimal a Binario\n"
        .string "2. Convertir número Binario a Decimal\n"
        .string "3. Salir\n"
        .string "Seleccione una opción: "
    
    msg_input_decimal: .string "Ingrese un número decimal (positivo): "
    msg_input_binary: .string "Ingrese un número binario (solo 0s y 1s): "
    msg_result_decimal: .string "El número en decimal es: %d\n"
    msg_result_binary: .string "El número %d en binario es: "
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
    
    cmp w0, #3
    b.eq fin_programa
    
    cmp w0, #1
    b.eq convertir_numero_decimal
    
    cmp w0, #2
    b.eq convertir_numero_binario
    
    b menu_loop

convertir_numero_decimal:
    // Solicitar número decimal
    adr x0, msg_input_decimal
    bl printf
    
    // Leer número decimal
    adr x0, formato_int
    adr x1, numero
    bl scanf
    
    // Verificar si es positivo
    adr x0, numero
    ldr w0, [x0]
    cmp w0, #0
    b.lt numero_negativo
    
    // Preparar para conversión decimal a binario
    mov w19, w0          // Guardar número original
    adr x20, binary      // Dirección del arreglo de bits
    mov w21, #0          // Contador de bits
    
    // Si el número es 0, manejo especial
    cmp w19, #0
    b.eq caso_cero

conversion_loop:
    // Verificar si el número es 0
    cmp w19, #0
    b.eq mostrar_resultado_decimal
    
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
    b mostrar_resultado_decimal

mostrar_resultado_decimal:
    // Guardar tamaño del binario
    adr x22, binary_size
    str w21, [x22]
    
    // Mostrar mensaje inicial
    adr x0, msg_result_binary
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

convertir_numero_binario:
    // Solicitar número binario
    adr x0, msg_input_binary
    bl printf
    
    // Leer número binario como string
    adr x0, formato_int
    adr x1, numero
    bl scanf
    
    mov w19, #0         // Acumulará el valor decimal
    mov w21, #0         // Posición del bit (izquierda a derecha)
    
verificar_bits:
    // Obtener cada bit del número binario ingresado
    adr x20, numero
    ldr w22, [x20, w21, SXTW #2]
    
    // Verificar si es 1 o 0
    cmp w22, #0
    b.eq bit_cero
    cmp w22, #1
    b.ne numero_negativo  // Si no es 0 o 1, es inválido
    
bit_uno:
    // Sumar valor del bit en posición
    lsl w23, #1

