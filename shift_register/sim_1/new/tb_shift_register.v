`timescale 1ns / 1ps

module tb_shift_register();
  reg clk;
  reg reset;
  reg in;
 
wire out;
shift_register u_shift_register(
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
);
always #5 clk = ~clk; //clk 생성 1주기 10ns (High 5ns, Low 5ns)
//값이 변하면 값을 출력한다.
initial begin
    $monitor("time=%t  in=%b out=%b" ,$time, in,out);
end
initial begin
    clk=0;
    reset=1;
    in=0;
    // reset 해제
    #100 reset=0;
    // #1 test pattern 1010111 10ns(1주기마다 1bit씩 날린다.)
    @(posedge clk); in=1;
    @(posedge clk); in=0;
    @(posedge clk); in=1;
    @(posedge clk); in=0;
    @(posedge clk); in=1;
    @(posedge clk); in=1;
    // S6->S1 :여기서 out=1이어야함.
    @(posedge clk); in=1;
    // 2번 테스트 011을 입력 시 S1으로 오는지 확인
    @(posedge clk); in=0;   // S1->S2 (10)
    @(posedge clk); in=1;   // S2->S3 (101)
    @(posedge clk); in=1;   // S3->S1 (1이 들어오면 S1으로 돌아감)
    // 3번 테스트 0101111 out=1이 되면 S1으로 돌아오는지 확인
    @(posedge clk); in=0; // S1->S2 (10)
    @(posedge clk); in=1; // S2->S3 (101)
    @(posedge clk); in=0; // S3->S4 (1010)
    @(posedge clk); in=1; // S4->S5 (10101)
    @(posedge clk); in=1; // S5->S6 (101011)
    @(posedge clk); in=1; // S6->S1 (1010111)
    #100;
    $display("===== Simulation finished =====");
    $finish;

end


endmodule
