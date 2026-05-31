module ID_EX (
    input clk,
    input flush,
    input RegWriteD,
    input [1:0]ResultDesD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input [3:0] ALUControlD,
    input  ALUSrcD,
	input [2:0]  mem_maskD,
	input [31:0]  ExtImmD,
    input [31:0]  RD1D,
    input [31:0]  RD2D,
	input [4:0] RdD,
    input [31:0]  PCD,
    input [31:0]  PCPlus4D,
	input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [31:0] instrD,
	
    output reg RegWriteE,
    output reg [1:0]ResultDesE,
    output reg  MemWriteE,
    output reg  JumpE,
    output reg  BranchE,
    output reg  [3:0]ALUControlE,
    output reg ALUSrcE,
	output reg [2:0] mem_maskE,
	output reg [31:0] ExtImmE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [4:0] RdE,
	output reg [31:0] PCE,
    output reg [31:0] PCPlus4E,	
	output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [31:0] instrE

);

always@(posedge clk) begin
    if(!flush) begin 
        RegWriteE <= 1'b0;
        ResultDesE <= 2'b0;
        MemWriteE <= 1'b0;
        JumpE <= 1'b0;
        BranchE <= 1'b0;
        ALUControlE <= 4'b0;
        ALUSrcE <= 1'b0;
        RD1E <= 32'b0;
        RD2E <= 32'b0;
        PCE <= 32'b0;
        RdE <= 5'b0;
        ExtImmE <= 32'b0;
        PCPlus4E <= 32'b0;
        mem_maskE <= 3'b0;		
		Rs1E <= 5'b0;
        Rs2E <= 5'b0;
        instrE<= 32'b0;
    end
    else begin
        RegWriteE <= RegWriteD;
        ResultDesE <= ResultDesD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        PCE <= PCD;
        RdE <= RdD;
        ExtImmE <= ExtImmD;
        PCPlus4E <= PCPlus4D;
        mem_maskE <= mem_maskD;
		Rs1E <= Rs1D;
        Rs2E <= Rs2D;
		instrD <=instrE;
    end
end


endmodule
