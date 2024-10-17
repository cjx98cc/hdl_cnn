`timescale 1ns / 1ps

`define HALFWORD_WIDTH 16
`define DATA_SIZE 8

module pe_tb;

    // Parameters
    localparam PERIOD = 25; // Use the same period as the module parameter

    // Testbench signals
    reg clk;                          // Clock signal
    reg rst;                          // Reset signal
    reg signed [`DATA_SIZE-1:0] weight;     // Convolution kernel
    reg signed [`DATA_SIZE-1:0] inmap;      // Input feature map
    reg inmap_vld;                   // Valid feature map flag
    reg weight_vld;                  // Valid weight flag
    reg signed [`DATA_SIZE-1:0] bias;       // Bias weight
    wire signed [`DATA_SIZE-1:0] outmap;    // Output map
    wire outmap_vld;                 // Valid output flag
    wire signed [`HALFWORD_WIDTH-1:0] outraw; // wx+b

    // Instantiate the Device Under Test (DUT)
    pe #(
        .PERIOD(PERIOD)
    ) dut (
        .clk(clk),
        .rst(rst),
        .weight(weight),
        .inmap(inmap),
        .inmap_vld(inmap_vld),
        .weight_vld(weight_vld),
        .bias(bias),
        .outmap(outmap),
        .outmap_vld(outmap_vld),
        .outraw(outraw)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns period
    end

    // Reset generation
    initial begin
        rst = 1;            // Start with reset
        #10 rst = 0;       // Release reset after 10 ns
    end

    // Stimulus generation
    initial begin

        $monitor("Time: %0dns | weight: %0f | bias: %0f | inmap: %0f | outmap: %0f | outraw: %0f", $time, weight/8.0, inmap/8.0, bias/8.0, outmap/8.0, outraw/64.0);
        // Initialize inputs
        weight = 8'b00000000;
        inmap = 8'b00000000;
        inmap_vld = 0;
        weight_vld = 0;
        bias = 8'b00000000;

        // Wait for reset to complete
        @(negedge rst);

        weight = 8'b00000101;
        inmap = 8'b00000011;
        bias = 8'b00000010;
        inmap_vld = 1;
        weight_vld = 1;

        // Wait for one clock period
        @(posedge clk);

        // Wait for the output valid signal
        wait(outmap_vld);

        weight = 8'b10000011;
        inmap = 8'b00000010;

        @(posedge clk);
        wait(outmap_vld);

        weight = 8'b00000000;
        inmap = 8'b00000000;

        @(posedge clk);
        wait(outmap_vld);

        weight = 8'b00000011;
        inmap = 8'b00000100;

        @(posedge clk);
        wait(outmap_vld);

        weight = 8'b00001110;
        inmap = 8'b11111111;
        bias = 8'b00000001;

        @(posedge clk);
        wait(outmap_vld);

        repeat (20) @(posedge clk);

        bias = 8'b00001001;
        repeat (25) @(posedge clk);
        // Finish the simulation
        $finish;
    end

endmodule : pe_tb
