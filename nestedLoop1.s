addi $2, $2, 500
addi $3, $3, 250
addi $6, $6, 0 
addi $8, $8, 1 
addi $9, $9, 1
blt  $2, $8, 9
blt  $3, $9, 6 
sll  $16, $8, 3 
add  $16, $8, $9 
sw   $16, 0($6) 
addi $9, $9, 1 
addi $6, $6, 4 
j 6
addi $8, $8, 1 
j 5
nop