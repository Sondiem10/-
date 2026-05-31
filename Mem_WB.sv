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
    input [4:0] Rs1M,
    input [4:0] Rs2M,
    input [31:0] RD1M,
    input [31:0] RD2M,
    input [31:0] instrM,
    input [31:0] Next_PCM,
    input [31:0] PCM,
    input [2:0]mem_maskM,
	input [31:0]WriteDataM,

    output reg [4:0] Rs1W,
    output reg [4:0] Rs2W,
    output reg [31:0] RD1W,
    output reg [31:0] RD2W,
    output reg [31:0] instrW,
    output reg [31:0] Next_PCW,
    output reg [31:0] PCW,
    output reg [2:0] mem_maskW,
	output reg[31:0]WriteDataW,
    output reg [1:0] ResultDesW,
    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [4:0] RdW,
    output reg [31:0] PCPlus4W,
	output reg [31:0] PCPlusImmW,
	output reg RegWriteW
);

always@(posedge clk)begin
	if(!rst)begin
		RegWriteW <=1'b0;
		WriteDataW <= 32'b0;
        ResultDesW  <= 2'b0;
        ALUResultW  <= 32'b0;
        ReadDataW   <= 32'b0;
        RdW         <= 5'b0;
        PCPlus4W    <= 32'b0;
        PCPlusImmW  <= 32'b0;
        Rs1W <= 5'b0;
        Rs2W <= 5'b0;
        RD1W <= 32'b0;
        RD2W <= 32'b0;
        instrW <= 32'b0;
        Next_PCW <= 32'b0;
        PCW <= 32'b0;
        mem_maskW <= 3'b0;
	end
	else begin
		RegWriteW <= RegWriteM;
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
		PCPlusImmW <= PCPlusImmM;
        WriteDataW <= WriteDataM;
        ResultDesW <= ResultDesM;
        Rs1W <= Rs1M;
        Rs2W <= Rs2M;
        RD1W <= RD1M;
        RD2W <= RD2M;
        instrW <= instrM;
        Next_PCW <= Next_PCM;
        PCW <= PCM;
        mem_maskW <=mem_maskM;
	end
end

endmodule
