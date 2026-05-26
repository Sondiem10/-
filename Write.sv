module Write(
    input [1:0] ResultDesW,
    input [31:0] ALUResultW,
    input [31:0] ReadDataW,
    input [31:0] PCPlus4W,
	input [31:0] PCPlusImmW,
    output reg [31:0]  ResultW 
);
    always_comb begin
	case(ResultDesW) 
		2'b00 : ResultW  = ALUResultW;
		2'b01 : ResultW  = ReadDataW;
		2'b10 : ResultW  = PCPlus4W;
		2'b11 :ResultW  = PCPlusImmW;
		default : ResultW  = 32'b0;
	endcase
	end
endmodule
