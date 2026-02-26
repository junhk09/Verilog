`timescale 1ns / 1ps

module hadder(a, b, sum, carry_out);
    input a, b;
    output sum, carry_out;
    
    assign sum = a ^ b;
    assign carry_out = a & b;

endmodule
