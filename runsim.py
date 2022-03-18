import subprocess
import os

print("Setting up Environment")
os.system("tcsh")
os.system("setenv EDA_TOOLS_PATH /home/lab.apps/vlsiapps_new/")
os.system("set path = (/home/lab.apps/vlsiapps_new/icc2/current/bin $path)")
os.system("source /home/lab.apps/vlsiapps_new/cshrc/general.cshrc")
print("_____________________________________________")
while(1):
    test_in = input("Testname to run: ")
    test_list = os.listdir("bin/")
    found = False
    run_test = ""
    test_in = test_in.lower()
    test_in = test_in.replace(".bin", "")
    test_in = test_in.replace(" ", "")
    for test in test_list:
        if (test_in == test.replace(".bin", "").lower()):
            run_test = test
            found = True
            break

    if not found:
        if test_in == "!q":
            print("-------Shutting  Down-----------")
            exit(0)
        if (test_in == "--list"):
            print("_____________________________________________")
            print("Avalable Tests: ")
            for test in test_list:
                print("    | ", test)
        else:
            print("_____________________________________________")
            print("Unable to find Test:", test_in)
            print("Run with --list to see avalable tests")
            print("exit with !q")
    else:
        print("_____________________________________________")
        print("Setting up Test:", run_test)
        tb_file = open("IMEM.v", 'r') 
        if not tb_file.readable():
            print("-------ERROR Cant Find IMEM.v -----------")
            print("-------Shutting  Down-----------")
            exit(1)
        file_lines = tb_file.readlines()
        if "`define BENCHMARK \"bin/" in file_lines[0]:
            print("Removing Header")
            file_lines[0] = "`define BENCHMARK \"bin/" + run_test + "\"\n"
        tb_file.close()
        tb_file = open("IMEM.v", 'w') 
        for line in file_lines:
            tb_file.write(line)
        tb_file.close()
        print("_____________________________________________")
        print("Running VCS")
        
        main = subprocess.Popen(["vcs", "-f", "cpu.include", "+v2k","-R", "+lint", "-sverilog", "-full64", "-debug_pp", "-timescale=1ns/10ps", "-l", "cpu.log"])
        main.wait()

        print("_____________________________________________")
        u_in = input("Any Key to continue q to quit")
        if (u_in.lower() == 'q'):
            print("-------Shutting  Down-----------")
            exit(0)
        else:
            continue
