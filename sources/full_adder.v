`timescale 1ns / 1ps
module full_adder(
    
    input a, b,cin,
    output sum, carry_out
   
);
 wire sum1, carry_out1, carry_out2;
    hadder u1_half_adder(
    .a(a),
    .b(b),
    .sum(sum1),
    .carry_out(carry_out1)

    );
    hadder u2_half_adder(
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry_out(carry_out2)

    );
    assign carry_out = carry_out1 | carry_out2;


endmodule
