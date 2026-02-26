`timescale 1ns / 1ps


module clock_80Hz(
    input i_clk, //100MHz
    input i_reset, //reset 스위치
    output reg o_clk //80Hz 
    );

    // reg [23:0] r_counter=0; //1,250,000 = 10ns*1,250,000=12.ms
    // log2(8) 
    reg [$clog2(1250000)-1:0] r_counter=0; // 1250000를 저장할 수 있는 size를 계산 

    // 10ns의 clk가 오거나, i_reset버튼이 눌리면 항상 수행한다.
    always @(posedge i_clk, posedge i_reset) begin
        if(i_reset==1) begin //비동기, reset 0-->1
            r_counter<=0;
            o_clk<=0;
        end
        else begin
            if(r_counter==(1250000/2)-1) begin //80hz 1주기 12.5ms
                r_counter<=0;
                o_clk <= ~o_clk;
            end
            else begin
                r_counter<=r_counter+1;
            end
        end
    end

endmodule
