module D_mem (
	input reg [31:0] addr,
	input clk,
    input WE,
	input [2:0] mem_mask,
	input [31:0] WD,
	output reg [31:0] RD
);

reg [7:0] ram_array [(2**16)-1:0];

initial begin
    for (int i = 0; i < 2**16; i = i + 1) begin
        ram_array[i] = 8'h00;
    end
end

always@(posedge clk) begin
	if (WE) begin
		case(mem_mask)
			3'b000 : 
				ram_array[addr] <= WD[7:0];
			3'b001 : 
				begin
					ram_array[addr] <= WD[7:0];
					ram_array[addr+1] <= WD[15:8];
				end
			3'b010:  
				begin
					ram_array[addr] <= WD[7:0];
					ram_array[addr+1] <= WD[15:8];
					ram_array[addr+2] <= WD[23:16];
					ram_array[addr+3] <= WD[31:24];
				end
			default : ram_array[addr] <= 0;
		endcase
	end
end

  always_comb begin
	case(mem_mask) 
		3'b100 : RD = {24'b0, ram_array[addr]};
		3'b000 : RD = {{24{ram_array[addr][7]}}, ram_array[addr]};
		3'b101 : RD = {16'b0, ram_array[addr+1] ,ram_array[addr]};
		3'b001 : RD = {{16{ram_array[addr+1][7]}}, ram_array[addr+1], ram_array[addr]};
		3'b010 : RD = {ram_array[addr+3], ram_array[addr+2], ram_array[addr+1], ram_array[addr]};
		default : RD = 32'b0;
	endcase
end

endmodule
