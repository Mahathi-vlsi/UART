`timescale 1ns/1ps
module uart_tb;

reg clk, rst, tx_start;
reg [7:0] tx_data;
reg rx;
wire tx, tx_done;
wire [7:0] rx_data;
wire rx_done;

uart_top uut (
    .clk(clk), .rst(rst), .tx_start(tx_start), .tx_data(tx_data),
    .rx(rx), .tx(tx), .tx_done(tx_done), .rx_data(rx_data), .rx_done(rx_done)
);

always #10 clk = ~clk;

initial begin
    clk = 0; rst = 1; tx_start = 0; tx_data = 8'hA5; rx = 1;
    #100 rst = 0;
    #100 tx_start = 1;
    #20 tx_start = 0;
    #1000000 $finish;
end

endmodule