module EX_Mem(  
    input clk,
	input rst,
    input RegWriteE,
    input [1:0] ResultDesE,
    input MemWriteE,
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [4:0] RdE,
    input [31:0] PCPlus4E,
	input [31:0] PCPlusImmE,
    input [2:0] mem_maskE,
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [31:0] RD1E,
    input [31:0] RD2E,
    input [31:0] instrE,
    input [31:0] Next_PCE,
    input [31:0] PCE,

    output reg RegWriteM,
    output reg [1:0] ResultDesM,
    output reg MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] PCPlus4M,    
	output reg [31:0] PCPlusImmM,
    output reg [2:0]mem_maskM,
    output reg [4:0] Rs1M,
    output reg [4:0] Rs2M,
    output reg [31:0] RD1M,
    output reg [31:0] RD2M,
    output reg [31:0] instrM,
    output reg [31:0] Next_PCM,
    output reg [31:0] PCM

);

    always@(posedge clk) begin
		if(!rst)begin
			RegWriteM   <= 1'b0;
            ResultDesM  <= 2'b0;
            MemWriteM   <= 1'b0;
            ALUResultM  <= 32'b0;
            WriteDataM  <= 32'b0;
            RdM         <= 5'b0;
            PCPlus4M    <= 32'b0;
            PCPlusImmM  <= 32'b0;
            mem_maskM   <= 3'b0;
            Rs1M        <= 5'b0;
            Rs2M        <= 5'b0;
            RD1M        <= 32'b0;
            RD2M        <= 32'b0;
            instrM      <= 32'b0;
            Next_PCM    <= 32'b0;
            PCM         <= 32'b0;
		end
        
		else begin
        RegWriteM <= RegWriteE;
        ResultDesM <= ResultDesE;
        MemWriteM <= MemWriteE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
		PCPlusImmM <= PCPlusImmE;
        mem_maskM <= mem_maskE;
        Rs1M        <= Rs1E;
        Rs2M        <= Rs2E;
        RD1M        <= RD1E;
        RD2M        <= RD2E;
        instrM      <= instrE ;
        Next_PCM    <= Next_PCE;
        PCM         <= PCE;
		end
    end
        
endmodule