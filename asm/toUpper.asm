ADDI(x1, x0, 8)

ADD(x2, x0, x1)
ADDI(x3, x0, 84) //Store T
SB(x3, x2, 0)

ADDI(x2, x2, 1)
ADDI(x3, x0, 69) // Store E
SB(x3, x2, 0)

ADDI(x2, x2, 1)
ADDI(x3, x0, 83) // Store S
SB(x3, x2, 0)

ADD(x2, x0, x1)
ADDI(x3, x0, 84) //Store T
SB(x3, x2, 0)

