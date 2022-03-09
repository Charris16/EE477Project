module pc(IP, PC_def, up_amt, RS1_DATA, b_taken, OP, CLK, RESET);
    input logic signed [31:0] up_amt;
    input logic [31:0] RS1_DATA;
    input logic [6:0] OP;
    input logic b_taken, CLK, RESET;
    output logic [31:0] IP, PC_def;

    assign PC_def = IP + 32'd4;
    
    enum {INC4, STALL, JUMP} ps, ns;

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
        endcase
    end 

    always_ff @(posedge CLK) begin
        case(ns)
            INC4: begin 
                if (RESET)  IP <= 32'b0;
                else IP <= PC_def;
            end
            STALL: IP <= IP;
            JUMP: begin
                IP <= IP + up_amt;
            end
        endcase
    end

    always_ff @(posedge CLK) begin
        if(RESET) ps <= INC4;
        else ps <= ns;
    end
endmodule
