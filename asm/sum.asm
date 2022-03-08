ADDI(x1, x0, 0)  // SUM 0x0
ADDI(x2, x0, 0)  // i 0x4
ADDI(x31, x0, 31) // COMP 0x8
BEQ(x2,x31, 16) // 0xC
ADDI(x1, x1, 1) // 0x10
ADD(x2, x0, x1) // 0x14 
JAL (x3, -16) // Jump Line four 0x18
SW(x2, x0, 0) // 0x1C



