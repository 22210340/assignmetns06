//************************************************
// Autor: Kevin Rivas/IA Claude
// Descripción: Implementación de una cola usando un arreglo
//************************************************

.data
    msg_menu: 
        .string "\nOperaciones de Cola\n"
        .string "1. Enqueue (Insertar)\n"
        .string "2. Dequeue (Eliminar)\n"
        .string "3. Peek (Ver frente)\n"
        .string "4. Mostrar cola\n"
        .string "5. Salir\n"
        .string "Seleccione una opción: "
    
    msg_enq: .string "Ingrese valor a insertar: "
    msg_deq: .string "Elemento eliminado: %d\n"
    msg_peek: .string "Elemento al frente: %d\n"
    msg_empty: .string "La cola está vacía\n"
    msg_full: .string "La cola está llena\n"
    msg_queue: .string "Contenido de la cola: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Cola y variables
    queue: .skip 40       // Espacio para 10 elementos (4 bytes c/u)
    queue_size: .word 10  // Tamaño máximo de la cola
    front: .word -1       // Índice del frente
    rear: .word -1        // Índice del final
    opcion: .word 0
    valor: .word 0

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
    
    cmp w0, #5
    b.eq fin_programa
    
    cmp w0, #1
    b.eq enqueue
    
    cmp w0, #2
    b.eq dequeue
    
    cmp w0, #3
    b.eq peek_elemento
    
    cmp w0, #4
    b.eq mostrar_cola
    
    b menu_loop

enqueue:
    // Verificar si la cola está llena
    adr x20, rear
    ldr w21, [x20]
    adr x22, queue_size
    ldr w22, [x22]
    sub w22, w22, #1
    
    cmp w21, w22
    b.ge cola_llena
    
    // Leer valor a insertar
    adr x0, msg_enq
    bl printf
    adr x0, formato_int
    adr x1, valor
    bl scanf
    
    // Si es el primer elemento
    adr x20, front
    ldr w23, [x20]
    cmp w23, #-1
    b.ne continuar_enq
    mov w23, #0
    str w23, [x20]
    
continuar_enq:
    // Incrementar rear y guardar valor
    adr x20, rear
    ldr w21, [x20]
    add w21, w21, #1
    str w21, [x20]
    
    adr x20, queue
    adr x22, valor
    ldr w22, [x22]
    str w22, [x20, w21, SXTW #2]
    
    b menu_loop

dequeue:
    // Verificar si la cola está vacía
    adr x20, front
    ldr w21, [x20]
    cmp w21, #-1
    b.eq cola_vacia
    
    // Obtener elemento del frente
    adr x20, queue
    ldr w22, [x20, w21, SXTW #2]
    
    // Mostrar elemento eliminado
    adr x0, msg_deq
    mov w1, w22
    bl printf
    
    // Actualizar índices
    adr x20, front
    adr x23, rear
    ldr w24, [x23]
    
    cmp w21, w24
    b.eq vaciar_cola
    
    add w21, w21, #1
    str w21, [x20]
    b menu_loop

vaciar_cola:
    mov w21, #-1
    adr x20, front
    str w21, [x20]
    adr x20, rear
    str w21, [x20]
    b menu_loop

peek_elemento:
    // Verificar si la cola está vacía
    adr x20, front
    ldr w21, [x20]
    cmp w21, #-1
    b.eq cola_vacia
    
    // Mostrar elemento del frente
    adr x20, queue
    ldr w22, [x20, w21, SXTW #2]
    adr x0, msg_peek
    mov w1, w22
    bl printf
    
    b menu_loop

mostrar_cola:
    // Verificar si la cola está vacía
    adr x20, front
    ldr w21, [x20]
    cmp w21, #-1
    b.eq cola_vacia
    
    // Mostrar mensaje
    adr x0, msg_queue
    bl printf
    
    // Mostrar elementos
    adr x20, queue
    adr x23, rear
    ldr w23, [x23]

mostrar_loop:
    ldr w1, [x20, w21, SXTW #2]
    adr x0, msg_num
    bl printf
    
    add w21, w21, #1
    cmp w21, w23
    b.le mostrar_loop
    
    adr x0, msg_newline
    bl printf
    b menu_loop

cola_vacia:
    adr x0, msg_empty
    bl printf
    b menu_loop

cola_llena:
    adr x0, msg_full
    bl printf
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret

//C#
 /*using System;

class QueueProgram
{
    // Mensajes del menú y mensajes informativos
    static readonly string msgMenu = "\nOperaciones de Cola\n" +
                                     "1. Enqueue (Insertar)\n" +
                                     "2. Dequeue (Eliminar)\n" +
                                     "3. Peek (Ver frente)\n" +
                                     "4. Mostrar cola\n" +
                                     "5. Salir\n" +
                                     "Seleccione una opción: ";
    static readonly string msgEnqueue = "Ingrese valor a insertar: ";
    static readonly string msgDequeue = "Elemento eliminado: {0}\n";
    static readonly string msgPeek = "Elemento al frente: {0}\n";
    static readonly string msgEmpty = "La cola está vacía\n";
    static readonly string msgFull = "La cola está llena\n";
    static readonly string msgQueue = "Contenido de la cola: ";
    static readonly string msgNewline = "\n";

    // Cola y variables
    static int queueSize = 10;
    static int[] queue = new int[queueSize];
    static int front = -1;
    static int rear = -1;

    static void Main()
    {
        while (true)
        {
            // Mostrar menú
            Console.Write(msgMenu);
            int opcion = int.Parse(Console.ReadLine());

            switch (opcion)
            {
                case 1:
                    Enqueue();
                    break;
                case 2:
                    Dequeue();
                    break;
                case 3:
                    Peek();
                    break;
                case 4:
                    MostrarCola();
                    break;
                case 5:
                    Console.WriteLine("Saliendo del programa...");
                    return;
                default:
                    Console.WriteLine("Opción inválida, intente nuevamente.");
                    break;
            }
        }
    }

    static void Enqueue()
    {
        // Verificar si la cola está llena
        if (rear == queueSize - 1)
        {
            Console.WriteLine(msgFull);
            return;
        }

        // Leer valor a insertar
        Console.Write(msgEnqueue);
        int valor = int.Parse(Console.ReadLine());

        // Si es el primer elemento
        if (front == -1)
        {
            front = 0;
        }

        // Incrementar rear y guardar valor
        rear++;
        queue[rear] = valor;
    }

    static void Dequeue()
    {
        // Verificar si la cola está vacía
        if (front == -1 || front > rear)
        {
            Console.WriteLine(msgEmpty);
            return;
        }

        // Obtener y mostrar el elemento eliminado
        int eliminado = queue[front];
        Console.WriteLine(msgDequeue, eliminado);

        // Actualizar índices
        front++;
        if (front > rear)
        {
            front = -1;
            rear = -1;
        }
    }

    static void Peek()
    {
        // Verificar si la cola está vacía
        if (front == -1)
        {
            Console.WriteLine(msgEmpty);
            return;
        }

        // Mostrar el elemento al frente
        Console.WriteLine(msgPeek, queue[front]);
    }

    static void MostrarCola()
    {
        // Verificar si la cola está vacía
        if (front == -1)
        {
            Console.WriteLine(msgEmpty);
            return;
        }

        // Mostrar los elementos de la cola
        Console.Write(msgQueue);
        for (int i = front; i <= rear; i++)
        {
            Console.Write(queue[i] + " ");
        }
        Console.WriteLine(msgNewline);
    }
}
*/
