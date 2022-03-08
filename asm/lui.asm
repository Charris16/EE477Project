ADDI (X1, X0, 68)  // 0
SB (X1, X0, 0) 4
ADDI (X1, X0, 1) //  8
SB (X1, X0, 4)  //  12
LUI (X2, 1048575)  //  16
ADDI (X3, X0, 2047)  //  20
OR (X4, X2, X3)   //  24
AND (X5, X2, X3)  //  28
ADD (X6, X2, X3)  //  32

AUIPC (X7, 1048575)
SUB (X7, X7, X2)
LB(X1, X0, 0)
LB(X8, X0, 4)
ADD (X0, X0, X0)
ADD (X1, X1, X8)
