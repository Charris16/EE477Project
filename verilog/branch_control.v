`include "opcode.vh"

module branch_control ( rs1,rs2,func, useBr );

   input logic [31:0] rs1;
   input logic [31:0] rs2;
   input logic [2:0]  func;
   output logic       useBr;
 


    always_comb begin
        case (func)
        `FNC_BEQ: if (rs1 == rs2) begin
                            useBr = 1'b1; 
                        end else begin
                            useBr = 1'b0;   
                        end
        `FNC_BNE: if (rs1 != rs2) begin
                            useBr = 1'b1; 
                        end else begin
                            useBr = 1'b0;   
                        end
        `FNC_BLT: if  ($signed(rs1) < $signed(rs2))begin
                            useBr = 1'b1; 
                        end else begin
                            useBr = 1'b0;   
                        end
        `FNC_BGE: if ($signed(rs2) < $signed(rs1))begin
                            useBr = 1'b1; 
                        end else begin
                            useBr = 1'b0;   
                        end
        `FNC_BLTU: if(rs1 < rs2)begin
                            useBr = 1'b1; 
                        end else begin
                            useBr = 1'b0;   
                        end
        `FNC_BGEU: if (rs2 < rs1)begin
                            useBr = 1'b1; 
                        end else begin
                            useBr = 1'b0;   
                        end
        default: useBr = 1'b0;
        endcase
    end


endmodule