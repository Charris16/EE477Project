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

    
    
    logic [31:0] inc_amt;
    logic stall_pc;
    assign stall_pc = (OP == 7'b1101111) | (OP == 7'b1100111) | (OP == 7'b1100011);
    assign PC_def = IP + 32'd4;

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
            default ns = INC4;
        endcase
    end

    always_comb begin
        case(ps)
            INC4: inc_amt = stall_pc ? IP : IP + 32'd4;
            STALL: inc_amt = b_taken ? IP + up_amt : IP + 32'd4;
            default inc_amt = IP + 32'd4;
        endcase
    end

    always_ff @(posedge CLK) begin
        if(RESET) begin
            ps <= INC4;
            IP <= 32'b0;
        end
        else begin 
            ps <= ns;
            IP <= inc_amt;
        end
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

