`timescale 1ns / 1ps
// 4bit+ 4bit=>carry, 4비트의 sum
module add4_sub4(
    input [7:0] sw,
    input sel, 
    output carry_out,
    output [3:0] sum
    );
// assign {carry_out,sum[3:0]}=sw[3:0]+sw[7:4];
assign {carry_out,sum[3:0]}=sel?sw[3:0]+sw[7:4]:sw[3:0] + ~sw[7:4]+4'b1; 
// 삼항연산자로 감속기(뺄셈) 구현


endmodule
