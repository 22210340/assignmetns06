// *********************************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa en ensamblador ARM64 que solicita dos números  
//              al usuario y realiza la resta entre ellos, mostrando
//              el resultado en pantalla.
// *********************************************************************

.global _start

.data
    msg1:       .ascii "Ingrese primer número: "
    len1 = . - msg1
    msg2:       .ascii "Ingrese segundo número: "
    len2 = . - msg2
    msgResult:  .ascii "La resta es: "
    lenResult = . - msgResult
    newline:    .ascii "\n"
    buffer:     .skip 12
    num1:       .quad 0
    num2:       .quad 0

.text
_start:
    // Mostrar mensaje para primer número
    mov x0, #1              // fd = 1 (stdout)
    adr x1, msg1           // dirección del mensaje
    mov x2, len1           // longitud del mensaje
    mov x8, #64            // syscall write
    svc #0

    // Leer primer número
    mov x0, #0              // fd = 0 (stdin)
    adr x1, buffer         // buffer para almacenar entrada
    mov x2, #12            // tamaño máximo a leer
    mov x8, #63            // syscall read
    svc #0
    
    // Convertir primer número de ASCII a entero
    adr x1, buffer
    bl ascii_to_int
    adr x1, num1
    str x0, [x1]           // Guardar primer número

    // Mostrar mensaje para segundo número
    mov x0, #1
    adr x1, msg2
    mov x2, len2
    mov x8, #64
    svc #0

    // Leer segundo número
    mov x0, #0
    adr x1, buffer
    mov x2, #12
    mov x8, #63
    svc #0

    // Convertir segundo número de ASCII a entero
    adr x1, buffer
    bl ascii_to_int
    adr x1, num2
    str x0, [x1]           // Guardar segundo número

    // Realizar la resta
    adr x1, num1
    ldr x2, [x1]           // Cargar primer número
    adr x1, num2
    ldr x3, [x1]           // Cargar segundo número
    sub x4, x2, x3         // Restar números (num1 - num2)

    // Mostrar mensaje de resultado
    mov x0, #1
    adr x1, msgResult
    mov x2, lenResult
    mov x8, #64
    svc #0

    // Convertir resultado a ASCII y mostrarlo
    mov x5, x4              // Copiar resultado para convertir
    // Verificar si el resultado es negativo
    cmp x5, #0
    bge positive_num
    
    // Si es negativo, mostrar el signo menos
    mov x0, #1
    adr x1, minus
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Convertir el número a positivo para mostrarlo
    neg x5, x5

positive_num:
    adr x6, buffer         // Buffer para resultado
    mov x7, #0             // Contador de dígitos

convert_loop:
    mov x9, #10            // Divisor (base 10)
    udiv x10, x5, x9       // Dividir entre 10
    msub x11, x10, x9, x5  // Obtener residuo
    add x11, x11, #48      // Convertir a ASCII
    strb w11, [x6, x7]     // Guardar dígito
    add x7, x7, #1         // Incrementar contador
    mov x5, x10            // Preparar siguiente iteración
    cbnz x5, convert_loop

    // Invertir los dígitos
    mov x9, #0             // Índice inicio
    sub x10, x7, #1        // Índice final
reverse_loop:
    cmp x9, x10
    bge end_reverse
    ldrb w11, [x6, x9]
    ldrb w12, [x6, x10]
    strb w12, [x6, x9]
    strb w11, [x6, x10]
    add x9, x9, #1
    sub x10, x10, #1
    b reverse_loop

end_reverse:
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

.data
    minus: .ascii "-"      // Signo menos para números negativos
