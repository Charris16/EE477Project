//test for XORI 
ADDI(x10, x0, 2047)
XORI(x1, x10, 1) // x1 should = 2046

//test for ORI 
ADDI(x10, x0, 4)
XORI(x1, x10, 1) // x1 should = 5

//test for ANDI
ADDI(x10, x0, 2047)
ANDI(x1, x10, 1) // x1 should = 1

//test for XOR 
ADDI(x10, x0, 2)
ADDI(x11, x0, 4)
XOR(x1, x10, x11) // x1 should = 6

//test for OR
ADDI(x10, x0, 3)
ADDI(x11, x0, 4)
OR(x1, x10, x11) // x1 should = 7

//test for AND
ADDI(x10, x0, 2046)
ADDI(x11, x0 , 2047)
AND(x1, x10, x11) // x1 should = 2046

