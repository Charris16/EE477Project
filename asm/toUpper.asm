
ADDI(x1, x0, 8)

ADD(x2, x0, x1)
ADDI(x3, x0, 84) //Store T
SB(x3, x2, 0)

ADDI(x2, x2, 1)
ADDI(x3, x0, 101) // Store e
SB(x3, x2, 0)

ADDI(x2, x2, 1)
ADDI(x3, x0, 115) // Store s
SB(x3, x2, 0)

ADDI(x2, x2, 1)
ADDI(x3, x0, 116) //Store t
SB(x3, x2, 0)

ADDI(x6, x0, 0) // x6 is i
ADDI(x7, x0, 4) // x6 is SIZE
ADDI(x3, x0, 0) // CLear x3

ADD(x2, x0, x1) // Resets Pointer

ADDI(x4, x0, 97) // Lower Bound
ADDI(x5, x0, 122) // Upper Bound

LB(x3, x2, 0)
ADDI(x0, x0, 0)
BLT(x3, x4, 16)
BGE(x3, x5, 12)
ADDI(x3, x3, -32) // Converts to UpperCase
SB(x3, x2, 0)
ADDI(x6, x6, 1) // Updates index
ADD(x2, x1, x6) // Updates Pointers
BNE(x6, x7, -32)

ADDI(x8, x0, 69 ) // Return Value