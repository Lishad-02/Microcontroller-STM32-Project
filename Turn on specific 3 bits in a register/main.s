.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.section .text
.global main

.equ GPIOA_ODR, 0x4001080C    @ GPIOA Output Data Register
.equ RCC_APB2ENR, 0x40021018  @ RCC APB2 peripheral clock enable register
.equ GPIOA_CRL, 0x40010800    @ GPIOA Config register low (for pins 0-7)

main:
    @ Enable GPIOA clock
    LDR R0, =RCC_APB2ENR
    LDR R1, [R0]
    ORR R1, R1, #(1 << 2)     @ Enable GPIOA clock (bit 2)
    STR R1, [R0]

    @ Configure PA0, PA2, and PA3 as output (push-pull, max speed 2 MHz)
    LDR R0, =GPIOA_CRL
    LDR R1, [R0]
    BIC R1, R1, #(0x0F << 0)   @ Clear PA0 configuration bits
    ORR R1, R1, #(0x01 << 0)   @ Set PA0 as output mode
    BIC R1, R1, #(0x0F << 8)   @ Clear PA2 configuration bits
    ORR R1, R1, #(0x01 << 8)   @ Set PA2 as output mode
    BIC R1, R1, #(0x0F << 12)  @ Clear PA3 configuration bits
    ORR R1, R1, #(0x01 << 12)  @ Set PA3 as output mode
    STR R1, [R0]

    @ Turn ON PA0, PA2, and PA3 (Set bits 0, 2, and 3 HIGH)
    LDR R0, =GPIOA_ODR
    LDR R1, [R0]
    ORR R1, R1, #(1 << 0 | 1 << 2 | 1 << 3)  @ Set PA0, PA2, and PA3 HIGH
    STR R1, [R0]

    BL delay_500ms

    @ Turn OFF PA3 while keeping PA0 and PA2 ON
    LDR R0, =GPIOA_ODR
    LDR R1, [R0]
    BIC R1, R1, #(1 << 3)  @ Clear bit 3 (turn off LED 4)
    STR R1, [R0]

    B END

END:
    B .

delay_500ms:
    LDR R2, =4000000   @ Delay for ~500ms at 8MHz clock
delay_loop:
    SUBS R2, R2, #1
    BNE delay_loop
    BX LR
