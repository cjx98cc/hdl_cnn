`timescale 1ns/1ps

module signedm_tb;
    reg signed [7:0] a, b;
    wire signed [15:0] data_out;

    signedm dut (
        .a(a),
        .b(b),
        .data_out(data_out)
    );

    initial begin
        $monitor("Time: %0t | a: %d, b: %d, data_out: %d", $time, a, b, data_out);

        // Test Case 1: 60*2e-3 * -20*2e-3
        a = 8'b00111100;
        b = 8'b11101100;
        #10;
        // Expected output: -1200*2e-6

        // Test Case 2: -16*2e-3 * 32*2e-3
        a = 8'b11110000;
        b = 8'b00100000;
        #10;
        // Expected output: -512*2e-6

        // Test Case 3: -16*2e-3 * -96*2e-3
        a = 8'b11110000;
        b = 8'b10100000;
        #10;
        // Expected output: 1536*2e-6

        // Test Case 4: 112*2e-3 * 32*2e-3
        a = 8'b01110000;
        b = 8'b11100000;
        #10;
        // Expected output: 3584*2e-6

        $finish;
    end
endmodule
