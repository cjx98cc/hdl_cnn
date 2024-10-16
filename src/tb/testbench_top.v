`timescale 1ns / 1ps

// define parameter
`define CLK_PERIORD 10 // CLK period -> 10ns (100MHz)

module testbench_top ();

   reg  clk;
   reg  rst;
   reg  a;
   reg  b;
   wire c;

   vlg_design uut_vlg_design (
       .clk(clk),
       .rst(rst),
       .a  (a),
       .b  (b),
       .c  (c)
   );

   initial begin
      clk <= 0;
      rst <= 1;
      #1000;
      rst <= 0;
   end

   always #(`CLK_PERIORD / 2) clk = ~clk;

   initial begin
      a <= 0;
      b <= 0;
      @(negedge rst);
      @(posedge clk);
      a <= 0;
      b <= 0;

      @(posedge clk);
      a <= 1;
      b <= 0;

      @(posedge clk);
      a <= 0;
      b <= 1;

      @(posedge clk);
      a <= 1;
      b <= 1;

      @(posedge clk);
      a <= 0;
      b <= 0;

      repeat (10) begin
         @(posedge clk);
      end

      $stop;

   end





endmodule
