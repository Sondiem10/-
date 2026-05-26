module execute (
    input clk, 
    input [3:0] ALUControlE,
    input AluSrcE,
    input [31:0] RD1E,
    input [31:0] RD2E,
    input [31:0] PCE,
    input [31:0] ExtImmE,
	input [1:0] ForwardAE,
    input [1:0] ForwardBE, 
	input [31:0] ResultW,
    input [31:0] ALUResultM,
	
    output logic FlushE,
    output [31:0] PCPlusImmE,
    output [31:0] ALUResultE,
	output reg [31:0] WriteDataE
);

  reg [31:0] SrcBE;
  reg [31:0] SrcBE2;
    always_comb begin
		WriteDataE = SrcBE2;
        if (AluSrcE) SrcBE = ExtImmE;
        else SrcBE = SrcBE2;
    end
	
   assign PCPlusImmE = $signed(PCE) + $signed(ExtImmE);
 
   reg [31:0] SrcAE;
   always_comb begin
       case(ForwardAE)
	   4'h0: SrcAE = RD1E;
	   4'h1: SrcAE = ResultW;
	   4'h2: SrcAE = ALUResultM;
	   4'h3: SrcAE = 32'b0;
	   endcase
    end
	
	 always_comb begin
       case(ForwardBE)
	   4'h0: SrcBE2 = RD2E;
	   4'h1: SrcBE2 = ResultW;
	   4'h2: SrcBE2 = ALUResultM;
	   4'h3: SrcBE2 = 32'b0;
	   endcase
    end

    ALU ALU(
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .Flush(FlushE),
        .ALUResult(ALUResultE)
    );

endmodule
