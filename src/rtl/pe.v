`timescale 1ns / 1ps

// DATA_SIZE 8 (Q4.3, value range (-8, 7.875))
// 1 sign bit
// 4 integer bits
// 3 fractional bits
`define DATA_SIZE 8
// -128 to 127.984375
`define HALFWORD_WIDTH 16

// single conv kernel: ReLU(b+ \sigma{WX}), kernel size is period
module pe #(
    parameter PERIOD = 25 // conv kernel is 5*5
) (
    input                               clk,        // clock
    input                               rst,        // async reset
    input  signed [     `DATA_SIZE-1:0] weight,     // convolution kernel
                                        inmap,      // input feature map
    input                               inmap_vld,  // valid feature map flag
                                        weight_vld, // valid weight flag
    input  signed [     `DATA_SIZE-1:0] bias,       // bias weight
    output signed [     `DATA_SIZE-1:0] outmap,     // output map: accumulated relu(wx+b)
    output                              outmap_vld, // valid output flag
    output signed [`HALFWORD_WIDTH-1:0] outraw   // none actiavte and 16bit output ( wx+b )
);


  wire                       in_vld;  // all inputs valid flag (inmap and weight)
  reg  [               10:0] cnt;     // counter for cycle
  wire [`HALFWORD_WIDTH-1:0] vldproduct;
  wire [`HALFWORD_WIDTH-1:0] biased;  // (w*x) + b
  wire [`HALFWORD_WIDTH-1:0] product; // w*x
  wire [`HALFWORD_WIDTH-1:0] sum;     // b+ w1x1 + w2x2+...
  reg  [`HALFWORD_WIDTH-1:0] sum_reg;

  // inmap * weight (signed scaler w*x)
  // Q4.3 * Q4.3 -> Q8.6
  signedm #(
      .HALFWORD_WIDTH (`HALFWORD_WIDTH),
      .DATA_SIZE      (`DATA_SIZE)
  ) SIGNEDM (
      .a        (inmap),
      .b        (weight),
      .data_out (product)
  );  // an 8 bit multiplexer for signed data


  // bit extension should be aligned with w*x
  add #(
      .HALFWORD_WIDTH (`HALFWORD_WIDTH)
  ) ADD (
      .A   (vldproduct),
      .B   (sum),
      .out (biased)
  );

  assign in_vld     = inmap_vld & weight_vld;                                  // when inputs are all valid
  assign sum        = (cnt == 0) ? {bias[7], 5'b0, bias[6:0], 3'b0} : sum_reg; // init of bias should be extended to 16bit, and aligned with Q8.6 of multiplexer
  assign vldproduct = (in_vld == 1'b1) ? product : 16'b0;                      // pass w*x when input is valid
  assign outraw  = (in_vld == 1'b1) ? biased : 16'b0;                       // store outraw for output feature map
  assign outmap_vld = cnt == (PERIOD - 1);

  // relu activation, bit truncation for radix complement (same operation)
  assign outmap     = (outraw[15]) ? 8'b0 :                                 // if outraw < 0 :vladbiased=0;
                      (outraw[2]) ? {outraw[15], outraw[9:3] + 1'b1} :
                      {outraw[15], outraw[9:3]};  // bit truncation

  // counter logic
  always @(posedge rst or posedge clk) begin
    if (rst) cnt <= 0;
    else begin
      if (in_vld) begin
        cnt <= cnt + 1;
        if (cnt == (PERIOD - 1)) begin
          cnt <= 0;
        end
      end
    end
  end

  always @(posedge rst or posedge clk) begin
    if (rst) begin
      sum_reg <= 0;
    end else begin
      if (in_vld) begin
        sum_reg <= outraw;
        if (cnt == (PERIOD - 1)) begin
          sum_reg <= 0;
        end
      end
    end
  end

endmodule : pe
