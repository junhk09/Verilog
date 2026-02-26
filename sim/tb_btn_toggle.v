`timescale 1ns / 1ps

module tb_btn_toggle();

    reg clk;
    reg reset;
    reg btn;
    wire led;

    // 모듈 인스턴스화
    btn_toggle_timer uut (
        .i_clk(clk),
        .i_reset(reset),
        .i_btn(btn),
        .o_led(led)
    );

    // 100MHz 클럭 생성 (10ns 주기)
    always #5 clk = ~clk;

    initial begin
        // 초기화
        clk = 0;
        reset = 1;
        btn = 0;
        #20 reset = 0; // 리셋 해제

        // --- 시나리오 1: 버튼 누름 노이즈 발생 ---
        #100 btn = 1; #10 btn = 0; // 10ns 노이즈 (무시되어야 함)
        #20  btn = 1; #30 btn = 0; // 30ns 노이즈 (무시되어야 함)
        
        // --- 시나리오 2: 버튼 10ms 이상 꾹 누름 ---
        #50  btn = 1; 
        // 실제 10ms를 기다리려면 10,000,000ns가 필요합니다.
        // 시뮬레이션 속도를 위해 btn_toggle_timer의 1000000을 100으로 줄여서 테스트하면 바로 확인 가능합니다.
        #11000000; 

        // --- 시나리오 3: 버튼 뗌 노이즈 발생 ---
        #100 btn = 0; #20 btn = 1;
        #50  btn = 0;
        #11000000;

        // --- 시나리오 4: 다시 한 번 눌러서 LED 꺼지는지 확인 (Toggle) ---
        #100 btn = 1;
        #11000000;
        
        $finish;
    end
endmodule