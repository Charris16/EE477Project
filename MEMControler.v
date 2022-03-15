module MemControler(MEM_wr_data, Load_data, xfer_size, load, store, regData, MEM_rd_data, OPCODE, func3);
    input logic [31:0] regData ,MEM_rd_data;
    input logic [6:0] OPCODE;
    input logic [2:0] func3;
    output logic load, store;
    output logic [2:0] xfer_size;
    output logic [31:0] MEM_wr_data, Load_data;

    assign load = (OPCODE == 7'b0000011);
    assign store = (OPCODE == 7'b0100011);


    always_comb begin
        case(func3)
            3'b000:   begin  // LB SB
                xfer_size = 3'd1;
                if (load) begin Load_data = {{24{MEM_rd_data[7]}}, MEM_rd_data[7:0]}; MEM_wr_data = 32'b0; end
                else if (store) begin Load_data = 32'b0; MEM_wr_data = {{24{regData[7]}}, regData[7:0]}; end
                else begin Load_data = 32'b0; MEM_wr_data = 32'b0; end
            end
            3'b001:   begin  // LH SH
                xfer_size = 3'd2;
                if (load) begin Load_data = {{16{MEM_rd_data[15]}}, MEM_rd_data[15:0]}; MEM_wr_data = 32'b0; end
                else if (store) begin Load_data = 32'b0; MEM_wr_data = {{16{regData[15]}}, regData[15:0]}; end
                else begin Load_data = 32'b0; MEM_wr_data = 32'b0; end
            end
            3'b010: begin  // LW SW
                xfer_size = 3'd4;
                if (load) begin Load_data = { {16{MEM_rd_data[15]}}, MEM_rd_data[15:0]}; MEM_wr_data = 32'b0; end
                else if (store) begin Load_data = 32'b0; MEM_wr_data = {{16{regData[15]}}, regData[15:0]}; end
                else begin Load_data = 32'b0; MEM_wr_data = 32'b0; end
            end  
            3'b100: begin // LBU
                xfer_size = 3'd1;
                if (load) begin Load_data = {{24{1'b0}}, MEM_rd_data[7:0]}; MEM_wr_data = 32'b0; end
                else begin Load_data = 32'b0; MEM_wr_data = 32'b0; end
            end
            3'b101: begin  // LHU
                xfer_size = 3'd2;
                if (load) begin Load_data = {{16{1'b0}}, MEM_rd_data[15:0]}; MEM_wr_data = 32'b0; end
                else begin  Load_data = 32'b0; MEM_wr_data = 32'b0; end
            end 
            default: begin
                xfer_size = 3'b0;
                Load_data = 32'b0;
                MEM_wr_data = 32'b0;
            end 
        endcase
    end




endmodule
