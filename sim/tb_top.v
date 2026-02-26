`timescale 1ns / 1ps


module tb_top();
    reg clk;
    reg reset;
    reg [2:0] btn;
    reg [7:0] sw;
    wire [15:0] led;
    wire [7:0] seg;
    wire [3:0] an;

 top u_top(
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .sw(sw),
        .led(led),
        .seg(seg),
        .an(an)
    );
// 100MHz  clock 생성 (10ns주기)
    always #5 clk= ~clk;
    task btn_press;
    input integer  btn_index; // integer signed 32bit reg[32:0] 비트처럼 선언
   begin
   $display("btn_press btn:%0d start",btn_index);
    // make noise(0.55ms)
    btn[btn_index]=1; #100000; //0.1ms High
    btn[btn_index]=0; #200000; //0.2ms Low
     btn[btn_index]=1; #150000; //0.15ms High
    btn[btn_index]=0; #200000; //0.2ms Low
    // 안정 구간 11ms 유지-이 구간이 지나야 clean_btn이 1이 된다.
    btn[btn_index]=1;
    #11000000; // 11ms 유지
    // btn을 뗀다(10ms 이상)
     btn[btn_index]=0;
    #11000000;
    $display("btn_press btn:%0d FINISH", btn_index);
   end

    endtask
    initial begin
        $monitor("time=%t mode=%b an=%b seg=%b", $time, led[15:13], an, seg);
        // led[15:13]나 an, seg값이 바뀌면 출력한다.
    end
    initial begin
        clk=0;
        reset=1;
        btn=3'b000;
        sw=8'b00000000;
        //reset 해제
        #100;
        reset=0;
        #100;
        // mode 변경 코드, IDLE->UP_COUNTER_BTN[0]=btnL
        $display("MODE ILD -- UP_COUNTER");
        btn_press(0); 
        // UP_COUNTER 동작 관찰
        #20000000; //20ms

        // 모드 변경 UP->DOWN
            $display("MODE ILD -- DOWN_COUNTER");
            btn_press(0); 
        //Down Counter 동작 관찰
        #10000000;
        // 모드 변경 DOWN->SLIDE_SW_READ
          $display("MODE ILD -- SLIDE_SW_READ");
            btn_press(0); 
            sw=8'h55;
            #1000000;
            sw=8'hAA;
            #1000000;
            $display("SIMULATION ENDED!!");
            $finish;

    end
endmodule


