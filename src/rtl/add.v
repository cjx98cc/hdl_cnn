// adder for signed data (default by 16 bits)
//
// nothing special needed for the adder with Q4.3,
// since int16*2e-3 + int16*2e-3 = (int16+int16)*2e-3
module add #(
    parameter HALFWORD_WIDTH = 16 // high precision calculation
) (
    input  signed [HALFWORD_WIDTH-1:0] A,  // Input A
    input  signed [HALFWORD_WIDTH-1:0] B,  // Input B
    output signed [HALFWORD_WIDTH-1:0] out // Output result
);
  assign out = A + B;

endmodule
