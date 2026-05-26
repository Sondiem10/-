module Mem_WB(
    input clk,
	input rst,
    input RegWriteM,
    input [1:0] ResultDesM,
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [4:0] RdM,
    input [31:0] PCPlus4M,
    input [31:0] PCPlusImmM,
    output reg RegWriteW,
    output reg [1:0] ResultDesW,
    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [4:0] RdW,
    output reg [31:0] PCPlus4W,
	output reg [31:0] PCPlusImmW
);

    always@(posedge clk)begin
	if(!rst)begin
		RegWriteW   <= 1'b0;
        ResultDesW  <= 2'b0;
        ALUResultW  <= 32'b0;
        ReadDataW   <= 32'b0;
        RdW         <= 5'b0;
        PCPlus4W    <= 32'b0;
        PCPlusImmW  <= 32'b0;
	end
	else begin
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
		PCPlusImmW <= PCPlusImmM;
        RegWriteW <= RegWriteM;
        ResultDesW <= ResultDesM;
    end
	end

endmodule
