`timescale 1ns / 1ps

//==================================================
// FND 컨트롤러
//==================================================
module fnd_contorller(
    input clk,
    input reset,
    input tick,
    input [3:0] in_data,
    input [1:0] motor_dir,
    output [3:0] an,
    output [7:0] seg
);

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;

reg [25:0] r_blink_counter = 0;
    reg r_blink = 0;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_blink_counter <= 0;
            r_blink <= 0;
        end else begin
            // 100MHz 기준 5천만 번(0.5초) 카운트
            if (r_blink_counter >= 26'd49_999_999) begin 
                r_blink_counter <= 0;
                r_blink <= ~r_blink; // 0.5초마다 상태 반전
            end else begin
                r_blink_counter <= r_blink_counter + 1;
            end
        end
    end

    // 자리 선택
    fnd_digit_select u_fnd_digit_select(
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .sel(w_sel)
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
 duty_dir_decoder u_duty_dir_decoder(
     .duty_cycle(in_data),
     .motor_dir(motor_dir),
     .blink(r_blink),              
     .d1(w_d1), 
     .d10(w_d10), 
     .d100(w_d100), 
     .d1000(w_d1000)
);
endmodule

module duty_dir_decoder(
    input [3:0] duty_cycle,
    input [1:0] motor_dir,
    input blink,               // 1Hz 깜빡임 신호 (1초 주기)
    output [3:0] d1, d10, d100, d1000
);

    // 모터 방향이 2'b10(역방향)이면 'b'(11), 그 외(정방향 2'b01 등)는 'F'(10)을 선택
    wire [3:0] w_dir_char = (motor_dir == 2'b10) ? 4'd11 : 4'd10; 
    
    // 천의 자리(d1000): blink 신호가 1일 때는 공백(15) 출력, 0일 때는 F나 b 출력 (깜빡임 효과)
    assign d1000 = blink ? 4'd15 : w_dir_char;
    
    // 백의 자리, 십의 자리는 0으로 고정, 일의 자리는 Duty Cycle 출력
    assign d100  = 4'd0;
    assign d10   = 4'd0;
    assign d1    = duty_cycle;

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
          4'd10: seg = 8'b10001110; // 'F' (Forward) : a,e,f,g 켜짐
            4'd11: seg = 8'b10000011; // 'b' (Backward) : c,d,e,f,g 켜짐
           4'd15: seg = 8'b11111111;
            default: seg = 8'b11111111;
        endcase
    end

endmodule

//==================================================
// FND 자리 선택 모듈
//==================================================
module fnd_digit_select(
    input clk,
    input reset,
    input tick,
    output reg [1:0] sel
);

    always @(posedge reset or posedge tick) begin
        if (reset)
            sel <= 0;
        else if(tick)
            sel <= sel + 1;
    end

endmodule