`timescale 1ns/1ps

module SynchFIFOTb;

reg clk=0, reset, cs, wr_en, rd_en;
reg [31:0] data_in;
wire [31:0] data_out;
wire full, empty;

initial clk = 1;
always #5 clk <= ~clk;

integer i;

SynchFIFO DUT(clk , reset , cs,  wr_en , rd_en , data_in , data_out , empty , full);

initial begin
    $dumpvars(0,SynchFIFOTb);
    $dumpfile("Fifo.vcd");
end

task write_data(input [31:0] d_in);
begin
@(posedge clk);
cs = 1 ; wr_en = 1;
data_in = d_in;
$display($time , "Write Data = %0d",data_in);
@(posedge clk);
wr_en = 0;
end
endtask

task read_data();
begin
@(posedge clk);
cs = 1 ; rd_en = 1;
@(posedge clk);
$display($time , "Read Data = %0d" ,data_out);
rd_en = 0;
end
endtask

initial
begin
reset = 1;
#1;
// rd_en = 0; wr_en = 0;

@(posedge clk)
reset = 0;
for(i = 0 ; i<8 ; i=i+1) begin
write_data(2**i);
end

for(i = 0 ; i<8 ; i=i+1) begin
read_data();
end
#40 $finish;
end

endmodule