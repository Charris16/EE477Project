all: basic_add branch lui mem or_and shift SLT sum toLower toUpper SB

basic_add:
	python3.10 risc-V.py asm/basic_add.asm
branch:
	python3.10 risc-V.py asm/branch.asm
lui:
	python3.10 risc-V.py asm/lui.asm
mem:
	python3.10 risc-V.py asm/mem.asm
or_and:
	python3.10 risc-V.py asm/or_and.asm
shift:
	python3.10 risc-V.py asm/shift.asm
SLT:
	python3.10 risc-V.py asm/SLT.asm
sum:
	python3.10 risc-V.py asm/sum.asm
toLower:
	python3.10 risc-V.py asm/toLower.asm
toUpper:
	python3.10 risc-V.py asm/toUpper.asm
SB:
	python3.10 risc-V.py asm/SB.asm
clean:
	@echo "Removing Binaries"
	rm bin/*.bin