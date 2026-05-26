module fetch (
    input clk,
	input reset,
	input enable,
	input PCSrcE,
	input [31:0] PCjumpE,
    output [31:0] ins,
	output [31:0] PCF,
	output [31:0] PCPlus4F
);
	
	PC PC(
	.clk(clk),
    .reset(reset),
	.enable(enable),
	.PCSrcE(PCSrcE),
	.PCjumpE(PCjumpE),
    .PCF(PCF),
	.PCPlus4F(PCPlus4F)
	);

	i_mem i_mem(
		.adr(PCF),
		.ins(ins)
	);
endmodule
