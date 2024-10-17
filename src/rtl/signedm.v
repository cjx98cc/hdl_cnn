// multiplexer for signed data (default by 8 bits)
// Q4.3 -> Q8.6
// int8 * 2e-3 * int8 * 2e-3 -> int16 * 2e-6
module signedm #(
    parameter DATA_SIZE      = 8,
    parameter HALFWORD_WIDTH = 16
) (
    input  signed [     DATA_SIZE-1:0] a,
                                       b,
    output signed [HALFWORD_WIDTH-1:0] data_out
);
  assign data_out = a * b; // MSB is the sign bit

endmodule
