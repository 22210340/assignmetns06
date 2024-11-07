//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que calcula el factorial de un número
// ingresado por el usuario. El factorial de un número n (n!)
// es el producto de todos los números enteros positivos desde 1 hasta n.
// Por ejemplo: 5! = 5 * 4 * 3 * 2 * 1 = 120
//************************************************

.data
msg1:    .string "Ingrese un numero para calcular su factorial (1-20): "
msg2:    .string "El factorial de %d es: %d\n"
fmt:     .string "%d"
numero:  .word 0
result:  .quad 0

.text
.global main

main:
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Imprimir mensaje solicitando número
    adr     x0, msg1
    bl      printf

    // Leer número del usuario
    adr     x0, fmt                  // Formato para scanf
    adr     x1, numero              // Dirección donde guardar el número
    bl      scanf

    // Cargar número ingresado en x0
    adr     x0, numero
    ldr     w0, [x0]                // w0 = número ingresado

    // Calcular factorial
    mov     x19, x0                 // Guardar número original
    mov     x1, #1                  // x1 será nuestro resultado
    
factorial_loop:
    cmp     x0, #1                  // Comparar con 1
    ble     print_result            // Si es <= 1, terminar
    mul     x1, x1, x0              // result = result * i
    sub     x0, x0, #1              // i--
    b       factorial_loop          // Repetir

print_result:
    // Imprimir resultado
    adr     x0, msg2
    mov     x2, x1                  // Segundo argumento: resultado
    mov     x1, x19                 // Primer argumento: número original
    bl      printf

    // Restaurar y retornar
    mov     w0, #0                  // Retornar 0
    ldp     x29, x30, [sp], 16      // Restaurar frame pointer y link register
    ret
