addi $2, $2, 500
addi $6, $6, 0
addi $8, $8, 2 
addi $7, $7, 4
blt $2, $8, 7 
lw $11, 0($6) 
add $16, $16, $11 
addi $11, $11, 5 
sw $11, 0($6) 
addi $8, $8, 1 
addi $6, $6, 4 
j 4
addi $6, $6, 4
sw $16, 0($6) 