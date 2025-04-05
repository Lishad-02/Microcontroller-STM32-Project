.cpu cortex-m3
.fpu softvfp
.thumb

.section .text
.global main

.equ GPIOA_ODR, 0x4001080C // GPIOA Output Data Register (ODR)
.equ RCC_APB2ENR, 0x40021018 //clock enable register
.equ GPIOA_CRL, 0x40010800 //GPIOA Config register

main:
    //enable GPIOA clock
    LDR R0, =RCC_APB2ENR
    LDR R1, [R0]
    MOV R2, #(1<<2)  //Load bit masking for GPIOA clock enable
    ORR R1, R1, R2 //Set bit 2 
    STR R1, [R0]

    //PA6 as output(push-pul)
    LDR R0, =GPIOA_CRL
    LDR R1, [R0]
    MOV R2, #0x0F
    LSL R2, R2, #24 //Shift r2 left to bit position 24-27
    BIC R1, R1, R2  //Clear PA6
    MOV R2, #0x01
    LSL R2, R2, #24 //Shift 0x01
    ORR R1, R1, R2  //Set PA6 for output
    STR R1, [R0]

toggle_loop:
    //Toggle PA6 (Bit 6)
    LDR R0, =GPIOA_ODR
    LDR R1, [R0]
    MOV R2, #(1 << 6) // bit mask for PA6
    EOR R1, R1, R2 //XOR operation for bit6 to toggle
    STR R1, [R0]

    BL delay_500ms
    B toggle_loop  //Repeat the process

//delay
delay_500ms:
    LDR R2, =4000000 //Adjust delay 500ms
delay_loop:
    SUB R2, R2, #1 //Decrement delay
    CMP R2, #0  //compare with 0
    BNE delay_loop
    BX LR
