//************************************************
// Autor: Rivas Perez Kevin/IA Claude
// Descripción: Programa que genera la serie de Fibonacci hasta el n-ésimo término
// ingresado por el usuario. La serie de Fibonacci es una secuencia donde cada
// número es la suma de los dos anteriores, comenzando con 0 y 1.
// Ejemplo: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
//************************************************

.data
msg1:    .string "Ingrese el numero de terminos de Fibonacci a generar (1-47): "
msg2:    .string "Serie de Fibonacci hasta el termino %d:\n"
msg3:    .string "%d, "             // Para imprimir números con coma
msg4:    .string "%d\n"             // Para el último número
fmt:     .string "%d"
numero:  .word 0

.text
.global main

main:
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Imprimir mensaje solicitando número
    adr     x0, msg1
    bl      printf

    // Leer número del usuario
    adr     x0, fmt
    adr     x1, numero
    bl      scanf

    // Imprimir mensaje inicial
    adr     x0, msg2
    adr     x1, numero
    ldr     w1, [x1]
    bl      printf

    // Inicializar variables
    mov     x19, xzr                // x19 = 0 (primer número)
    mov     x20, #1                 // x20 = 1 (segundo número)
    mov     x21, xzr                // x21 = 0 (contador)
    adr     x22, numero
    ldr     w22, [x22]              // x22 = n (número de términos)

fibonacci_loop:
    // Verificar si hemos terminado
    cmp     x21, x22
    bge     end_program

    // Imprimir número actual
    cmp     x21, x22
    beq     print_last              // Si es el último, no imprimir coma

    // Imprimir con coma
    adr     x0, msg3
    mov     x1, x19
    bl      printf

    // Calcular siguiente número
    mov     x23, x20                // Temporal = segundo
    add     x20, x19, x20           // segundo = primero + segundo
    mov     x19, x23                // primero = temporal

    // Incrementar contador
    add     x21, x21, #1
    b       fibonacci_loop

print_last:
    // Imprimir último número sin coma
    adr     x0, msg4
    mov     x1, x19
    bl      printf

end_program:
    // Restaurar y retornar
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
