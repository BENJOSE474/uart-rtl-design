module uart_tx(
    input clk,
    input reset,
    input tick,
    input start,
    input [7:0] data,
    output reg tx,
    output reg busy
);

parameter IDLE  = 0,
          START = 1,
          DATA  = 2,
          STOP  = 3;

reg [1:0] state;
reg [7:0] data_reg;
reg [3:0] bit_index;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        tx <= 1;
        busy <= 0;
    end else begin
        if (tick) begin
            case (state)

                IDLE: begin
                    tx <= 1;
                    busy <= 0;

                    if (start) begin
                        data_reg <= data;
                        state <= START;
                        busy <= 1;
                    end
                end

                START: begin
                    tx <= 0;
                    bit_index <= 0;
                    state <= DATA;
                end

                DATA: begin
                    tx <= data_reg[bit_index];

                    if (bit_index == 7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1;
                end

                STOP: begin
                    tx <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end
end

endmodule