`timescale 1ns / 1ps
module play_melody(
    input clk,
    input reset,
    input btnL, 
    input btnR, 
    output reg buzzer
    );
    localparam cnt_70ms=23'd7000000; //70ms 주기 만들기
    localparam IDLE=4'd0;
    localparam PL1=4'd1;
    localparam PL2=4'd2;
    localparam PL3=4'd3;
    localparam PL4=4'd4;
    localparam PR1=4'd5;
    localparam PR2=4'd6;
    localparam PR3=4'd7;
    localparam PR4=4'd8;
// case문에 들어갈 현재 상태
    localparam L1 = 18'd50000;
    localparam L2 = 18'd25000;
    localparam L3 = 18'd16667;
    localparam L4 = 18'd12500;

    localparam R1 = 18'd191571;
    localparam R2 = 18'd151976;
    localparam R3 = 18'd127551;
    localparam R4 = 18'd90253;
    // 주파수 설정

reg [3:0] state;
reg [22:0] dur_cnt;
reg [17:0] freq_cnt;   
reg [17:0] freq_limit;
// 주파수 값 할당
always@(*) begin
    case(state) 
        PL1: freq_limit=L1;
        PL2: freq_limit=L2;
        PL3: freq_limit=L3;
        PL4: freq_limit=L4;

        PR1: freq_limit=R1;
        PR2: freq_limit=R2;
        PR3: freq_limit=R3;
        PR4: freq_limit=R4;

    default: freq_limit=18'd0;
    endcase
end

always@(posedge clk, posedge reset) begin
    if(reset) begin
        state<=IDLE;
        dur_cnt<=0;
        freq_cnt<=0;
        buzzer<=1'b0;
    end else begin
        case(state) 
            IDLE: begin
                buzzer<=1'b0;
                dur_cnt<=0;
                freq_cnt<=0;
            if(btnL) 
                state<=PL1;
             else if(btnR) 
                state<=PR1;
            end
            PL1: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= PL2; // 다음 상태로 명확히 지정
                    end else dur_cnt <= dur_cnt + 1;

            end
            PL2: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= PL3;
                    end else dur_cnt <= dur_cnt + 1;



            end

            PL3: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= PL4;
                    end else dur_cnt <= dur_cnt + 1;

            end

            PL4: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= IDLE; // 시퀀스 종료
                    end else dur_cnt <= dur_cnt + 1;
            end
            PR1: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= PR2;
                    end else dur_cnt <= dur_cnt + 1;
            end
            PR2: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= PR3;
                    end else dur_cnt <= dur_cnt + 1;
            end

            PR3: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= PR4;
                    end else dur_cnt <= dur_cnt + 1;
            end

            PR4: begin
                if (freq_cnt >= freq_limit - 1) begin
                        freq_cnt <= 0;  buzzer <= ~buzzer;
                    end else freq_cnt <= freq_cnt + 1;

                    if (dur_cnt >= cnt_70ms - 1) begin
                        dur_cnt <= 0;   state <= IDLE; // 시퀀스 종료
                    end else dur_cnt <= dur_cnt + 1;
            end
            default: state <= IDLE;
        endcase

    end



end




endmodule
