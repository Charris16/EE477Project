//  Should work currently untested though
//  pipelineReg #(.N(1)) reg_name(DOUT, DIN, CLK, RST)

module pipelineReg #(parameter N = 32)(DOUT, DIN, CLK, RST);
    input logic [N-1:0] DIN;
    input logic CLK, RST;
    output logic [N-1:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= {N{1'b0}};
        else DOUT <= DIN;
    end
endmodule
