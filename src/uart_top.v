module uart_top (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    input rx,
    output tx,
    output [7:0] data_out,
    output rx_done
);

wire tick;

// baud generator
baud_gen bg (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// transmitter
uart_tx tx_inst (
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .start(start),
    .data(data_in),
    .tx(tx),
    .busy()
);

// receiver
uart_rx rx_inst (
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .rx(rx),
    .data_out(data_out),
    .done(rx_done)
);

endmodule