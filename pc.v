module pc(
    IP,
    PC_def,
    up_amt,
    b_taken,
    OP,
    CLK,
    RESET
    );

    input logic [31:0] up_amt;
    input logic [6:0] OP;
    input logic b_taken, CLK, RESET;
    output logic [31:0] IP, PC_def;

    assign PC_def = IP + 32'd4;
    
    logic stall_pc;
    assign stall_pc = (OP == 7'b1101111) | (OP == 7'b1100111) | (OP == 7'b1100011);

    enum {INC4, STALL} ps, ns;
    always_comb begin
        case(ps)
            INC4: begin
                if(stall_pc) ns = STALL;
                else ns = INC4;
            end
            STALL: begin
                ns = INC4;
            end
        endcase
    end

    always_ff @(posedge CLK) begin
        IP <= 32'b0;
        case(ps)
            INC4: begin
                if(RESET) IP <= 32'b0;
                else IP <= stall_pc ? IP : IP + 32'd4;
            end
            STALL: IP <= b_taken ? IP + up_amt : IP + 32'd4;
        endcase
    end




    always_ff @(posedge CLK) begin
        if(RESET) ps <= INC4;
        else ps <= ns;
    end
endmodule


module pc_constant(IP, PC_def, up_amt, b_taken, OP, CLK, RESET);
    input logic [31:0] up_amt;
    input logic [6:0] OP;
    input logic b_taken, CLK, RESET;
    output logic [31:0] IP, PC_def;

    assign IP = 32'b0;
    assign PC_def = 32'b0;

endmodule

