`timescale 1ns / 1ps // 1.999ns
// 10ns 
module tb_gatetest();
    reg i_a; // a는 변수이며, 1bit 저장 memory
    reg i_b; // 하드웨어 연결 없이 테스트 해봄

    wire [4:0] o_led; //led[0]~[4]
    // named port mapping 방식

    gatetest u_gatetest( //gatetest 모듈을 u_gatetest이름으로 선언. 구조체같은 느낌
         .a(i_a),
         .b(i_b), 
         .led(o_led) 
    );
    // a b
    // 0 0
    // 1 0
    // 0 1
    // 1 1
    initial begin
        #00 i_a=1'b0; i_b=1'b0;
        #20 i_a=1'b0; i_b=1'b1; //20ns 뒤에 0,1 대입
        #20 i_a=1'b1; i_b=1'b0;
        #20 i_a=1'b1; i_b=1'b1;
        #20 $stop;
    end
endmodule
