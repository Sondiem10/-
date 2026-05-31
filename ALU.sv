module ALU (  
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [3:0]  ALUControl,
    output logic  Flush,          
    output logic [31:0] ALUResult
);
    always_comb begin
        ALUResult = 32'd0;
        Flush     = 1'b0;
        
        case (ALUControl)
            4'b0000 : ALUResult = SrcA + SrcB;                  // ADD, ADDI
            4'b0010 : ALUResult = SrcA & SrcB;                  // AND
            4'b0011 : ALUResult = SrcA | SrcB;                  // OR
            4'b0100 : ALUResult = SrcA ^ SrcB;                  // XOR
            4'b0111 : ALUResult = SrcA << SrcB[4:0];            // SLL
            4'b1000 : ALUResult = SrcA >> SrcB[4:0];            // SRL
            4'b1011 : ALUResult = $signed(SrcA) >>> SrcB[4:0];  // SRA 
            4'b1111 : ALUResult = SrcB;                         // LUI 
            
            4'b0001 : begin // BEQ
                ALUResult = SrcA - SrcB; 
                Flush     = (SrcA == SrcB); 
            end  
            4'b1100 : begin  // BNE
                ALUResult = SrcA - SrcB;
                Flush     = (SrcA != SrcB);
            end            
            4'b0101 : begin  // BLT
                ALUResult = {31'b0, ($signed(SrcA) < $signed(SrcB))};
                Flush     = ($signed(SrcA) < $signed(SrcB));
            end
            4'b0110 : begin  // BLTU
                ALUResult = {31'b0, (SrcA < SrcB)};
                Flush     = (SrcA < SrcB);
            end
            4'b1001 : begin // BGE
                ALUResult = {31'b0, ($signed(SrcA) >= $signed(SrcB))};
                Flush     = ($signed(SrcA) >= $signed(SrcB));
            end
            4'b1010 : begin // BGEU
                ALUResult = {31'b0, (SrcA >= SrcB)};
                Flush     = (SrcA >= SrcB);
            end
            default : begin
                ALUResult = 32'd0;
                Flush     = 1'b0;
            end
        endcase
    end
endmodule