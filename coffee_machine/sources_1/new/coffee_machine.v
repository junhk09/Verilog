`timescale 1ns / 1ps

module coffee_machine(
    input clk,  // 100MHz
    input reset, // reset btn
    input coin, // 동전 투입 (100원 단위)
    input return_coin_btn,  // 동전 반환 버튼
    input coffee_btn,
    input coffee_out,   // 커피 배출 완료 센서 신호
    output reg [15:0] coin_val, // 현재 금액 표시
    output reg seg_en,  // FND 활성화 신호
    output reg coffee_make, // 커피 제조 시작 신호
    output reg coin_return  // 동전 반환 동작 신호
    );

    parameter IDLE = 3'd0,
              COIN_IN = 3'd1,
              READY = 3'd2,
              COFFEE = 3'd3,
              COIN_OUT = 3'd4;

    parameter COFFEE_VAL = 300;

    reg [2:0] r_current_state = IDLE;
    reg [2:0] r_next_state;

    // coin 투입 check logic
    // edge detect
    reg r_coin_reg;
    wire w_coin_pulse;

    always @(posedge clk or posedge reset) begin
        if (reset) r_coin_reg <= 0;
        else r_coin_reg <= coin;
    end

    assign w_coin_pulse = (coin && !r_coin_reg); // 상승 에지 검출

    always @(*) begin
        r_next_state = r_current_state;
        case (r_current_state)
            IDLE: begin
                if (w_coin_pulse) r_next_state = COIN_IN;
            end
            COIN_IN: begin
                if (return_coin_btn) r_next_state = COIN_OUT;
                else if (coin_val >= COFFEE_VAL) r_next_state = READY;
            end
            READY: begin
                // 반환버튼을 누르거나 잔액이 부족 할때 반환 상태로 이동
                if (return_coin_btn || coin_val < COFFEE_VAL)
                    r_next_state = COIN_OUT;
                else if (coffee_btn)
                    r_next_state = COFFEE;
            end
            COFFEE: begin
                if (coffee_out) r_next_state = READY;   // 커피 제조 완료시 READY로 복귀
            end
            COIN_OUT: begin
                if (coin_val == 0) r_next_state = IDLE;  // 잔액 모두 반환시 IDLE 
            end
            default: r_next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) r_current_state = IDLE;
        else r_current_state <= r_next_state;
    end

    // 동전 add/sub logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            coin_val <= 0;
        end else begin
            // edge 검출을 통해서 어떤 상태 이든지 동전 투입시 가산하는 logic
            if (w_coin_pulse && (r_current_state == IDLE || r_current_state == COIN_IN || r_current_state == READY)) begin
                coin_val <= coin_val + 16'd100;  // 100원짜리 동전
            end
            // 커피 제조 완료시 차감
            if (r_current_state == COFFEE && coffee_out) begin
                coin_val <= coin_val - COFFEE_VAL;
            end
            
            if (r_current_state == COIN_OUT) begin
                coin_val <= 16'd0;
            end
        end
    end

    // output logic (조합 회로)
    always @(*) begin
        seg_en = 0; coffee_make = 0; coin_return = 0;
        case (r_current_state)
            IDLE: ;
            COIN_IN: seg_en = 1;
            READY: seg_en = 1;
            COFFEE: begin
                seg_en = 1;
                coffee_make = 1;
            end
            COIN_OUT: begin
                seg_en = 1;
                coin_return = 1;
            end
        endcase
    end
endmodule