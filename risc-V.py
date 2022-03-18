import sys
global PC_addr
print("-------Starting  Complilation------")
if len(sys.argv) != 2:
    print("Error No File Passed")
    sys.exit(1)

#clear file
print("Compiling File: ", sys.argv[1])
FILE_det = "bin/" + str(sys.argv[1]).partition("asm/")[2].partition(".")[0] + ".bin"
print("Outputing to: ", FILE_det)
with open(FILE_det, "w") as f:
	pass


FILE_src = str(sys.argv[1])
det = open(FILE_det, "a")  # append mode
src = open(FILE_src, "r")  # read mode

def format(string):
    string = string.partition("//")[0]
    string = string.replace(" ", "")
    s = string.split("(")
    s[1] = s[1].lower()
    s[0] = s[0].upper()
    s[1] = s[1].replace('x', '')
    s[1] = s[1].replace(")", "")
    arg = s[1].split(",")
        
    ret = [s[0], arg]
    return ret

def toBin (arg, n):
    temp = ""
    if int(arg) < 0:
        hex = int(arg).to_bytes(4,byteorder='big', signed=True)
        temp = str(bin(int.from_bytes(hex, byteorder='big', signed=False)))
        temp = temp.replace("0b", "")
        temp = temp[ 32 - n : 32]
    else:
        temp = str(bin(int(arg)))
        temp = temp.replace("0b", "")
    if len(temp) > n:
        return ""
    for i in range(0, n - len(temp)):
        temp = '0' + temp
    return temp

def writeR_Type(s):
    func7 = '0000000'
    if s[0] == 'SUB' or s[0] == 'SRA':
        func7 = "0100000"

    det.write(func7)
    det.write('_')
    temp = toBin(s[1][2], 5)
    det.write(temp)
    det.write('_')
    temp = toBin(s[1][1], 5)
    det.write(temp)
    det.write('_')
    op = ""
    IR = str(s[0])
    match IR:
        case 'ADD':
            op = "0110011"
            det.write(toBin('0', 3))
        case 'SUB':
            op = "0110011"
            det.write(toBin('0', 3))
        case 'SLL':
            op = "0110011"
            det.write(toBin('1', 3))
        case 'SLT':
            op = "0110011"
            det.write(toBin('2', 3))
        case 'SLTU':
            op = "0110011"
            det.write(toBin('3', 3))
        case 'XOR':
            op = "0110011"
            det.write(toBin('4', 3))
        case 'SRL':
            op = "0110011"
            det.write(toBin('5', 3))
        case 'SRA':
            op = "0110011"
            det.write(toBin('5', 3))
        case 'OR':
            op = "0110011"
            det.write(toBin('6', 3))
        case 'AND':
            op = "0110011"
            det.write(toBin('7', 3))
        case _:
            print("FATAL ERROR OP NOT FOUND")
    det.write('_')
    temp = toBin(s[1][0], 5)
    det.write(temp)
    det.write('_')
    det.write(op)
    while len(s[0]) < 6:
        s[0] = s[0] + " "
    print("   R_Type: ", s[0], "  PC = ", PC_addr)
    return

def writeI_Type(s):
    intem = s[1][2]
    if s[0] == 'SRAI':
        intem = "0100000" + toBin(s[1][2], 5)
    else:
        intem = toBin(s[1][2], 12)
    if intem == "":
        print("Error Invalid Intermediate size")
        return
    det.write(intem)
    det.write('_')
    temp = toBin(s[1][1], 5)
    det.write(temp)
    det.write('_')
    op = ""
    IR = str(s[0])
    match IR:
        case 'LB':
            op = "0000011"
            det.write(toBin('0', 3))
        case 'LH':
            op = "0000011"
            det.write(toBin('1', 3))
        case 'LW':
            op = "0000011"
            det.write(toBin('2', 3))
        case 'LBU':
            op = "0000011"
            det.write(toBin('4', 3))
        case 'LHU':
            op = "0000011"
            det.write(toBin('5', 3))
        case 'ADDI':
            op = "0010011"
            det.write(toBin('0', 3))
        case 'SLTI':
            op = "0010011"
            det.write(toBin('2', 3))
        case 'SLTIU':
            op = "0010011"
            det.write(toBin('3', 3))
        case 'XORI':
            op = "0010011"
            det.write(toBin('4', 3))
        case 'ORI':
            op = "0010011"
            det.write(toBin('6', 3))
        case 'ANDI':
            op = "0010011"
            det.write(toBin('7', 3))
        case 'SLLI':
            op = "0010011"
            det.write(toBin('1', 3))
        case 'SRLI':
            op = "0010011"
            det.write(toBin('5', 3))
        case 'SRAI':
            op = "0010011"
            det.write(toBin('5', 3))
        case 'JALR':
            op = "1100111"
            det.write(toBin('0', 3))
    det.write('_')
    temp = toBin(s[1][0], 5)
    det.write(temp)
    det.write('_')
    det.write(op)
    while len(s[0]) < 6:
        s[0] = s[0] + " "
    print("   I_Type: ", s[0], "  PC = ", PC_addr)
    return

