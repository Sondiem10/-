module RISCV_top(
    input clk,
    input rst
);

wire [31:0] PCPlus4F;
wire [31:0] PCF;
wire [31:0] instrF;
wire PCSrcE;
wire [31:0] PCPlusImmE;
wire StallFetch;
//////////////////////Fetch////////////////////////////
fetch fetch(
    // Inputs
    .clk(clk),
    .reset(rst),
	.enable(!StallFetch),
	// Output
    .PCSrcE(PCSrcE),
	//.PCSrcE(1'b0),
	.PCjumpE(PCPlusImmE),
    .ins(instrF),
	.PCF(PCF),
    .PCPlus4F(PCPlus4F)
);

//////////////////////IF_ID  ////////////////////////////             
wire[31:0] instrD;
wire [31:0] PCD;
wire [31:0] PCPlus4D;
wire StallDecode;

IF_ID IF_ID (
	.clk(clk),  
	.enable(!StallDecode),
	.flush(rst && (!PCSrcE)),
	//.flush(rst),
	.instrF(instrF),
	.PCF(PCF),
    .PCPlus4F(PCPlus4F),
    // Outputs
    .instrD(instrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);
//////////////////////Decode////////////////////////////
wire RegWriteD;
wire [1:0]ResultDesD;
wire MemWriteD;
wire JumpD;
wire BranchD;
wire [3:0]ALUControlD;
wire  ALUSrcD;
wire [31:0] ExtImmD;
wire [2:0] mem_maskD;
wire[31:0] RD1D;
wire[31:0] RD2D;
wire [4:0]RdD;
wire[31:0] ResultW;
wire [4:0]RdW;
wire[4:0] Rs1D;
wire[4:0] Rs2D;

decode decode(
    // Inputs
    .clk(clk),
	.rst(rst),
    .instrD(instrD),	
	.RegWrite(RegWriteW),
	.WD(ResultW),
	.WA(RdW),
    // Outputs
	.Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RegWriteD(RegWriteD),
    .ResultDesD(ResultDesD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .mem_maskD(mem_maskD),
    .ExtImmD(ExtImmD),
	.RD1D(RD1D),
    .RD2D(RD2D),
	.RdD(RdD)
);
///////////////////////ID_EX ///////////////////////////
wire RegWriteE;
wire [1:0]ResultDesE;
wire MemWriteE;
wire[31:0] RD1E;
wire [31:0] RD2E;
wire JumpE;
wire BranchE;
wire [3:0]ALUControlE;
wire [31:0] ExtImmE;
wire [2:0] mem_maskE;
wire ALUSrcE;
wire [31:0] PCE;
wire [4:0]RdE;
wire [31:0] PCPlus4E;
wire [4:0] Rs1E;
wire [4:0] Rs2E;

ID_EX ID_EX(
    // Inputs
    .clk(clk),  
    .flush(rst && !(StallDecode|PCSrcE)),
	//.flush(rst),
    .RegWriteD(RegWriteD),
    .ResultDesD(ResultDesD),
    .MemWriteD(MemWriteD),
	.mem_maskD( mem_maskD),
	.RdD(RdD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),	
    .ExtImmD(ExtImmD),
    .RD1D(RD1D),
    .RD2D(RD2D),
	.PCD(PCD),
    .PCPlus4D(PCPlus4D),
	.Rs1D(Rs1D),
	.Rs2D(Rs2D),
	
    // Outputs
	.Rs1E(Rs1E),
	.Rs2E(Rs2E),
    .RegWriteE(RegWriteE),
    .ResultDesE(ResultDesE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
	.PCE(PCE),
    .RdE(RdE),
	.PCPlus4E(PCPlus4E),
	.ExtImmE(ExtImmE),
    .RD1E(RD1E),
    .RD2E(RD2E),    
    .mem_maskE(mem_maskE)
);
//////////////////////Execute////////////////////////////
wire FlushE;
wire [31:0] WriteDataE;
wire [31:0] ALUResultM;
wire [31:0] ALUResultE;
wire [1:0] ForwardAE;
wire [1:0] ForwardBE;
execute execute(
    .clk(clk),
    // Inputs
    .ALUControlE(ALUControlE),
    .AluSrcE(ALUSrcE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .PCE(PCE),
    .ExtImmE(ExtImmE),
	.ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE), 
    .ALUResultM(ALUResultM),
	.ResultW(ResultW),
    //Outputs
    .FlushE(FlushE),
    .PCPlusImmE(PCPlusImmE),
    .ALUResultE(ALUResultE),
	.WriteDataE(WriteDataE)
);

assign PCSrcE = (FlushE && BranchE) || JumpE;

//////////////////////EX_mem////////////////////////////
wire RegWriteM;
wire MemWriteM;
wire [1:0]ResultDesM;
wire [4:0] RdM;
wire [31:0]PCPlus4M;
wire [31:0] PCPlusImmM;
wire [2:0] mem_maskM;
wire [31:0]WriteDataM;

EX_Mem EX_Mem(
    // Inputs
    .clk(clk),
	.rst(rst),
    .RegWriteE(RegWriteE),
    .ResultDesE(ResultDesE),
    .MemWriteE(MemWriteE),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .RdE(RdE),
    .PCPlus4E(PCPlus4E),
	.PCPlusImmE(PCPlusImmE),
    .mem_maskE(mem_maskE),
    // Outputs
    .RegWriteM(RegWriteM),
    .ResultDesM(ResultDesM),
    .MemWriteM(MemWriteM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
	.PCPlusImmM(PCPlusImmM),
    .mem_maskM(mem_maskM)
);
//////////////////////////////////////////////////
//                  Memory                      //
//////////////////////////////////////////////////
wire [31:0] ReadDataM;
D_mem D_mem (
	.addr(ALUResultM),
	.clk(clk),
    .WE(MemWriteM),
	.mem_mask(mem_maskM),
	.WD(WriteDataM),
	.RD(ReadDataM)
);

////////////////////// mem_WB ////////////////////////////
wire [1:0] ResultDesW;
wire[31:0] ALUResultW;
wire [31:0] ReadDataW;
wire [31:0] PCPlus4W;
wire [31:0] PCPlusImmW;

Mem_WB Mem_WB(
    // Inputs
    .clk(clk),
	.rst(rst),
    .RegWriteM(RegWriteM),
    .ResultDesM(ResultDesM),
    .ALUResultM(ALUResultM),
    .ReadDataM(ReadDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
	.PCPlusImmM(PCPlusImmM),
    // Outputs
    .RegWriteW(RegWriteW),
    .ResultDesW(ResultDesW),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
	.PCPlusImmW(PCPlusImmW),
    .PCPlus4W(PCPlus4W)
);
/////////////////////WriteBack/////////////////////////////

Write Write(
    // Inputs
    .ResultDesW(ResultDesW),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W),
	.PCPlusImmW(PCPlusImmW),
    // Outputs
    .ResultW(ResultW)
);

hazard_control_unit hazard_unit(
    // Inputs
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdM(RdM),
    .RdW(RdW),
	.RdE(RdE),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
	.ResultDesE(ResultDesE),
	.PCSrcE(PCSrcE),
    // Outputs
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
	.StallDecode(StallDecode),
	.StallFetch(StallFetch)
	////////////////////
);

endmodule