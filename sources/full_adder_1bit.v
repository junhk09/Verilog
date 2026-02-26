`timescale 1ns / 1ps

module full_adder_1bit(
    input a,b,cin,
    output sum,carry_out
    );
assign sum=a^b^cin;
assign carry_out=(a&b)|(b&cin)|(a&cin);



endmodule
