`timescale 1ns / 1ps

module tb_top();

    // 입력은 reg, 출력은 wire로 선언
    reg clk;
    reg reset;
    reg [2:0] btn;
    wire [3:0] an;
    wire [7:0] seg;

    // 테스트할 top 모듈 불러오기
    top u_top (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .an(an),
        .seg(seg)
    );

    // 100MHz 클럭 생성 (주기 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // ==========================================
    // 버튼 누름 자동화 Task (디바운서 통과용)
    // ==========================================
    // 디바운서 딜레이(10ms)보다 길게 눌러야 인식되므로 15ms(15,000,000ns) 유지
    task press_btn_L_coin;
        begin
            btn[0] = 1;
            #15_000_000; 
            btn[0] = 0;
            #15_000_000; 
        end
    endtask

    task press_btn_R_coffee;
        begin
            btn[2] = 1;
            #15_000_000; 
            btn[2] = 0;
            #15_000_000; 
        end
    endtask

    task press_btn_C_return;
        begin
            btn[1] = 1;
            #15_000_000; 
            btn[1] = 0;
            #15_000_000; 
        end
    endtask

    // ==========================================
    // 메인 시뮬레이션 시나리오
    // ==========================================
    initial begin
        // 1. 초기화 상태
        reset = 1;
        btn = 3'b000;
        #100;
        
        // 리셋 해제 후 시스템 안정화 대기
        reset = 0;
        #10_000_000; 

        $display("--- Test Start ---");

        // 2. 동전 300원 투입 (100원씩 3번 누름)
        $display("[%0t] Insert 100 won", $time);
        press_btn_L_coin();
        
        $display("[%0t] Insert 200 won", $time);
        press_btn_L_coin();
        
        $display("[%0t] Insert 300 won", $time);
        press_btn_L_coin();

        // 3. 커피 제조 버튼 누름
        $display("[%0t] Press Coffee Button", $time);
        press_btn_R_coffee();

        // 4. 커피 제조 및 애니메이션 완료 대기 (5초)
        // 실제 시간 5.1초 = 5,100,000,000 ns
        $display("[%0t] Waiting 5 seconds for coffee animation...", $time);
        #5_100_000_000; 
        
        $display("[%0t] Coffee Done! Machine is READY.", $time);

        // 5. 남은 잔액(0원) 확인 및 동전 반환 버튼 테스트
        $display("[%0t] Press Return Button", $time);
        press_btn_C_return();

        #10_000_000;
        $display("--- Simulation Success Finished ---");
        $finish;
    end

endmodule