`timescale 1ns / 1ps

// 1010111
module shift_register(
    input clk, //100MHz
    input reset, //SW[15]
  input [1:0] btn,
    output [7:0] led
    );
//btnU를 누르면1, btnD를 누르면 0으로 동작.
wire [1:0] w_btn;
btn_debouncer u_btn_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn),   
        .debounced_btn(w_btn)
);
reg [6:0] sr7;
always @(posedge clk, posedge reset) begin
    if(reset) begin
        sr7<=7'b0000000;
    end else if(w_btn[0]) begin
        sr7<={sr7[5:0],1'b1}; // shift register
    end else if(w_btn[1]) begin
             sr7<={sr7[5:0],1'b0}; // shift register
    end
       

end 
assign led[7:1]=(sr7==7'b1010111) ? 7'b0000000:sr7;

assign led[0]=(sr7==7'b1010111) ? 1'b1: 1'b0;

endmodule
