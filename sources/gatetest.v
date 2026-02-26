`timescale 1ns / 1ps

module gatetest(
    input wire a,
    input b, // wire는 default이며, 생략가능하다.
            // 아무런 언급을 안하면 1bit가 default값이다.

    output [4:0] led //led[0]~[4]
    
    );
   
 assign led[0]=a&b;      //연속 할당문, assign=연결한다 <= AND
    assign led[1]=a|b;      // OR
    assign led[2]=~(a&b);   //NAND
    assign led[3]=~(a|b);   //NOR
    assign led[4]=a^b;      //XOR

endmodule
