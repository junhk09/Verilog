`timescale 1ns / 1ps


module btn_toggle_timer(
    input i_clk,        // 100MHz 시스템 클럭
    input i_reset,      // 리셋 스위치 (R2)
    input i_btn,        // 푸시 버튼 입력 (btnC)
    output reg o_led    // LED 출력 (led[0])
    );

    // 1,000,000까지 세기 위한 20비트 카운터 (2^20 = 1,048,576)
    reg [19:0] r_count = 0;
    reg r_btn_last = 0;        // 이전 클럭의 버튼 상태 저장
    reg r_stable_btn = 0;      // 10ms 동안 유지된 안정된 버튼 상태
    reg r_stable_btn_old = 0;  // 상승 엣지 검출을 위한 이전 안정 상태 저장

    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            r_count <= 0;
            r_btn_last <= 0;
            r_stable_btn <= 0;
            r_stable_btn_old <= 0;
            o_led <= 0;
        end else begin
            // 1. 디바운싱 로직 (Timer Counter 방식)
            r_btn_last <= i_btn;

            if (i_btn != r_btn_last) begin
                // 버튼 신호가 흔들리면(노이즈) 카운터 즉시 리셋
                r_count <= 0;
            end 
            else if (r_count < 1000000) begin
                // 신호가 유지되는 동안 10ms(1,000,000번)까지 카운트
                r_count <= r_count + 1;
            end 
            else begin
                // 10ms 동안 변함이 없으면 안정된 신호로 인정
                r_stable_btn <= r_btn_last;
            end

            // 2. 토글 로직 (Edge Detection)
            r_stable_btn_old <= r_stable_btn;
            
            // 안정된 버튼 값이 0에서 1로 변하는 순간(상승 엣지)에만 LED 반전
            if (r_stable_btn == 1 && r_stable_btn_old == 0) begin
                o_led <= ~o_led;
            end
        end
    end
endmodule