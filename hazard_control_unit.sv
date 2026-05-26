module hazard_control_unit(  
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdM,
    input [4:0] RdW,
	input [4:0] RdE,
    input RegWriteW,
    input RegWriteM,
    input [1:0] ResultDesE,
    input PCSrcE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
	output reg StallDecode,
    output reg StallFetch
);
	logic loadInstrStall;
    always_comb begin
        if((Rs1E == RdM) && RegWriteM && Rs1E != 0) ForwardAE = 2'b10;
        else if ((Rs1E == RdW) && RegWriteW && Rs1E != 0) ForwardAE = 2'b01;
        else ForwardAE = 2'b00;
   
        if((Rs2E == RdM) && RegWriteM && Rs2E != 0) ForwardBE = 2'b10;
        else if ((Rs2E == RdW) && RegWriteW && Rs2E != 0) ForwardBE = 2'b01;
        else ForwardBE = 2'b00;
		
		loadInstrStall = (ResultDesE == 2'b01 && (RdE == Rs1D || RdE == Rs2D));
        StallDecode = loadInstrStall;
        StallFetch = loadInstrStall;
    end

endmodule