def writeS_Type(s):
    intem = toBin(s[1][2], 12)
    det.write(intem[0:7])
    det.write('_')
    det.write(toBin(s[1][0], 5))
    det.write('_')
    det.write(toBin(s[1][1], 5))
    det.write('_')

    ir = s[0]
    op = "0100011"
    match ir:
        case 'SB':
            det.write(toBin('0', 3))
        case 'SH':
            det.write(toBin('1', 3))
        case 'SW':
            det.write(toBin('2', 3))
    det.write('_')
    det.write(intem[7:len(intem)])
    det.write('_')
    det.write(op)
    while len(s[0]) < 6:
        s[0] = s[0] + " "
    print("   S_Type: ", s[0], "  PC = ", PC_addr)
    return

def writeB_Type(s):
    op = "1100011"
    intem = toBin(s[1][2], 13)
    print(intem)
    det.write(intem[0])
    det.write("_")
    det.write(intem[2:8])
    det.write("_")
    det.write(toBin(s[1][1], 5))
    det.write("_")
    det.write(toBin(s[1][0], 5))
    det.write("_")

    ir = s[0]
    match ir:
        case 'BEQ':
            det.write(toBin('0', 3))
        case 'BNE':
            det.write(toBin('1', 3))
        case 'BLT':
            det.write(toBin('4', 3))
        case 'BGE':
            det.write(toBin('5', 3))
        case 'BLTU':
            det.write(toBin('6', 3))
        case 'BGEU':
            det.write(toBin('7', 3))
    det.write("_")
    det.write(intem[8:len(intem)-1])
    det.write("_")
    det.write(intem[1])
    det.write("_")
    det.write(op)
    while len(s[0]) < 6:
        s[0] = s[0] + " "
    print("   B_Type: ", s[0], "  PC = ", PC_addr)
    return

def writeU_Type(s):
    intem = toBin(int(s[1][1]) << 12, 32)
    det.write(intem[0:20])
    det.write("_")
    det.write(toBin(s[1][0], 5))
    det.write("_")
    op = ""
    if s[0] == 'LUI':
        op = '0110111'
    else:
        op = '0010111'
    det.write(op)
    while len(s[0]) < 6:
        s[0] = s[0] + " "
    print("   U_Type: ", s[0], "  PC = ", PC_addr)
    return

def writeJ_Type(s):
    
    intem = toBin(s[1][1], 21)
    det.write(intem[0])
    det.write("_")
    det.write(intem[10:20])
    det.write("_")
    det.write(intem[9])
    det.write("_")
    det.write(intem[1:9])
    det.write("_")
    det.write(toBin(s[1][0], 5))
    det.write("_")
    det.write("1101111")
    while len(s[0]) < 7:
        s[0] = s[0] + " "
    print("   J_Type: ", s[0], " PC = ", PC_addr)
    return

def writeCSRR(s):
    print("   CSRRW_Type")
    intem = toBin(s[1][2], 12)
    det.write(intem)
    det.write("_")
    det.write(toBin(s[1][1], 5))
    det.write("_")
    if s[0] == 'CSRRW':
        det.write("001")
    else:
        det.write("101")
    det.write("_")
    det.write(toBin(s[1][0], 5))
    det.write("_")
    det.write("1110011")
    return

def classifyInstruction(s):
    if s[0].startswith('B'):
        writeB_Type(s)
    elif s[0] == 'JAL':
        writeJ_Type(s)
    elif s[0].startswith('LUI') or s[0].startswith('AUIPC'):
        writeU_Type(s)
    elif s[0].startswith('SB') or s[0].startswith('SH') or s[0].startswith('SW'):
        writeS_Type(s)
    elif 'I' in s[0] or s[0].startswith('L') or s[0] == 'JALR':
        writeI_Type(s)
    elif s[0].startswith('CSRRW'):
        writeCSRR(s)
    else:
        writeR_Type(s)


PC_addr = 0
while True:
    line = src.readline()
    if not line:
        break
    if line != '\n' and not line.startswith("//"):
        op_format = format(line)
        classifyInstruction(op_format)
        det.write("\n")
        PC_addr += 4
print("-------Complete------")
print()
src.close()
det.close()


