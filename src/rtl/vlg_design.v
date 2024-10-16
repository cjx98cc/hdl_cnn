module vlg_design (
    input      clk,
    input      rst,
    input      a,
    b,
    output reg c
);
   always @(posedge clk or negedge rst)
      if (rst) c <= 1'b0;
      else c <= a & b;

endmodule
