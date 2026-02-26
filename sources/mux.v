`timescale 1ns / 1ps
// module mux(
//     input a,
//     input b,
//     input sel,
//     output out
//     );

//     assign out = (sel==1) ? a : b; //연속 할당문
// endmodule
// module mux2_1(
//     input a,
//     input b,
//     input sel,
//     output  out
//     );
//     reg r_out;
//     always @(*) begin
//         case (sel)
//            1'b1 : r_out=a;
//            1'b0 : r_out=b; 
//         endcase
//     end
// assign out=r_out;
// endmodule
module mux(
    input [3:0]a,
    input [3:0]b,
    input sel,
    output  [3:0] out
    );
    reg [3:0] r_out;
    always @(*) begin
        case (sel)
           1'b1 : r_out=a;
           1'b0 : r_out=b; 
        endcase
    end
assign out=r_out;


endmodule
