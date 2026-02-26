`timescale 1ns / 1ps

module btn_debouncer(
    input clk,
    input reset,
    input [1:0] btn,   
    output [1:0] debounced_btn
);
wire [1:0] clean_btn_wire;
    debouncer U_debouncer_btnU (
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn[0]),
        .clean_btn(clean_btn_wire[0])
    );

    debouncer U_debouncer_btnD (
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn[1]),
        .clean_btn(clean_btn_wire[1])
    );
reg [1:0] r_clean_btn_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_clean_btn_reg <= 2'b000;
        end else begin
            // 1클럭 이전의 상태를 저장
            r_clean_btn_reg <= clean_btn_wire;
        end
    end

    // 현재 상태는 1이고, 이전 상태는 0일 때만 딱 1클럭 동안 High(1)
    // 최종 출력 변수명 'debounced_btn'에 펄스 신호를 연결
    assign debounced_btn[0] = (clean_btn_wire[0] && !r_clean_btn_reg[0]);
    assign debounced_btn[1] = (clean_btn_wire[1] && !r_clean_btn_reg[1]);

 //   assign led = debounced_btn;   // button을 누를때 마다 led가 동작 되도록 한다.
endmodule
// 아래에 있는 코드는 버튼 디바운서 이다. 
// 이는 버튼 3개(btn[2:0])의 입력에서 발생할 수 있는 
// 노이즈(채터링)을 제거해, 안정적인 버튼 입력(debounced_btn[2:0])으로 만들어준다.
// 파라미터는 보통 클럭 카운트 제한값으로 사용되어,
// 얼마나 오랫동안 입력이 안정적인지를 판단하기 위한 시간 지연 설정이다.
// 예: 100MHz 클럭이라면, 999,999는 약 10ms의 디바운싱 지연을 의미할 수 있다.
module debouncer #(parameter DEBOUNCE_LIMIT = 20'd999_999) (
    input      clk,
    input      reset,
    input      noisy_btn,  // raw noisy button input
    output reg clean_btn
);
    reg [19:0] count;
    reg btn_state=0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin   // active-high reset
            count <= 0;
            btn_state <= 0;
            clean_btn <= 0;
        end else if (noisy_btn == btn_state) begin  // 버튼 상태가 이전과 동일할 경우 (안정됨)
            count <= 0;
        end else begin
            if (count < DEBOUNCE_LIMIT)  // 버튼 상태가 바뀌었지만 아직 안정되지 않은 경우
                count <= count + 1;
            else begin  // 상태가 충분히 오랫동안 유지됨(10ms)
                btn_state <= noisy_btn;
                clean_btn <= noisy_btn;
                count <= 0;  // 리셋하면 다음 변경을 다시 감지할 수 있음
            end
        end
    end
endmodule

