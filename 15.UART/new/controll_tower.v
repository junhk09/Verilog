`timescale 1ns / 1ps

module controll_tower(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    input [7:0] rx_data, // UART 8 bitS
    input rx_done, // 8bit data 도착=1
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
// 문자열 저장을 위한 버퍼 및 포인터 (최대 8글자 가정)
reg [7:0] cmd_buffer [0:7];
reg [2:0] write_ptr = 0;


reg [15:0] r_led_manual; // LED 수동 제어를 위한 레지스터 추가

always @(posedge clk, posedge reset) begin
    if(reset) begin
        r_mode <= 0;
        write_ptr <= 0;
        r_led_manual <= 16'h0000;
    end else begin
        // 1. 버튼 입력 (기존 로직 유지) [cite: 24, 26]
        if(btn[0] && !r_prev_btnL) begin
            r_mode <= (r_mode == SLIDE_SW_READ) ? UP_COUNTER : r_mode + 1;
        end

        // 2. UART 문자열 인식 ("LEDOFF", "LEDON" 추가)
        if(rx_done) begin
            if(rx_data == 8'h0A) begin // 개행 문자('\n')
                // "LEDON" 인식 시
                if(cmd_buffer[0]=="L" && cmd_buffer[1]=="E" && cmd_buffer[2]=="D" && cmd_buffer[3]=="O" && cmd_buffer[4]=="N") begin
                    r_led_manual <= 16'h0001; // LED[0]만 킴
                end
                // "LEDOFF" 인식 시
                else if(cmd_buffer[0]=="L" && cmd_buffer[1]=="E" && cmd_buffer[2]=="D" && cmd_buffer[3]=="O" && cmd_buffer[4]=="F" && cmd_buffer[5]=="F") begin
                    r_led_manual <= 16'h0000; // 전부 끔
                end
                // 기존 모드 변경 명령들
                else if(cmd_buffer[0]=="U" && cmd_buffer[1]=="P") r_mode <= UP_COUNTER;
                else if(cmd_buffer[0]=="D" && cmd_buffer[1]=="N") r_mode <= DOWN_COUNTER;

                write_ptr <= 0;
            end else begin
                cmd_buffer[write_ptr] <= rx_data;
                write_ptr <= write_ptr + 1; // 원형 큐 방식으로 인덱스 순환
            end
        end
    end
    r_prev_btnL <= btn[0]; // [cite: 26]
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
