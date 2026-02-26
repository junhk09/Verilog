`timescale 1ns / 1ps

// module tb_mux2_1();
// // 입력: reg, 출력: wire

// reg r_a;
// reg r_b;
// reg r_sel;
// wire w_out;

//  mux u_mux(
//     .a(r_a),
//     .b(r_b),
//     .sel(r_sel),
//     .out(w_out)
//     );
// initial begin
//     r_a=0;
//     r_b=0;
//     r_sel=0;
//     // 초기값 설정
//     $monitor("Time:%0t | sel=%b, a=%b, b=%b, out=%b",$time,r_sel,r_a,r_b,w_out);

//     #10 r_sel=1; r_a=1; r_b=0; // w_out=1이 나와야 한다.
//     #10 r_sel=1; r_a=0; r_b=1; // w_out=0이 나와야 한다.
//     #10 r_sel=0; r_a=1; r_b=0; // w_out=0이 나와야 한다.
//     #10 r_sel=0; r_a=0; r_b=1; // w_out=1이 나와야 한다.
//     #10 $finish;
//     // sel=1 이면 a, 0이면 b출력 mux모델에 나와있음.
    

// end

// endmodule
module tb_mux2_1();
reg [3:0]r_a;
reg [3:0]r_b;
reg r_sel;
wire [3:0]w_out;

 mux u_mux(
    .a(r_a),
    .b(r_b),
    .sel(r_sel),
    .out(w_out)
    );
initial begin
    r_a=4'hA;
    r_b=4'h3;
    r_sel=0;
    // 초기값 설정
    $monitor("Time:%0t | sel=%b, a=%h, b=%h, out=%h",$time,r_sel,r_a,r_b,w_out);

    #10 r_sel=1; r_a=4'hE; r_b=4'h7; // w_out=E이 나와야 한다.
    #10 r_sel=1; r_a=4'hF; r_b=4'hA; // w_out=F이 나와야 한다.
    #10 r_sel=0; r_a=4'h7; r_b=4'hA; // w_out=A이 나와야 한다.
    #10 r_sel=0; r_a=0; r_b=1; 
    #10 $finish;
    // sel=1 이면 a, 0이면 b출력 mux모델에 나와있음.
    

end

endmodule
