module SLT_OP(OUT, FUNC3, RS1_DATA, RS2_DATA);
    input logic [31:0] RS1_DATA, RS2_DATA;
    input logic [2:0] FUNC3;
    output logic [31:0] OUT;

    always_comb begin
        case(FUNC3)
            3'b010: begin //  Signed
                if($signed(RS1_DATA) < $signed(RS2_DATA)) OUT = 32'd1;
                else OUT = 32'b0;
            end
            3'b011: begin // Unsigned
                if(RS1_DATA < RS2_DATA) OUT = 32'd1;
                else OUT = 32'b0;
            end
            default: OUT = 32'b0;
	endcase
    end
    
endmodule
