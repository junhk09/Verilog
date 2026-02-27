`timescale 1ns / 1ps
module play_melody(
    input clk,
    input reset,
    input btnU, //도    261.63Hz
    input btnL, //레    293.66Hz
    input btnC, //미    329.63Hz
    input btnR, //솔    392.00Hz
    input btnD, //라    440.00Hz
    output buzzer
    );
localparam DO = 22'd191_112; //50% duty, 도
localparam RE=22'd179_265; //50% duty, 레
localparam MI=22'd151_685; //50% duty, 미
localparam SOL=22'd127_551; //50% duty, 솔
localparam RA=22'd113_636; //50% duty, 라

reg[21:0] r_clk_cnt[4:0]; // 2차원 Array
reg[4:0] r_buzzer_frequency;
wire[4:0] btn_ary = {btnD,btnR,btnC,btnL,btnU};

integer i; //signed 32bit reg[31:0]이거는 unsigned 32bit
always@(posedge clk, posedge reset) begin
    if(reset) begin
        for(i=0; i<5; i=i+1) begin//i++없음
            r_clk_cnt[i]<=22'd0;
            r_buzzer_frequency[i]<=1'b0;
        end
    end else begin //10ns 마다 상승 엣지 clock
        //도(btnU) 생성
        if(!btn_ary[0]) begin
            r_clk_cnt[0] <=0;
            r_buzzer_frequency[0]<=1'b0;
        end else if(r_clk_cnt[0]>=DO-1)begin
            r_clk_cnt[0]<=0;
            r_buzzer_frequency[0] <= ~r_buzzer_frequency[0];
        end else r_clk_cnt[0] <= r_clk_cnt[0]+1;
        //레
         if(!btn_ary[1]) begin
            r_clk_cnt[1] <=0;
            r_buzzer_frequency[1]<=1'b0;
        end else if(r_clk_cnt[1]>=RE-1)begin
            r_clk_cnt[1]<=0;
            r_buzzer_frequency[1] <= ~r_buzzer_frequency[1];
        end else r_clk_cnt[1] <= r_clk_cnt[1]+1;
        //미
         if(!btn_ary[2]) begin
            r_clk_cnt[2] <=0;
            r_buzzer_frequency[2]<=1'b0;
        end else if(r_clk_cnt[2]>=MI-1)begin
            r_clk_cnt[2]<=0;
            r_buzzer_frequency[2] <= ~r_buzzer_frequency[2];
        end else r_clk_cnt[2] <= r_clk_cnt[2]+1;
        //솔
         if(!btn_ary[3]) begin
            r_clk_cnt[3] <=0;
            r_buzzer_frequency[3]<=1'b0;
        end else if(r_clk_cnt[3]>=SOL-1)begin
            r_clk_cnt[3]<=0;
            r_buzzer_frequency[3] <= ~r_buzzer_frequency[3];
        end else r_clk_cnt[3] <= r_clk_cnt[3]+1;
        //라
         if(!btn_ary[4]) begin
            r_clk_cnt[4] <=0;
            r_buzzer_frequency[4]<=1'b0;
        end else if(r_clk_cnt[4]>=RA-1)begin
            r_clk_cnt[4]<=0;
            r_buzzer_frequency[4] <= ~r_buzzer_frequency[4];
        end else r_clk_cnt[4] <= r_clk_cnt[4]+1;

    end

end
// assign buzzer=r_buzzer_frequency[4] | r_buzzer_frequency[3] | r_buzzer_frequency[2] 
//             | r_buzzer_frequency[1] | r_buzzer_frequency[0];
//0(false) : 5개bit가 모두 0일때 결과가 0이다.
//1(true) : 5개bit중 하나라도 1이다.
assign buzzer= |r_buzzer_frequency; //위와 같은 결과임.


// clk이 100MHz가 들어옴
// output frequency
// (100MHz / 원하는 주파수) / 2

endmodule
