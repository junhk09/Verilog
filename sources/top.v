`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input [2:0] btn,   // btn[0] : btnL / btn[1] : btnC / btn[2] : btnR
  
    output [7:0] seg,
    output [3:0] an
);

    // 내부 신호
    wire [2:0] w_debounced_btn;
    wire [13:0] w_seg_data; // 최대값 9999
    wire w_tick;
    wire w_dp;

    // 버튼 디바운서
    btn_debouncer u_btn_debouncer (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .debounced_btn(w_debounced_btn)
    );

    // 컨트롤 타워
    contorl_tower u_contorl_tower (
        .clk(clk),
        .reset(reset),
        .btn(w_debounced_btn),
        .seg_data(w_seg_data),
        .dp(w_dp) // 필요 없으면 제거 가능
    );

    // FND 컨트롤러
    fnd_contorller u_fnd_contorller (
        .clk(clk),
        .reset(reset),
        .tick(w_tick),
        .in_data(w_seg_data),
        .an(an),
        .seg(seg)
    );

    // Tick 발생기
    tick_generator u_tick_generator (
        .clk(clk),
        .reset(reset),
        .tick(w_tick)
    );

endmodule