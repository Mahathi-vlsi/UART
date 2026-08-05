module uart_tx #(
    parameter CLK_FREQ = 100_000_000, // 100MHz
    parameter BAUD = 9600
)(
    input clk,
    input reset,
    input tx_start,              // 1 clock pulse to start
    input [7:0] tx_data,         // 8-bit data
    output reg tx,               // Serial out
    output reg tx_busy           // 1 when transmitting
);

localparam BAUD_TICK = CLK_FREQ / BAUD; // 10416 for 9600 baud

reg [13:0] baud_cnt;
reg [3:0] bit_cnt;    // 0 to 9: start + 8data + stop
reg [7:0] data_reg;

localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
reg [1:0] state;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        tx <= 1'b1;         // Idle = 1
        tx_busy <= 0;
        state <= IDLE;
        baud_cnt <= 0;
        bit_cnt <= 0;
    end
    else
    begin
        case(state)
            IDLE: begin
                tx <= 1'b1;
                tx_busy <= 0;
                if(tx_start)
                begin
                    data_reg <= tx_data;
                    state <= START;
                    tx_busy <= 1;
                    baud_cnt <= 0;
                end
            end
            
            START: begin  // Start bit = 0
                tx <= 1'b0;
                if(baud_cnt == BAUD_TICK-1)
                begin
                    baud_cnt <= 0;
                    state <= DATA;
                    bit_cnt <= 0;
                end
                else baud_cnt <= baud_cnt + 1;
            end
            
            DATA: begin  // 8 data bits LSB first
                tx <= data_reg[bit_cnt];
                if(baud_cnt == BAUD_TICK-1)
                begin
                    baud_cnt <= 0;
                    if(bit_cnt == 7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                else baud_cnt <= baud_cnt + 1;
            end
            
            STOP: begin  // Stop bit = 1
                tx <= 1'b1;
                if(baud_cnt == BAUD_TICK-1)
                begin
                    baud_cnt <= 0;
                    state <= IDLE;
                end
                else baud_cnt <= baud_cnt + 1;
            end
        endcase
    end
end

endmodule