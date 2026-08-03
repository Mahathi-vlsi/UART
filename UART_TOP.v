module uart_top (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    input rx,
    output tx,
    output tx_done,
    output [7:0] rx_data,
    output rx_done
);

uart_tx u_tx (
    .clk(clk), .rst(rst), .tx_start(tx_start), .tx_data(tx_data),
    .tx(tx), .tx_done(tx_done)
);

uart_rx u_rx (
    .clk(clk), .rst(rst), .rx(rx),
    .rx_data(rx_data), .rx_done(rx_done)
);

endmodule