## EE477Project
**Python 3.10** required to compile test scripts

## Simulation


**runsim.py** is a simple console to change selected test and execute it. 
All avalable tests can be listed with  --list once started

**Pre-Synthasis:** 
reads from verilog/ directory
    
    cd sim/pre-syn/
    run ./sim.py to start the console
    type --list to see all tests
    type the name of a test to run it "branch.bin"
    
**Post-Synthasis:** 
    Synthasize design first
    
    cd sim/post-syn/
    run ./sim.py to start the console
    type --list to see all tests
    type the name of a test to run it (ex "branch.bin")
    
**Post-APR:** 
    Compile design APR first
    
    cd sim/post-apr/
    run ./sim.py to start the console
    type --list to see all tests
    type the name of a test to run it (ex "branch.bin")
    
## Synthasis
commands:

    cd syn/
    make
    
## APR
commands:

    cd apr/
    make
    
#
