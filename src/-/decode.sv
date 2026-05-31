module decode(
    input clk,
    input rst,
    input [31:0] instrD,
    input RegWrite,       
    input [31:0] WD,      
    input [4:0] WA,       
   
    output reg [4:0] Rs1D,
    output reg [4:0] Rs2D,
    output [1:0] ResultDesD,
    output RegWriteD,
    output MemWriteD,
    output JumpD,
    output BranchD,
    output [3:0] ALUControlD,
    output ALUSrcD,
    output [2:0] mem_maskD,
    output [31:0] ExtImmD,
    output [31:0] RD1D,
    output [31:0] RD2D,
    output [4:0] RdD
);
    wire [2:0] ImmSrcD;
    assign RdD = instrD[11:7];
	assign Rs1D = instrD [19:15];
	assign Rs2D = instrD [24:20];
	

    control_unit control_unit_inst (
        .op(instrD[6:0]),
        .funct3(instrD[14:12]),
        .funct7(instrD[30]), 
        .RegWriteD(RegWriteD),
        .ResultDesD(ResultDesD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .mem_mask(mem_maskD)  
    );

    register_file register_file_inst (
        .clk(clk),
        .rst(rst),
        .A1(instrD[19:15]),
        .A2(instrD[24:20]),
        .A3(WA),
        .WD(WD),
        .RegWrite(RegWrite),
        .RD1(RD1D),
        .RD2(RD2D)      
    );

    imm_gen imm_gen_inst (
        .Immediate(instrD[31:7]),
        .ImmSrcD(ImmSrcD),
        .ExtImmD(ExtImmD)
    );

endmodule