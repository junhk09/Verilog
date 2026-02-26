`timescale 1ns / 1ps

module controll_tower(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    output reg [15:0] led,
    output [13:0] seg_data
    );

parameter UP_COUNTER=3'b01; //#define같은거임
parameter DOWN_COUNTER=3'b10; 
parameter SLIDE_SW_READ=3'b11;

reg r_prev_btnL=0;
reg [2:0] r_mode=3'b000;
reg [19:0] r_counter; //10ms 를 재기 위한 counter 10ns * 1000000
reg [13:0] r_ms10_counter; // 10ms가 될 때 마다 1씩 증가 9999까지=>FND가 9999까지이기 때문.


always @(posedge clk, posedge reset) begin
    if(reset)begin
        r_mode <=0;

    end else begin
        if(btn[0] && !r_prev_btnL)
            r_mode=(r_mode==SLIDE_SW_READ) ? UP_COUNTER : r_mode+1;

    end
    r_prev_btnL <= btn[0];

end

// up counter
always @(posedge clk, posedge reset)begin
    if(reset) begin
        r_counter<=0;
        r_ms10_counter<=0;
    end else if(r_mode==UP_COUNTER) begin
            if(r_counter==20'd1_000_000-1) begin // 10ms라면
                r_counter <=0;
                if(r_ms10_counter>=9999) //9999도달시 0으로 초기화
                r_ms10_counter<=0;
               else r_ms10_counter <= r_ms10_counter +1;
                led[13:0] <=r_ms10_counter;
            end else begin
                r_counter <= r_counter+1;
            end
    end else if(r_mode==DOWN_COUNTER) begin 
        if(r_counter==20'd1_000_000-1) begin
            r_counter<=0;
            if(r_ms10_counter==0)
                r_ms10_counter<=9999;
                else begin
                r_ms10_counter <= r_ms10_counter-1;
                end
            led[13:0] <= r_ms10_counter;
        end else begin
            r_counter<=r_counter+1;
        end
        
    end else begin //slide_sw_read or idle mode
            r_counter <=0;
        r_ms10_counter <=0;


    end
end



always @(r_mode) begin
    case(r_mode)
        UP_COUNTER : begin
            led[15:14]=UP_COUNTER;
        end
        DOWN_COUNTER: begin
             led[15:14]=DOWN_COUNTER;
        end
        SLIDE_SW_READ : begin
            led[15:14]=SLIDE_SW_READ;
        end
        default : 
             led[15:14]=3'b000;
    endcase
end

assign seg_data = (r_mode==UP_COUNTER) ? r_ms10_counter:
                    (r_mode==DOWN_COUNTER) ? r_ms10_counter : sw;



endmodule
