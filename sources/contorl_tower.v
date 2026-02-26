`timescale 1ns / 1ps

module contorl_tower(
    input clk,
    input reset,
    input [2:0] btn,        // [0]=L(Clock), [1]=C(Stopwatch), [2]=R(Run/Pause)
    output [13:0] seg_data,
    output dp
);

    //--------------------------------------------------
    // 모드 정의
    //--------------------------------------------------
    parameter MODE_STOPWATCH = 1'b0;
    parameter MODE_CLOCK     = 1'b1;

    reg r_mode = MODE_STOPWATCH;
    reg r_run  = 1'b1; // 전원 켜면 자동 시작

    //--------------------------------------------------
    // 버튼 Edge 검출용 레지스터
    //--------------------------------------------------
    reg prevL = 0;
    reg prevC = 0;
    reg prevR = 0;

    //--------------------------------------------------
    // 10ms tick 생성 (100MHz 기준)
    //--------------------------------------------------
    reg [19:0] r_counter = 0;
    wire tick_10ms;
    assign tick_10ms = (r_counter == 20'd1_000_000-1);

    always @(posedge clk or posedge reset) begin
        if (reset)
            r_counter <= 0;
        else if (tick_10ms)
            r_counter <= 0;
        else
            r_counter <= r_counter + 1;
    end

    //--------------------------------------------------
    // 버튼 입력 처리 (모드 전환 및 정지)
    //--------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_mode  <= MODE_STOPWATCH;
            r_run   <= 1'b1;
            prevL   <= 0;
            prevC   <= 0;
            prevR   <= 0;
        end else begin
            // L 버튼 (btn[0]): 시계 모드
            if (btn[0] && !prevL) r_mode <= MODE_CLOCK;
            // C 버튼 (btn[1]): 초시계 모드
            if (btn[1] && !prevC) r_mode <= MODE_STOPWATCH;
            // R 버튼 (btn[2]): 일시정지/재생 토글
            if (btn[2] && !prevR) r_run <= ~r_run;

            // 이전 상태 저장
            prevL <= btn[0];
            prevC <= btn[1];
            prevR <= btn[2];
        end
    end

    //--------------------------------------------------
    // 초시계 카운터 (0.01초 단위)
    //--------------------------------------------------
    reg [13:0] r_sw_counter = 0;
    always @(posedge clk or posedge reset) begin
        if (reset)
            r_sw_counter <= 0;
        else if (tick_10ms && r_run)
            r_sw_counter <= (r_sw_counter == 9999) ? 0 : r_sw_counter + 1;
    end

    //--------------------------------------------------
    // mm:ss 시계 카운터
    //--------------------------------------------------
    reg [6:0] r_clk_sec   = 0;
    reg [6:0] r_clk_min   = 0;
    reg [6:0] tick_100cnt = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tick_100cnt <= 0;
            r_clk_sec   <= 0;
            r_clk_min   <= 0;
        end else if (tick_10ms && r_run) begin
            if (tick_100cnt == 99) begin
                tick_100cnt <= 0;
                if (r_clk_sec == 59) begin
                    r_clk_sec <= 0;
                    r_clk_min <= (r_clk_min == 59) ? 0 : r_clk_min + 1;
                end else
                    r_clk_sec <= r_clk_sec + 1;
            end else
                tick_100cnt <= tick_100cnt + 1;
        end
    end

    //--------------------------------------------------
    // 시계 데이터를 4자리 10진수 형태로 변환
    //--------------------------------------------------
    wire [13:0] clock_mmss;
    assign clock_mmss = (r_clk_min * 100) + r_clk_sec;

    //--------------------------------------------------
    // FND 출력 선택 로직
    //--------------------------------------------------
    reg [13:0] r_display;

    always @(*) begin
        if (!r_run)
            r_display = 14'd11111; // 일시정지 패턴
        else begin
            case (r_mode)
                MODE_STOPWATCH: r_display = r_sw_counter;
                MODE_CLOCK:     r_display = clock_mmss;
                default:        r_display = r_sw_counter;
            endcase
        end
    end

    assign seg_data = r_display;

    //--------------------------------------------------
    // dp (소수점) 제어
    //--------------------------------------------------
    // 시계 모드이거나 일시정지 상태일 때 소수점 켬
    assign dp = (!r_run) ? 1'b1 : (r_mode == MODE_CLOCK);

endmodule