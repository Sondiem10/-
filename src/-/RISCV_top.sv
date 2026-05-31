module RISCV_top(
    input clk,
    input rst
);

wire [31:0] PCPlus4F;
wire [31:0] PCF;
wire [31:0] instrF;
wire PCSrcE;
wire [31:0] PCPlusImmE;
wire [31:0] Next_PCF;
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

wire [31:0] PCD;
wire [31:0] PCPlus4D;
wire StallDecode;
wire [31:0] Next_PCD;
wire[31:0] instrD;

IF_ID IF_ID (
	.clk(clk),  
	.enable(!StallDecode),
	.flush(rst && (!PCSrcE)),
	//.flush(rst),
	.instrF(instrF),
	.PCF(PCF),
    .PCPlus4F(PCPlus4F),
    // Outputs
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .instrD(instrD)
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
wire[31:0] instrE;

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
	.instrD(instrD),
    // Outputs
	
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
    .Rs1E(Rs1E),
	.Rs2E(Rs2E),
    .RD1E(RD1E),
    .RD2E(RD2E),    
    .mem_maskE(mem_maskE),
    .instrE(instrE)
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
wire [31:0] Next_PCE;
assign Next_PCE = PCSrcE ? PCjumpE : PCPlus4E;
//////////////////////EX_mem////////////////////////////
wire RegWriteM;
wire MemWriteM;
wire [1:0]ResultDesM;
wire [4:0] RdM;
wire [31:0]PCPlus4M;
wire [31:0] PCPlusImmM;
wire [2:0] mem_maskM;
wire [31:0]WriteDataM;
wire [4:0] Rs1M;
wire [4:0] Rs2M;
wire [31:0] RD1M;
wire [31:0] RD2M;
wire [31:0] instrM;
wire [31:0] Next_PCM;
wire [31:0] PCM;

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
    .Rs1E(Rs1E),
	.Rs2E(Rs2E),
    .RD1E(RD1E),
    .RD2E(RD2E),    
    .instrE(instrE),
    .Next_PCE(Next_PCE),
    .PCE(PCE),
    // Outputs
    .RegWriteM(RegWriteM),
    .ResultDesM(ResultDesM),
    .MemWriteM(MemWriteM),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
	.PCPlusImmM(PCPlusImmM),
    .mem_maskM(mem_maskM),
    .Rs1M(Rs1M),
	.Rs2M(Rs2M),
    .RD1M(RD1M),
    .RD2M(RD2M),    
    .instrM(instrM),
    .Next_PCM(Next_PCM),
    .PCM(PCM)
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
wire [4:0] Rs1W;
wire [4:0] Rs2W;
wire [31:0] RD1W;
wire [31:0] RD2W;
wire [31:0] instrW;
wire [31:0] Next_PCW;
wire [31:0] PCW;
wire [2:0] mem_maskW;

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
    .mem_maskM(mem_maskM),
    .Rs1M(Rs1M),
	.Rs2M(Rs2M),
    .RD1M(RD1M),
    .RD2M(RD2M),    
    .instrM(instrM),
    .Next_PCM(Next_PCM),
    .PCM(PCM),
    // Outputs
    .RegWriteW(RegWriteW),
    .ResultDesW(ResultDesW),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
	.PCPlusImmW(PCPlusImmW),
    .PCPlus4W(PCPlus4W),
    .mem_maskM(mem_maskW),
    .Rs1W(Rs1W),
	.Rs2W(Rs2W),
    .RD1W(RD1W),
    .RD2W(RD2W),    
    .instrW(instrW),
    .Next_PCW(Next_PCW),
    .PCW(PCW)
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

 always_ff @(posedge clk or negedge rst) begin
        if (!rst) insn_order <= '0;
        else if (rvfi_valid) insn_order <= insn_order + 1;
    end

    // Assignments
    assign rvfi_valid     = (instrW != 32'h0) && rst;
    assign rvfi_order     = insn_order;
    assign rvfi_insn      = instrW;
    assign rvfi_trap      = 1'b0;
    assign rvfi_halt      = 1'b0;
    assign rvfi_intr      = 1'b0;
    assign rvfi_mode      = 2'b11;
    assign rvfi_ixl       = 2'b01;
    
    assign rvfi_rs1_addr  = Rs1W;
    assign rvfi_rs2_addr  = Rs2W;
    assign rvfi_rs1_rdata = RD1W;
    assign rvfi_rs2_rdata = RD2W;
	
    assign rvfi_rd_addr   = (RegWriteW) ? RdM : 5'd0;
    assign rvfi_rd_wdata  = (egWriteW && RdM != 0) ? ResultDesE : 32'd0;
    
    assign rvfi_pc_rdata  = PCW;
    assign rvfi_pc_wdata  = Next_PCW;
    
    assign rvfi_mem_addr  = ALUResultW;
    
    assign rvfi_mem_rmask = (reg_WB_MemToReg) ? 4'b1111 : 4'b0000; 
    assign rvfi_mem_wmask = (reg_WB_RegWrite == 0 && reg_WB_MemToReg == 0 && reg_WB_insn[6:0] == 7'b0100011) ? 4'b1111 : 4'b0000; 
    
    assign rvfi_mem_rdata = reg_WB_dmem_data;
    assign rvfi_mem_wdata = 32'b0;


endmodule