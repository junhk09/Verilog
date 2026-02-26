`timescale 1ns / 1ps

module top(
    input clk,          // W5 핀 (100MHz)
    input reset,        // R2 핀 (맨 왼쪽 스위치 sw[15])
    input [2:0] btn,    // W19(Left), U18(Center), T17(Right) 핀
    output [3:0] an,    // FND 자리 선택
    output [7:0] seg    // FND 세그먼트 (dp 포함)
);

    // ==========================================
    // 내부 연결 선(Wire)
    // ==========================================
    wire [2:0] w_btn_pulse;
    
    // XDC 핀 번호에 맞춰서 직관적으로 선 연결!
    wire w_coin_pulse   = w_btn_pulse[0]; // btn[0] (W19, 왼쪽 버튼): 100원 투입
    wire w_return_pulse = w_btn_pulse[1]; // btn[1] (U18, 가운데 버튼): 동전 반환
    wire w_coffee_pulse = w_btn_pulse[2]; // btn[2] (T17, 오른쪽 버튼): 커피 제조

    wire [15:0] w_coin_val;
    wire w_seg_en;
    wire w_coffee_make;
    wire w_coin_return;
    wire w_coffee_out;  
    wire w_tick;        

    // ==========================================
    // 부품 조립 (Instantiation)
    // ==========================================

    // 1. 통합 버튼 디바운서
    // top의 btn[2:0] 배열을 하위 모듈에 그대로 꽂아줍니다.
    btn_debouncer u_btn_debouncer(
        .clk(clk), 
        .reset(reset), 
        .btn(btn), 
        .debounced_btn(w_btn_pulse)
    );

    // 2. 커피 자판기 메인 로직
    coffee_machine u_coffee_machine(
        .clk(clk), 
        .reset(reset),
        .coin(w_coin_pulse),
        .return_coin_btn(w_return_pulse),
        .coffee_btn(w_coffee_pulse),
        .coffee_out(w_coffee_out), // fnd_controller에서 나온 5초 완료 신호를 받음!
        .coin_val(w_coin_val),
        .seg_en(w_seg_en),             
        .coffee_make(w_coffee_make),
        .coin_return(w_coin_return)
    );

    // 3. Tick 생성기 (1kHz 펄스 생성)
    tick_generator u_tick_generator(
        .clk(clk), 
        .reset(reset), 
        .tick(w_tick)
    );

    // 4. 타이머 통합형 FND 컨트롤러
    fnd_controller u_fnd_controller(
        .clk(clk), 
        .reset(reset),
        .tick(w_tick),                 
        .anim_en(w_coffee_make),       
        .in_data(w_coin_val[13:0]),    
        .an(an), 
        .seg(seg),
        .timer_done(w_coffee_out)      // 5초가 지나면 펄스 발생
    );

endmodule