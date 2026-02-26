`timescale 1ns / 1ps

module testbench_half_adder();
    reg a, b;
    wire sum, carry_out;
    
hadder dut(
    .a(a), 
    .b(b),
    .sum(sum), 
    .carry_out(carry_out)
    ); 
    
    initial begin
        #00 a = 1'b0; b = 1'b0;
        #10 a = 1'b0; b = 1'b1;
        #10 a = 1'b1; b = 1'b0;
        #10 a = 1'b1; b = 1'b1;
        #10 $finish;
    end

endmodule
