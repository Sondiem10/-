module imm_gen(
    input  [24:0] Immediate,
    input  [2:0]  ImmSrcD, 
    output reg [31:0] ExtImmD 
);

  always_comb begin
    case(ImmSrcD)
        3'b000: ExtImmD = {{20{Immediate[24]}}, Immediate[24:13]}; 
        3'b001: ExtImmD = {{20{Immediate[24]}}, Immediate[24:18], Immediate[4:0]}; 
        3'b010: ExtImmD = {{20{Immediate[24]}}, Immediate[0], Immediate[23:18], Immediate[4:1], 1'b0};
        3'b100: ExtImmD = {Immediate[24:5], 12'b0}; 
        3'b011: ExtImmD = {{12{Immediate[24]}}, Immediate[12:5], Immediate[13], Immediate[23:14], 1'b0}; 
        default: ExtImmD = 32'd0;
    endcase
  end

endmodule