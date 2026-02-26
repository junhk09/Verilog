`timescale 1ns / 1ps

module tb_fsm_pattern();
reg clk;
reg reset;
reg in;
wire out;
fsm_pattern u_fsm_pattern(
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
);
always  #5 clk=~clk;
initial begin
$monitor("time=%t, state=%b, in=%b, out=%b", $time, fsm_pattern.cur_state,in,out);
end

initial begin
clk=0;
reset=1;
in=0;
#100 reset=0;
@(posedge clk) in=0;
@(posedge clk) in=1;
@(posedge clk) in=0;
@(posedge clk) in=1;
@(posedge clk) in=1;
@(posedge clk) in=0;
@(posedge clk) in=0;
@(posedge clk) in=1;
@(posedge clk) in=0;
@(posedge clk) in=0;
@(posedge clk) in=1;
@(posedge clk) in=1;
@(posedge clk) in=0;
@(posedge clk) in=1;
@(posedge clk) in=1;
@(posedge clk) in=0;
#20;
$display("Finished");
$finish;
end



endmodule
