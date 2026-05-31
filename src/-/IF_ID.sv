module IF_ID (
    input clk,
    input enable,
    input flush,
    input [31:0]instrF,
	input [31:0]PCF,
	input [31:0]PCPlus4F,
	output reg [31:0] PCD,
	output reg [31:0]PCPlus4D,
    output reg [31:0] instrD
);
always@(posedge clk) begin
    if (!flush)begin
	instrD <= 32'b0;
	PCD <= 32'b0;
	PCPlus4D <= 32'b0;
	end
    else if (enable) begin 
	instrD <= instrF;
	 PCD <= PCF;
	 PCPlus4D <= PCPlus4F;
	end
end

endmodule