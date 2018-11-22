nop
addi $2, $0, 500
addi $6, $6, 4 
addi $8, $8, 1 
blt $2, $8, 6 
sll $11, $8, 2 
lw $12, 4($6) 
sw $11, 0($6) 
addi $6, $6, 4 
addi $8, $8, 1 
j 4
nop