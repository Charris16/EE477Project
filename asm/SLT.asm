//SLTI test
ADDI(x1, x0, 2)
SLTI(x2, x1, 4)
ADDI(x3, x0, 1)
BEQ(x2,x3,8)
ADDI(x4, x0, 5)
ADDI(x4, x0, 69) // x1 ,x3 should be 1, x4 should be 69 


//SLT test
ADDI(x10, x0, 9)
ADDI(x11, x0, 8)
SLT(x1, x10, x11) // x1 should = 0

//SLTU test
ADDI(x10, x0, 9)
ADDI(x11, x0, -8)
SLTU(x1, x10, x11) // x1 should = 1

//SLTIU test
ADDI(x10, x0, 9)
SLTIU(x1, x10, -1) //x1 should = 1
