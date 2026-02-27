`timescale 1ns / 1ps
// 100Mhz/10 -> 10Mhz의 주파수를 만듦.
// 100Mhz의 10% 조절 해상도를 가질 수 있는 최대 주파수
// 0~9까지 총 10번의 클럭을 세고
module pwm_duty_control(
    input clk,
    input reset,
    input duty_inc,
    input duty_dec,
    output [3:0] DUTY_CYCLE, //FND에 출력 0~9
    output PWM_OUT,
    output PWM_OUT_LED


    );
reg [3:0] r_DUTY_CYCLE=4'd5;
reg [3:0] r_counter_PWM;
// edge 검출 register
reg r_prev_duty_inc,r_prev_duty_dec;

wire w_duty_inc=(duty_inc && !r_prev_duty_inc); //rising edge 검출
wire w_duty_dec=(duty_dec&& !r_prev_duty_dec);
//duty cycle 제어 btnU,btnD
always@(posedge clk, posedge reset) begin
    if (reset) begin
        r_DUTY_CYCLE<=4'd5; //50% duty cycle
    end else begin
        r_prev_duty_inc <= duty_inc; //이전 상태 저장
        r_prev_duty_dec<=duty_dec;  
        if(w_duty_inc && r_DUTY_CYCLE<4'd9)
            r_DUTY_CYCLE<=r_DUTY_CYCLE+1;
        if(w_duty_dec && r_DUTY_CYCLE>4'd1)
            r_DUTY_CYCLE<=r_DUTY_CYCLE-1;
    end
end

// 10MHz PWM 신호 생성(0~9)
always@(posedge clk, posedge reset) begin
    if(reset) begin
        r_counter_PWM <=0;

    end else begin
        if(r_counter_PWM >= 4'd9)
            r_counter_PWM<=0;
            else r_counter_PWM<=r_counter_PWM+1;
    end        

    end

    assign PWM_OUT=(reset)? 1'b0 : (r_counter_PWM<r_DUTY_CYCLE) ? 1'b1: 1'b0;
    assign PWM_OUT_LED=PWM_OUT;
    assign DUTY_CYCLE=r_DUTY_CYCLE;


endmodule
