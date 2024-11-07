// *********************************************************************
// Autor: Rivas Perez Kevin /CHATGPT
// Descripción: Conversión de temperatura de Celsius a Fahrenheit (aproximado a entero)
// Fórmula en C/C++: 
//    float celsius = 25.0;
//    int fahrenheit = (int)((celsius * 9.0 / 5.0) + 32.0);
// *********************************************************************


.global _start

.data
    celsius:     .double 25.0           // Temperatura en Celsius a convertir
    const_9:     .double 9.0            // Constante 9 para la fórmula
    const_5:     .double 5.0            // Constante 5 para la fórmula
    const_32:    .double 32.0           // Constante 32 para la fórmula
    msg1:        .ascii "Fahrenheit: "   // Mensaje para mostrar
    len1 = . - msg1
    newline:     .ascii "\n"            // Carácter de nueva línea
    buffer:      .skip 20               // Buffer para convertir el número a texto

.text
_start:
    // Mostrar mensaje inicial
    mov x0, #1              // fd = 1 (stdout)
    adr x1, msg1           // dirección del mensaje
    mov x2, #len1          // longitud del mensaje
    mov x8, #64            // syscall write
    svc #0

    // Cargar la temperatura en Celsius en d0
    adr x0, celsius
    ldr d0, [x0]
    
    // Cargar constante 9 en d1
    adr x0, const_9
    ldr d1, [x0]
    
    // Cargar constante 5 en d2
    adr x0, const_5
    ldr d2, [x0]
    
    // Cargar constante 32 en d3
    adr x0, const_32
    ldr d3, [x0]
    
    // Realizar la conversión: (C × 9/5) + 32
    fmul d4, d0, d1       // C × 9
    fdiv d4, d4, d2       // (C × 9)/5
    fadd d4, d4, d3       // (C × 9/5) + 32

    // Convertir el resultado a entero para mostrarlo
    fcvtas x5, d4         // Convertir float a entero con redondeo

    // Convertir el entero a ASCII para mostrarlo
    adr x6, buffer        // Dirección del buffer
    mov x7, #0            // Contador de dígitos
    mov x8, #10           // Divisor (base 10)

convert_loop:
    udiv x9, x5, x8       // Dividir entre 10
    msub x10, x9, x8, x5  // Obtener el residuo (dígito actual)
    add x10, x10, #48     // Convertir a ASCII
    strb w10, [x6, x7]    // Guardar el dígito
    add x7, x7, #1        // Incrementar contador
    mov x5, x9            // Preparar para siguiente iteración
    cbnz x5, convert_loop // Si quedan dígitos, continuar

    // Invertir los dígitos en el buffer
    mov x9, #0            // Índice inicio
    sub x10, x7, #1       // Índice final
reverse_loop:
    cmp x9, x10
    bge end_reverse
    ldrb w11, [x6, x9]    // Cargar byte del inicio
    ldrb w12, [x6, x10]   // Cargar byte del final
    strb w12, [x6, x9]    // Guardar byte del final al inicio
    strb w11, [x6, x10]   // Guardar byte del inicio al final
    add x9, x9, #1
    sub x10, x10, #1
    b reverse_loop

end_reverse:
    // Mostrar el resultado
    mov x0, #1            // fd = 1 (stdout)
    mov x1, x6            // dirección del buffer
    mov x2, x7            // longitud del número
    mov x8, #64           // syscall write
    svc #0

    // Mostrar nueva línea
    mov x0, #1            // fd = 1 (stdout)
    adr x1, newline       // dirección de nueva línea
    mov x2, #1            // longitud de nueva línea
    mov x8, #64           // syscall write
    svc #0

    // Salir del programa
    mov x8, #93           // syscall exit
    mov x0, #0            // código de salida 0
    svc #0
