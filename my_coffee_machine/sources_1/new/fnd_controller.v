`timescale 1ns / 1ps

//==================================================
// FND 컨트롤러 (최상위) - 애니메이션 기능 추가
//==================================================
module fnd_controller(
    input clk,             // 100MHz 메인 클럭 (애니메이션 속도 계산용 추가)
    input reset,
    input tick,            // FND 다이나믹 스캔용 틱
    input anim_en,         // 추가: 1이 되면 서클 애니메이션 재생 (커피 제조 중)
    input [13:0] in_data,
    output [3:0] an,
    output [7:0] seg,
    output reg timer_done
);

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;
    
    // 유저님의 원래 출력을 받을 내부 선
    wire [3:0] normal_an;
    wire [7:0] normal_seg;

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

    // 각 자리 출력 (원래 an, seg 대신 normal_an, normal_seg로 임시 저장)
    fnd_digit_display u_fnd_digit_display(
        .digit_sel(w_sel), 
        .d1(w_d1), 
        .d10(w_d10), 
        .d100(w_d100), 
        .d1000(w_d1000),
        .an(normal_an), 
        .seg(normal_seg)
    );

    // ==========================================
    // 🌟 추가된 로직: 서클 애니메이션 제어부
    // ==========================================
    reg [23:0] anim_cnt = 0;
    reg [28:0] timer_cnt = 0; // 5초 카운트용
    reg [3:0] anim_step = 0;
    reg [7:0] anim_seg;
    reg [3:0] anim_an;
   always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer_cnt <= 0;
            anim_cnt <= 0;
            anim_step <= 0;
            timer_done <= 0;
        end else if (anim_en) begin
            // 1. 5초 타이머 로직
            if (timer_cnt >= 29'd499_999_999) begin
                timer_cnt <= 0;
                timer_done <= 1; // 5초 도달 시 1클럭 펄스 발생
            end else begin
                timer_cnt <= timer_cnt + 1;
                timer_done <= 0;
            end

            // 2. 애니메이션 프레임 로직
            if (anim_cnt >= 24'd4_999_999) begin
                anim_cnt <= 0;
                if (anim_step >= 11) anim_step <= 0;
                else anim_step <= anim_step + 1;
            end else begin
                anim_cnt <= anim_cnt + 1;
            end
        end else begin
            timer_cnt <= 0;
            anim_cnt <= 0;
            anim_step <= 0;
            timer_done <= 0;
        end
    end

    // 애니메이션 프레임 (a -> b -> c -> d -> e -> f)
    always @(*) begin
        case(anim_step)
          // 1. 위쪽 라인 (왼쪽에서 오른쪽으로 진행)
            0:  begin anim_an = 4'b0111; anim_seg = 8'b11111110; end // D3 (맨 왼쪽)의 'a'
            1:  begin anim_an = 4'b1011; anim_seg = 8'b11111110; end // D2 의 'a'
            2:  begin anim_an = 4'b1101; anim_seg = 8'b11111110; end // D1 의 'a'
            3:  begin anim_an = 4'b1110; anim_seg = 8'b11111110; end // D0 (맨 오른쪽)의 'a'
            
            // 2. 오른쪽 라인 (위에서 아래로 진행)
            4:  begin anim_an = 4'b1110; anim_seg = 8'b11111101; end // D0 의 'b'
            5:  begin anim_an = 4'b1110; anim_seg = 8'b11111011; end // D0 의 'c'
            
            // 3. 아래쪽 라인 (오른쪽에서 왼쪽으로 진행)
            6:  begin anim_an = 4'b1110; anim_seg = 8'b11110111; end // D0 의 'd'
            7:  begin anim_an = 4'b1101; anim_seg = 8'b11110111; end // D1 의 'd'
            8:  begin anim_an = 4'b1011; anim_seg = 8'b11110111; end // D2 의 'd'
            9:  begin anim_an = 4'b0111; anim_seg = 8'b11110111; end // D3 의 'd'
            
            // 4. 왼쪽 라인 (아래에서 위로 진행)
            10: begin anim_an = 4'b0111; anim_seg = 8'b11101111; end // D3 의 'e'
            11: begin anim_an = 4'b0111; anim_seg = 8'b11011111; end // D3 의 'f'
            default: begin anim_an = 4'b1111; anim_seg = 8'b11111111; end
        endcase
    end

    // 최종 출력 MUX
    assign an  = anim_en ? anim_an  : normal_an;
    assign seg = anim_en ? anim_seg : normal_seg;

endmodule

//==================================================
// 유저님이 작성하신 완벽한 하위 모듈들 (변경 없음!)
//==================================================
module bin2bcd4digit(
    input [13:0] in_data,
    output [3:0] d1, d10, d100, d1000
);
    assign d1000 = (in_data == 14'd11111) ? 4'd12 : (in_data / 1000) % 10;
    assign d100  = (in_data == 14'd11111) ? 4'd13 : (in_data / 100)  % 10;
    assign d10   = (in_data == 14'd11111) ? 4'd14 : (in_data / 10)   % 10;
    assign d1    = (in_data == 14'd11111) ? 4'd15 : (in_data % 10);
endmodule

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
            4'd12: seg = 8'b11000110; 
            4'd13: seg = 8'b11110110; 
            4'd14: seg = 8'b11110110; 
            4'd15: seg = 8'b11110000; 
            default: seg = 8'b11111111;
        endcase
    end
endmodule

module fnd_digit_select(
    input reset,
    input tick,
    output reg [1:0] sel
);
    always @(posedge reset or posedge tick) begin
        if (reset) sel <= 0;
        else sel <= sel + 1;
    end
endmodule