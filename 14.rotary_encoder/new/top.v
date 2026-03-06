`timescale 1ns / 1ps


module top(
    input clk,
    input reset,
    input s1,
    input s2,
    input key,
    output [15:0] led
    );
    wire w_clean_s1, w_clean_s2,w_clean_key;
 debouncer #(.DEBOUNCE_LIMIT(200_000)) u_s1_debouncer( //Rotary : 2ms로 설정(200_000ns) ->2us= 10ns*200=2000ns
//  debouncer #(.DEBOUNCE_LIMIT(200)) u_s1_debouncer(
          .clk(clk),
          .reset(reset),
          .noisy_btn(s1),  // raw noisy button input
          .clean_btn(w_clean_s1)
);
 debouncer #(.DEBOUNCE_LIMIT(200_000)) u_s2_debouncer( //Rotary : 2ms로 설정(200_000ns)
//  debouncer #(.DEBOUNCE_LIMIT(200)) u_s2_debouncer( 
          .clk(clk),
          .reset(reset),
          .noisy_btn(s2),  // raw noisy button input
          .clean_btn(w_clean_s2)
);

 debouncer #(.DEBOUNCE_LIMIT( 999_000)) u_key_debouncer( 
          .clk(clk),
          .reset(reset),
          .noisy_btn(key),  // raw noisy button input
          .clean_btn(w_clean_key)
);

 rotary u_rotary(
      .clk(clk),
     .reset(reset),
     .clean_s1(w_clean_s1),
     .clean_s2(w_clean_s2),
     .clean_key(w_clean_key),
     .led(led)
    );
endmodule
