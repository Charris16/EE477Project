module pc(IP, PC_def, up_amt, b_taken, OP, CLK, RESET);
    input logic [31:0] up_amt;
    input logic [6:0] OP;
    input logic b_taken, CLK, RESET;
    output logic [31:0] IP, PC_def;

    assign PC_def = IP + 32'd4;
    
    enum {INC4, STALL, JUMP} ps, ns;
    logic [31:0] inc_amt;
    always_comb begin
        case(ps)
            INC4: begin
                if (OP == 7'b1101111) ns = STALL;
                else if (OP == 7'b1100111) ns = STALL;
                else if (OP == 7'b1100011) ns = STALL;
                else ns = INC4;
            end
            STALL: begin
                if(b_taken) ns = JUMP;
                else if (OP == 7'b1101111) ns = JUMP;
                else if (OP == 7'b1100111) ns = JUMP;
                else ns = INC4;
            end
            JUMP: ns = INC4;
            default ns = INC4;
        endcase
    end 

    always_comb begin
        case(ns)
            INC4: inc_amt = 32'd4;
            STALL: inc_amt = 32'b0;
            JUMP: inc_amt = up_amt;
            default: inc_amt = 32'd4;
        endcase
    end

    always_ff @(posedge CLK) begin
        if(RESET) IP <= 32'b0;
        else IP <= inc_amt;
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

