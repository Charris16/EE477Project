//  Should work currently untested though
//  pipelineReg #(.N(1)) reg_name(DOUT, DIN, CLK, RST)

// module pipelineReg #(parameter N = 32)(DOUT, DIN, CLK, RST);
//     input logic [N-1:0] DIN;
//     input logic CLK, RST;
//     output logic [N-1:0] DOUT;

//     always_ff @(posedge CLK) begin
//         if(RST) DOUT <= {N{1'b0}};
//         else DOUT <= DIN;
//     end
// endmodule


module pipelineReg_32(DOUT, DIN, CLK, RST);
    input logic [31:0] DIN;
    input logic CLK, RST;
    output logic [31:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 32'b0;
        else DOUT <= DIN;
    end
endmodule


module pipelineReg_20(DOUT, DIN, CLK, RST);
    input logic [19:0] DIN;
    input logic CLK, RST;
    output logic [19:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 20'b0;
        else DOUT <= DIN;
    end
endmodule


module pipelineReg_12 (DOUT, DIN, CLK, RST);
    input logic [11:0] DIN;
    input logic CLK, RST;
    output logic [11:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 12'b0;
        else DOUT <= DIN;
    end
endmodule

module pipelineReg_7 (DOUT, DIN, CLK, RST);
    input logic [6:0] DIN;
    input logic CLK, RST;
    output logic [6:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 7'b0;
        else DOUT <= DIN;
    end
endmodule

module pipelineReg_5 (DOUT, DIN, CLK, RST);
    input logic [4:0] DIN;
    input logic CLK, RST;
    output logic [4:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 5'b0;
        else DOUT <= DIN;
    end
endmodule

module pipelineReg_3 (DOUT, DIN, CLK, RST);
    input logic [2:0] DIN;
    input logic CLK, RST;
    output logic [2:0] DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 3'b0;
        else DOUT <= DIN;
    end
endmodule

module pipelineReg_1 (DOUT, DIN, CLK, RST);
    input logic DIN;
    input logic CLK, RST;
    output logic DOUT;

    always_ff @(posedge CLK) begin
        if(RST) DOUT <= 1'b0;
        else DOUT <= DIN;
    end
endmodule