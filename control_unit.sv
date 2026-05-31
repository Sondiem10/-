module control_unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7,
    output reg RegWriteD,
    output reg [1:0]ResultDesD,
    output reg MemWriteD,
    output reg JumpD,
    output reg BranchD,
    output reg [3:0]ALUControlD,
    output reg ALUSrcD,
    output reg [2:0]ImmSrcD,
    output reg [2:0] mem_mask
);

 reg [10:0] controls;
 assign {RegWriteD, ResultDesD, MemWriteD, JumpD, BranchD, ALUSrcD, ImmSrcD}= controls;
 
  always_comb begin
    controls = 10'b0;
    ALUControlD = 4'b0000;
    mem_mask = 3'b000;

    case(op)
	// I-type (load)
        7'b0000011: begin
            controls= {1'b1, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000};
            ALUControlD = 4'b0000;
            mem_mask = funct3;
        end
		
	// I-type 
        7'b0010011: begin
            controls = {1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 3'b000};
            case(funct3) 
                3'h0: ALUControlD = 4'b0000; // addi
                3'h4: ALUControlD = 4'b0100; // xori
                3'h6: ALUControlD = 4'b0011;  // ori
                3'h7: ALUControlD = 4'b0010;  // andi
                3'h1: ALUControlD = 4'b0111; // slli
                3'h5: begin
                if(funct7==1'b0)ALUControlD = 4'b1000; // srli
                else if(funct7==1'b1)ALUControlD = 4'b1011; // srai
                end
                3'h2: ALUControlD = 4'b0101; // slt
                3'h3: ALUControlD = 4'b0110; // sltu
                default: ALUControlD = 4'b0000;
            endcase
        end
		
	// S-type 
        7'b0100011: begin
            controls = {1'b0, 2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 3'b001};
            ALUControlD = 4'b0000; 
            mem_mask = funct3;
        end
		
	// R-type
        7'b0110011: begin
            controls= {1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 3'b000};
            case(funct3)
                 3'h0:begin
                 if(funct7==1'b0) ALUControlD = 4'b0000; // add
                 else if(funct7==1'b1) ALUControlD = 4'b0001; // sub
                 end
                 3'h4: ALUControlD = 4'b0100; // xor
                 3'h6: ALUControlD = 4'b0011; // or
                 3'h7: ALUControlD = 4'b0010; // and
                 3'h1: ALUControlD = 4'b0111; // sll
                 3'h5: begin
                if(funct7==0)ALUControlD = 4'b1000; // srli
                else if(funct7==1)ALUControlD = 4'b1011; // srai
                end
                 3'h2: ALUControlD = 4'b0101; // slt
                 3'h3: ALUControlD = 4'b0110; // sltu
                default: ALUControlD = 4'b0000;
            endcase
        end
		
	 // U-type
        7'b0110111: begin
            controls = {1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 3'b100};
            ALUControlD = 4'b1111;		// LUI
        end
		7'b0010111: begin
            controls = {1'b1, 2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 3'b100};
            ALUControlD = 4'b0000; // AUIPC
        end
		
	// B-type
        7'b1100011: begin
            controls= {1'b0, 2'b00,1'b0, 1'b0, 1'b1, 1'b0, 3'b010};
            case(funct3)
                3'h0: ALUControlD = 4'b0001; // beq (subtract and check for zero)
			  3'h1: ALUControlD = 4'b1100; // bne (subtract and check for non-zero)
                3'h4: ALUControlD = 4'b0101; // blt (slt)
                3'h5: ALUControlD = 4'b1001; // bge (slt, with inversion)
                3'h6: ALUControlD = 4'b0110; // bltu (sltu)
                3'h7: ALUControlD = 4'b1010; // bgeu (sltu, with inversion)
                default: ALUControlD = 4'b0000;
            endcase
        end
		
	// J-type
        7'b1101111: begin
            controls = {1'b1, 2'b10, 1'b0, 1'b1, 1'b0,1'b0 ,3'b011};
            ALUControlD = 4'b0000;
        end
		
	//JALR
        7'b1100111: begin
            controls = {1'b1, 2'b10, 1'b0, 1'b1, 1'b0, 1'b0, 3'b000};
            ALUControlD = 4'b0000;
        end
        
    endcase
end

endmodule
