module PC(
    input clk,
    input reset,
	input enable,
	input PCSrcE,
	input [31:0] PCjumpE,
    output reg [31:0] PCF,
	output [31:0] PCPlus4F
);

assign  PCPlus4F = PCF + 4; 
always@(posedge clk)begin
    if (!reset) PCF <= 32'h00000000;
    else if (enable) PCF <= PCSrcE ? PCjumpE : PCPlus4F;
end

endmodule