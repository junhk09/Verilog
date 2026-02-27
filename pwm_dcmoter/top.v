`timescale 1ns / 1ps
module top(
    input clk,
    input reset,
    input increase_duty_btn,
    input decrease_duty_btn,
    input [1:0] motor_direction,
    output PWM_OUT,
    output PWM_OUT_LED,
    output [1:0] in1_in2,
    output [3:0] an,
    output [7:0] seg
    );
wire w_clean_inc_btn;
wire w_clean_dec_btn;
wire [3:0] w_DUTY_CYCLE;
wire w_tick;
 tick_generator u_tick_generator(
    
     .clk(clk),
     .reset(reset),
      .tick(w_tick)
);

 debouncer u_increase_duty_btn (
            .clk(clk),
            .reset(reset),
            .noisy_btn(increase_duty_btn),  
            .clean_btn(w_clean_inc_btn)
);
 debouncer u_decrease_duty_btn (
            .clk(clk),
            .reset(reset),
            .noisy_btn(decrease_duty_btn),  
            .clean_btn(w_clean_dec_btn)
);
 pwm_duty_control u_pwm_duty_control(
     .clk(clk),
     .reset(reset),
     .duty_inc(w_clean_inc_btn),
     .duty_dec(w_clean_dec_btn),
     .DUTY_CYCLE(w_DUTY_CYCLE), //FND에 출력 0~9
     .PWM_OUT(PWM_OUT),
     .PWM_OUT_LED(PWM_OUT_LED)

    );
 fnd_contorller u_fnd_contorller(
        .clk(clk),
        .reset(reset),
        .tick(w_tick),
        .in_data(w_DUTY_CYCLE),
        .motor_dir(motor_direction),
        
        .an(an),
        .seg(seg)
);

assign in1_in2=motor_direction;










endmodule

