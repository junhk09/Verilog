`timescale 1ns / 1ps
module adder4(
    input [3:0]a,[3:0]b,
    input cin,
    output [3:0]sum, 
    output carry_out
    );
    wire carry1,carry2,carry3;

full_adder_1bit FA0(
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .carry_out(carry1)
);
full_adder_1bit FA1(
    .a(a[1]),
    .b(b[1]),
    .cin(carry1),
    .sum(sum[1]),
    .carry_out(carry2)
);
full_adder_1bit FA2(
    .a(a[2]),
    .b(b[2]),
    .cin(carry2),
    .sum(sum[2]),
    .carry_out(carry3)
);
full_adder_1bit FA3(
    .a(a[3]),
    .b(b[3]),
    .cin(carry3),
    .sum(sum[3]),
    .carry_out(carry_out)
);



endmodule
