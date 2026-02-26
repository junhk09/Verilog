`timescale 1ns / 1ps


module tb_button_debounce();

    parameter CLK_FREQ = 100_000_000; //100MHz // #define이랑 똑같음
    parameter CLK_PERIOD=10; //10ns (100MHz의 한 주기)
    parameter BTN_PRESS_LIMIT=30_000_000; // 1ms=1,000,000ns

    reg clk;
    reg reset;
    reg btnC;
    wire [1:0] led;
    
 top_btn u_top_btn(
     .clk(clk),
     .reset(reset),
     .btnC(btnC),
     .led(led)
    );
    initial begin
        clk=0;
        forever #5 clk=~clk; //100MHz clk 생성
    end

       initial begin
        reset=1;
        btnC=0;
        #100;
        reset=0;
        // btn input 생성
        $display("[%0t] start btn noise generation.....", $time);
        #100 btnC=1;
        #200 btnC=0;
        #300 btnC=1;
        #120 btnC=0;
        #500 btnC=1;
        #(BTN_PRESS_LIMIT); //30ms
        #100;
        if(led !== 2'b00 ) begin
        $display("[%0t] Test Passed led changed.....", $time);

        end else begin
                    $display("[%0t] Test FAIL led not changed...", $time);


        end
        #1000;
        $display("==============Simulation Finish=============");
        $finish;


    end
endmodule
