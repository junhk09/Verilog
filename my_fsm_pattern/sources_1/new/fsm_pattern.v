`timescale 1ns / 1ps

module fsm_pattern(
    input clk,
    input reset,
    input in,
    output reg out
    );
parameter start=3'd0,st1=3'd1,st2=3'd2,st3=3'd3,st4=3'd4;
reg [2:0] cur_state=start;
reg [2:0] next_state;

always@(*) begin

case(cur_state)
    start: next_state=in ? start : st1;
    st1: next_state=in ? st2 : st1;
    st2: next_state=in ? st3 : st1;
    st3: next_state=in ? start : st4;
    st4: next_state=in ? st2 : st1;

    default: next_state=start;
endcase
end


always@(posedge clk, posedge reset) begin
   if(reset)
     cur_state<=start;
     else 
     cur_state<=next_state;
end

always@(*) begin
    out=1'b0;
    case(cur_state)
    st3: begin
            if (in==1'b0) out=1'b1;
            else out=1'b0;
    end
    default: out=1'b0;
endcase

end





endmodule
