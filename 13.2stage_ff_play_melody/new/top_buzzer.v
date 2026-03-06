`timescale 1ns / 1ps


module top_buzzer(
    input clk,
    input reset,
    input btnU, //도
    input btnL, //레
    input btnC, //미W
    input btnR, //솔
    input btnD, //라
  
    output buzzer
    );
wire w_btnU, w_btnL, w_btnC, w_btnR, w_btnD;
 debouncer u_btnU_debouncer (
      .clk(clk),
      .reset(reset),
      .noisy_btn(btnU),      
      .clean_btn(w_btnU)
);
 debouncer u_btnL_debouncer (
      .clk(clk),
      .reset(reset),
      .noisy_btn(btnL),      
      .clean_btn(w_btnL)
);
 debouncer u_btnC_debouncer (
      .clk(clk),
      .reset(reset),
      .noisy_btn(btnC),      
      .clean_btn(w_btnC)
);
 debouncer u_btnR_debouncer (
      .clk(clk),
      .reset(reset),
      .noisy_btn(btnR),      
      .clean_btn(w_btnR)
);
 debouncer u_btnD_debouncer (
      .clk(clk),
      .reset(reset),
      .noisy_btn(btnD),      
      .clean_btn(w_btnD)
);
 play_melody u_play_melody(
     .clk(clk),
     .reset(reset),
     .btnU(w_btnU), //도    261.63Hz
     .btnL(w_btnL), //레    293.66Hz
     .btnC(w_btnC), //미    329.63Hz
     .btnR(w_btnR), //솔    392.00Hz
     .btnD(w_btnD), //라    440.00Hz
     .buzzer(buzzer)
    );
endmodule
