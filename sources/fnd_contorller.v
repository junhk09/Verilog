`timescale 1ns / 1ps

//==================================================
// FND 컨트롤러
//==================================================
module fnd_contorller(
    input clk,
    input reset,
    input tick,
    input [13:0] in_data,
    output [3:0] an,
    output [7:0] seg
);

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;

    // 자리 선택
    fnd_digit_select u_fnd_digit_select(
        .reset(reset),
        .tick(tick),
        .sel(w_sel)
    );

    // 14-bit 숫자를 BCD 4자리로 변환
    bin2bcd4digit u_bin2bcd4digit(
        .in_data(in_data),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000(w_d1000)
    );

    // 각 자리 출력
    fnd_digit_display u_fnd_digit_display(
        .digit_sel(w_sel),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000(w_d1000),
        .an(an),
        .seg(seg)
    );

endmodule

//==================================================
// 14-bit 입력을 4자리 BCD로 변환
//==================================================
module bin2bcd4digit(
    input [13:0] in_data,
    output [3:0] d1, d10, d100, d1000
);

    // 일시정지(11111)일 때 특수 패턴 할당
    assign d1000 = (in_data == 14'd11111) ? 4'd12 : (in_data / 1000) % 10;
    assign d100  = (in_data == 14'd11111) ? 4'd13 : (in_data / 100)  % 10;
    assign d10   = (in_data == 14'd11111) ? 4'd14 : (in_data / 10)   % 10;
    assign d1    = (in_data == 14'd11111) ? 4'd15 : (in_data % 10);

endmodule

//==================================================
// FND 자리 출력
//==================================================
module fnd_digit_display(
    input [1:0] digit_sel,
    input [3:0] d1, d10, d100, d1000,
    output reg [3:0] an,
    output reg [7:0] seg
);

    reg [3:0] bcd_data;

    always @(*) begin
        case(digit_sel)
            2'b00: begin bcd_data = d1;   an = 4'b1110; end
            2'b01: begin bcd_data = d10;  an = 4'b1101; end
            2'b10: begin bcd_data = d100; an = 4'b1011; end
            2'b11: begin bcd_data = d1000; an = 4'b0111; end
            default: begin bcd_data = 4'b0000; an = 4'b1111; end
        endcase
    end

    // 7세그먼트 비트 순서 {dp,g,f,e,d,c,b,a}, Active Low
    always @(*) begin
        case(bcd_data)
            4'd0: seg = 8'b11000000;
            4'd1: seg = 8'b11111001;
            4'd2: seg = 8'b10100100;
            4'd3: seg = 8'b10110000;
            4'd4: seg = 8'b10011001;
            4'd5: seg = 8'b10010010;
            4'd6: seg = 8'b10000010;
            4'd7: seg = 8'b11111000;
            4'd8: seg = 8'b10000000;
            4'd9: seg = 8'b10010000;
            4'd12: seg = 8'b11000110; // 천의 자리 특수
            4'd13: seg = 8'b11110110; // 백의 자리 특수
            4'd14: seg = 8'b11110110; // 십의 자리 특수
            4'd15: seg = 8'b11110000; // 일의 자리 특수
            default: seg = 8'b11111111;
        endcase
    end

endmodule

//==================================================
// FND 자리 선택 모듈
//==================================================
module fnd_digit_select(
    input reset,
    input tick,
    output reg [1:0] sel
);

    always @(posedge reset or posedge tick) begin
        if (reset)
            sel <= 0;
        else
            sel <= sel + 1;
    end

endmodule