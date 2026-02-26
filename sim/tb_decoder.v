`timescale 1ns / 1ps


module tb_decoder();
reg [1:0]r_a;

wire [3:0]w_led;

 decoder u_mux(
    .a(r_a),
    .led(w_led)
    );
initial begin
    r_a=2'b00;
    #10 r_a=2'b01;
    #10 r_a=2'b01;
    #10 r_a=2'b10;
    #10 r_a=2'b11;
    #10 $finish;


    // sel=1 이면 a, 0이면 b출력 mux모델에 나와있음.
    

end

endmodule