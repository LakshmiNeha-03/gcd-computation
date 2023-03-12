`timescale 1ns / 1ps

module testbench();
reg [15:0] data;
reg clk,start;
wire done;

reg [15:0] A, B;

gcd_data_path DP( lt, gt, eq, lda, ldb, sel1, sel2, sel_in, data, clk);
contrl_path CON (lda, ldb, sel_in, sel1, sel2, done, clk, lt, gt, eq, start);

initial begin
clk =1'b0;
start =1'b1;
#1000 $finish;
end

always #5 clk = ~clk;

initial begin  
#12 data = 143;
#10 data = 78;
end

initial begin
$monitor ("time = %d,  GCD = %d, done =%b",$time, DP.a_out, done );
end

endmodule
