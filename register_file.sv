 module register_file(
    input clk,
	input rst,
    input [4:0]A1,
    input [4:0]A2,
	input [4:0]A3,
	input [31:0]WD,
	input RegWrite,
    output reg [31:0]RD1,
    output reg [31:0]RD2
);
reg [31:0] reg_file [31:0];  

	always@(posedge clk) begin
        if (!rst) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) reg_file[i] <= 32'b0;
			/*reg_file[9] <= 32'd5;
			reg_file[18] <= 32'd30;
			reg_file[19] <= 32'd25;
			reg_file[20] <= 32'd3;*/
        end 
        else if (RegWrite && (A3 != 5'b0)) reg_file[A3] <= WD;
    end
	
	always_comb begin
		if (RegWrite && (A3 == A1)) RD1 = WD;
		else if (A1==0) RD1 = 0;
        else RD1 = reg_file[A1];

        if (RegWrite && (A3 == A2))  RD2 = WD;
		else if (A2==0) RD2 = 0;
		else RD2 = reg_file[A2];
    end
endmodule