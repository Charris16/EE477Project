module CPU_tb();
    logic CLK, Reset;
    CPU dut(CLK, Reset);
    parameter clock_period = 10;
    initial begin
        CLK <=1'b0;
        forever #clock_period CLK <= ~CLK;
    end

    initial begin
        $vcdpluson;
        $dumpvars();
	    Reset <= 1'b1; @(posedge CLK);
        Reset <= 1'b0; @(posedge CLK);
        for (int i = 0; i < 330; i++) @(posedge CLK);

        $finish;
    end
endmodule
