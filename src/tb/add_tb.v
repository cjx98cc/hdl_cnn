`timescale 1ns / 1ps

module add_tb;

    // Parameters
    localparam HALFWORD_WIDTH = 16;

    // Testbench signals
    reg [HALFWORD_WIDTH-1:0] A;   // Input A
    reg [HALFWORD_WIDTH-1:0] B;   // Input B
    wire [HALFWORD_WIDTH-1:0] out; // Output result

    // Instantiate the Device Under Test (DUT)
    add #(
        .HALFWORD_WIDTH(HALFWORD_WIDTH)
    ) dut (
        .A(A),
        .B(B),
        .out(out)
    );

    // Test Procedure
    initial begin
        // Monitor outputs
        $monitor("Time: %0dns | A: %b | B: %b | out: %b (%d)", $time, A, B, out, $signed(out));

        // Test Case 1: Positive + Positive
        A = 16'b0000000000000011; // 3
        B = 16'b0000000000000101; // 5
        #10; // Wait for output
        // Expected out = 3 + 5 = 8

        // Test Case 2: Positive + Negative
        A = 16'b0000000000000100; // 4
        B = 16'b1111111111111101; // -3
        #10; // Wait for output
        // Expected out = 4 + (-3) = 1

        // Test Case 3: Negative + Negative
        A = 16'b1111111111111000; // -8
        B = 16'b1111111111110110; // -6
        #10; // Wait for output
        // Expected out = -8 + (-6) = -14

        // Test Case 4: Positive + Positive with overflow
        A = 16'b0111111111111111; // 32767
        B = 16'b0000000000000001; // 1
        #10; // Wait for output
        // Expected out = 32767 + 1 = -32768 (overflow)

        // Test Case 5: Negative + Positive with overflow
        A = 16'b1111111111111111; // -1
        B = 16'b0000000000000001; // 1
        #10; // Wait for output
        // Expected out = -1 + 1 = 0

        // Test Case 6: Zero + Zero
        A = 16'b0000000000000000; // 0
        B = 16'b0000000000000000; // 0
        #10; // Wait for output
        // Expected out = 0

        // Test Case 7: Edge Case: Maximum + Minimum
        A = 16'b0111111111111111; // 32767
        B = 16'b1000000000000000; // -32768
        #10; // Wait for output
        // Expected out = 32767 + (-32768) = -1

        // Test Case 8: Edge Case: Minimum + Minimum
        A = 16'b1000000000000000; // -32768
        B = 16'b1000000000000000; // -32768
        #10; // Wait for output
        // Expected out = -32768 + (-32768) = 0 (overflow to positive)

        // Finish the simulation
        $finish;
    end

endmodule : add_tb
