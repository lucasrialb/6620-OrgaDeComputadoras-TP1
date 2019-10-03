#include <regdef.h>
#include "ant_constants.h"

.text
.align 2
.globl new_orientation
.ent new_orientation

new_orientation:

    .frame fp, 8, ra        #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8          #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp,sp

    move t0, a0             #t0 <- orientation
    move t1, a1             #t1 <- rule

    li t2, ON     #t2 <- NORTH  |
    li t3, OS     #t3 <- SOUTH  |
    li t4, OE     #t4 <- EAST   |-> futuras comparaciones
    li t5, OW     #t5 <- WEST   |
    li t6, RR     #t6 <- RIGHT  |

    beq t0,t2, O_NORTH
    beq t0,t3, O_SOUTH
    beq t0,t4, O_EAST
    beq t0,t5, O_WEST

    jal doPanic

O_NORTH:
    beq t1, t6, GO_WEST
    b GO_EAST
O_SOUTH:
    beq t1, t6, GO_EAST
    b GO_WEST
O_EAST:
    beq t1, t6, GO_NORTH
    b GO_SOUTH
O_WEST:
    beq t1, t6, GO_SOUTH
    b GO_NORTH

GO_NORTH:
    move v0, t2
    b END_NEW_ORIENTATION
GO_SOUTH:
    move v0, t3
    b END_NEW_ORIENTATION
GO_EAST:
    move v0, t4
    b END_NEW_ORIENTATION
GO_WEST:
    move v0, t5
    b END_NEW_ORIENTATION

END_NEW_ORIENTATION:
    lw gp, 0(sp)            #Destruir stack
    lw fp, 4(sp)
    addu sp, sp, 8
    jr ra                   #return

.end new_orientation

.text
.align 2
.globl move_forward
.ent move_forward
move_forward:

    .frame fp, 8, ra       #Position independent
    .set noreorder
    .cpload t9
    .set reorder

    subu sp, sp, 8         #Crear stack (SRA = 8, LTA = 0, ABA = 0)
    .cprestore 0
    sw gp, 0(sp)
    sw fp, 4(sp)
    move fp,sp

    move t0, a0             #t0 <- *ant
    lw t1, 8(a0)            #t1 <- ant->o
    lw t2, 0(a0)            #t2 <- ant->x
    lw t3, 4(a0)            #t3 <- ant->y
    move t4, a1             #t4 <- width
    move t5, a2             #t5 <- height
    
    li t6, ON               #t6 <- NORTH  |
    li t7, OS               #t7 <- SOUTH  |
    li t8, OE               #t8 <- EAST   |-> futuras comparaciones
    li t9, OW               #t9 <- WEST   |

    beq t1,t6, M_NORTH
    beq t1,t7, M_SOUTH
    beq t1,t8, M_EAST
    beq t1,t9, M_WEST 
    
    jal doPanic

M_NORTH:
    subu t3, t3, 1          #y <- y-1
    rem t3, t3, t4          #t3 <- y % width
    sw t3, 4(a0)            #ant->y <- t3
    b END_MOVE_FORWARD

M_SOUTH:
    addu t3, t3, 1          #y <- y+1
    rem t3, t3, t4          #t3 <- y % width
    sw t3, 4(a0)            #ant->y <- t3
    b END_MOVE_FORWARD

M_EAST:
    addu t2, t2, 1          #x <- x+1
    rem t2, t2, t4          #t2 <- y % height
    sw t2, 0(a0)            #ant->x <- t2
    b END_MOVE_FORWARD

M_WEST:
    subu t2, t2, 1          #x <- x-1
    rem t2, t2, t4          #t2 <- y % height
    sw t2, 0(a0)            #ant->x <- t2
    b END_MOVE_FORWARD

END_MOVE_FORWARD:
    move v0, a0

    lw gp, 0(sp)       #Destruir stack
    lw fp, 4(sp)
    addu sp, sp, 8
    jr ra               #return

    
.end move_forward