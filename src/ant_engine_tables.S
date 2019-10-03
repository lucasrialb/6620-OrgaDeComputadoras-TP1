#include <regdef.h>
#include "ant_constants.h"

.text #Comienzo new_orientation
.align 2
.globl new_orientation
.ent new_orientation

new_orientation:
    .frame fp, 8, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8         #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp,sp

    move t0, a0             #t0 <- orientation
    move t1, a1             #t1 <- rule
    la t2, rotation_rules   #t2 <- direccion al arreglo rotation_rules (pseudoinst)

    sll t3, t0, 1           #t3 <- orientation*2
    add t3, t3, t1          #t3 <- orientation*2 + rule (indice para rotation_rules)

    sll t3, t3, 2           # indice*4 para alinear a palabras
    add t4, t2, t3          #t4 <- rotation_rules + indice*4

    lw v0, 0(t4)            #vo <- rotation_rules[indice]

    lw gp, 0(sp)           #Destruir stack
    lw fp, 4(sp)
    addu sp, sp, 8
    jr ra                   #return

.end new_orientation


.text #Comienzo move_foward
.align 2
.globl move_forward
.ent move_forward
move_forward:
    .frame fp, 32, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 32         #Crear stack (SRA = 16, LTA = 0, ABA = 16)
    .cprestore 0
    sw gp, 16(sp)
    sw fp, 20(sp)
    sw ra, 24(sp)
    move fp, sp

    lw t2, 8(a0)            #t2 <- ant->o
    sll t2, t2, 2           #(ant->o)*4, sera indice de para arrays

    la t7, relevant_bounds  #t7 <- direccion del array con dimensiones del tablero
    add t7, t7, t2          #t7 <- t7 + indice
    lw a1, 0(t7)            #a1 <- relevant_bounds[indice]
    
    la t3, allowed_forward  #t3 <- direccion de allowed_forward
    add t3, t3, t2          #t3 <- t3 + indice
    lw t4, 0(t3)            #t4 <- allowed_forward[indice] (direccion del step)
    jalr t4                 #Ir a la funcion de la direccion que almacena t4

    move v0, a0             #return ant

    lw gp, 16(sp)           #Destruir stack
    lw fp, 20(sp)
    lw ra, 24(sp)
    addiu sp, sp, 32
    jr ra
.end move_forward

.ent step_north
step_north:
    .frame fp, 8, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8         #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp, sp

    lw t1, 4(a0)            #t1 <- ant->y
    subu t1, t1, 1          #t1 <- ant->y - 1
    rem t1, t1, a1          #t1 <- t1 % a1 (Para que no se vaya del tablero)
    sw t1, 4(a0)            #ant->y <- t1

    lw gp, 0(sp)           #Destruir stack
    lw fp, 4(sp)
    addiu sp, sp, 8
    jr ra
.end step_north

.ent step_south
step_south:
    .frame fp, 8, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8         #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp, sp

    lw t1, 4(a0)            #t1 <- ant->y
    addu t1, t1, 1          #t1 <- ant->y + 1
    rem t1, t1, a1          #t1 <- t1 % a1 (Para que no se vaya del tablero)
    sw t1, 4(a0)            #ant->y <- t1

    lw gp, 0(sp)           #Destruir stack
    lw fp, 4(sp)
    addiu sp, sp, 8
    jr ra    
.end step_south

.ent step_east
step_east:
    .frame fp, 8, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8         #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp, sp

    lw t0, 0(a0)            #t0 <- ant->x
    addu t0, t0, 1          #t0 <- ant->x + 1
    rem t1, t1, a1          #t1 <- t1 % a1 (Para que no se vaya del tablero)
    sw t0, 0(a0)            #ant->x <- t0

    lw gp, 0(sp)           #Destruir stack
    lw fp, 4(sp)
    addiu sp, sp, 8
    jr ra    
.end step_east

.ent step_west
step_west:
    .frame fp, 8, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8         #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp, sp

    lw t0, 0(a0)            #t0 <- ant->x
    subu t0, t0, 1          #t0 <- ant->x + 1
    rem t1, t1, a1          #t1 <- t1 % a1 (Para que no se vaya del tablero)
    sw t0, 0(a0)            #ant->x <- t0

    lw gp, 0(sp)           #Destruir stack
    lw fp, 4(sp)
    addiu sp, sp, 8
    jr ra    
.end step_west

.data
rotation_rules: .word OW, OE, OE, OW, ON, OS, OS, ON #Guardo matriz de reglas de rotacion

allowed_forward: .word step_north, step_south, step_east, step_west #Guardo direcciones de funciones