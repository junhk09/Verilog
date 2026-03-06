`timescale 1ns / 1ps
module top(

    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    input RsRx, //UART rx
    output RsTx, 
    output [7:0] seg,
    output [3:0] an,
    output [15:0] led,
    output uartTx, //JB1 for Oscilloscope
    output uartRx
    );
wire [7:0] w_rx_data;
wire w_rx_done;
wire [13:0] w_seg_data;
wire [2:0] w_clean_btn;
 uart_controller u_uart_controller(
    .clk(clk),
    .reset(reset),
    .send_data(sw), 
    .rx(RsRx),
    .tx(RsTx),
    .rx_data(w_rx_data),
    .rx_done(w_rx_done)
    );
 controll_tower u_controll_tower(
     .clk(clk),
     .reset(reset),
     .btn(btn),
     .sw(sw),
     .rx_data(w_rx_data), // UART 8 bitS
     .rx_done(w_rx_done), // 8bit data 도착=1
     .led(led),
    .seg_data(w_seg_data)
    );
 btn_debouncer u_btn_debouncer(
     .clk(clk),
     .reset(reset),
     .btn(btn),  
    .debounced_btn(w_clean_btn)
);

assign uartTx=RsTx; // Oscilloscope 측정
assign uartRx=RsRx;





endmodule
