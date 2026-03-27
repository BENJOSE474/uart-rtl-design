module uart_rx (
    input clk,
    input reset,
    input tick,
    input rx,
    output reg [7:0] data_out,
    output reg done
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
        data_reg <= 0;
        data_out <= 0;
        bit_index <= 0;
        done <= 0;
    end else begin
        done <= 0;

        case (state)

            
            IDLE: begin
                if (rx == 0) begin
                    state <= START;
                end
            end

            START: begin
                if (tick) begin
                    bit_index <= 0;
                    state <= DATA;
                end
            end

            DATA: begin
                if (tick) begin
                    data_reg[bit_index] <= rx;

                    if (bit_index == 7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1;
                end
            end

            STOP: begin
                if (tick) begin
                    data_out <= data_reg;
                    done <= 1;
                    state <= IDLE;
                end
            end

        endcase
    end
end

endmodule