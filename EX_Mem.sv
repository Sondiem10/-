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
    output reg RegWriteM,
    output reg [1:0] ResultDesM,
    output reg MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] PCPlus4M,    
	output reg [31:0] PCPlusImmM,
    output reg [2:0]mem_maskM
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
		end
    end
        
endmodule