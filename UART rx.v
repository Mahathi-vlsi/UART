module uart_rx #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD = 9600
)(
    input clk,
    input reset,
    input rx,                    // Serial in
    output reg [7:0] rx_data,    // 8-bit data out
    output reg rx_done           // 1 clock pulse when data ready
);

localparam BAUD_TICK = CLK_FREQ / BAUD;
localparam HALF_BAUD = BAUD_TICK / 2;

reg [13:0] baud_cnt;
reg [3:0] bit_cnt;
reg [7:0] data_reg;

reg rx_sync1, rx_sync2;  // metastability kosam
always @(posedge clk) {rx_sync2, rx_sync1} <= {rx_sync1, rx};

localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
reg [1:0] state;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state <= IDLE;
        rx_done <= 0;
        baud_cnt <= 0;
        bit_cnt <= 0;
    end
    else
    begin
        rx_done <= 0;
        case(state)
            IDLE: begin
                if(rx_sync2 == 0) // Start bit detect
                begin
                    state <= START;
                    baud_cnt <= 0;
                end
            end
            
            START: begin // Start bit middle lo sample
                if(baud_cnt == HALF_BAUD-1)
                begin
                    if(rx_sync2 == 0) // confirm start bit
                    begin
                        baud_cnt <= 0;
                        state <= DATA;
                        bit_cnt <= 0;
                    end
                    else state <= IDLE; // false start
                end
                else baud_cnt <= baud_cnt + 1;
            end
            
            DATA: begin // 8 bits LSB first
                if(baud_cnt == BAUD_TICK-1)
                begin
                    baud_cnt <= 0;
                    data_reg[bit_cnt] <= rx_sync2;
                    if(bit_cnt == 7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                else baud_cnt <= baud_cnt + 1;
            end
            
            STOP: begin // Stop bit check
                if(baud_cnt == BAUD_TICK-1)
                begin
                    rx_data <= data_reg;
                    rx_done <= 1; // data ready pulse
                    state <= IDLE;
                end
                else baud_cnt <= baud_cnt + 1;
            end
        endcase
    end
end

endmodule