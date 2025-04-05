.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.section .text
.global main

.equ GPIOA_ODR, 0x4001080C //GPIOA Output Data Register
.equ RCC_APB2ENR, 0x40021018 //RCC APB2 clock enable register
.equ GPIOA_CRL, 0x40010800  //GPIOA Config register as Low

main:
    //Enable GPIOA clock(set bit 2 of RCC_APB2ENR)
    LDR R0, =RCC_APB2ENR
    LDR R1, [R0]
    MOV R2, #1
    LSL R2, R2, #2 //shifting
    ORR R1, R1, R2
    STR R1, [R0]

    //Configure PA5 as output(2MHz push-pull)
    LDR R0, =GPIOA_CRL
    LDR R1, [R0]
    MOV R2, #0xF
    LSL R2, R2, #20 //shift and Select bits 20-23 (PA5)
    BIC R1, R1, R2    //Clear PA5 bits
    MOV R2, #0x1
    LSL R2, R2, #20
    ORR R1, R1, R2    //Set PA5 as output
    STR R1, [R0]

    @ Set PA5 HIGH (Garage door open initially)
    LDR R0, =GPIOA_ODR
    LDR R1, [R0]
    MOV R2, #1
    LSL R2, R2, #5  //Bit 5 = PA5
    ORR R1, R1, R2
    STR R1, [R0]

    BL delay_300ms //jump to delay_300ms

    //Check if PA5 is HIGH (door open) or not
    LDR R1, [R0]
    MOV R2, #1
    LSL R2, R2, #5
    TST R1, R2
    BEQ END   //If already closed the door, do nothing

    //otherwise Clear PA5 (Close garage door)
    BIC R1, R1, R2
    STR R1, [R0]

END:
    B .

//Delay
delay_300ms:
    LDR R2, =2400000
loop:
    SUB R2, R2, #1
    CMP R2, #0
    BNE loop
    BX LR

