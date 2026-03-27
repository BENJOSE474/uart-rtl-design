module uart_tx_tb;

reg clk = 0;
reg reset = 1;
reg start = 0;
reg [7:0] data = 8'b10110010;

wire tx;
wire busy;
wire tick;

// instantiate baud generator
baud_gen bg (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// instantiate UART TX
uart_tx uut (
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
);

// clock generation (10 ns period)
always #5 clk = ~clk;

initial begin
    #20 reset = 0;

    // wait for rising edge of tick
    @(posedge tick);
    start = 1;

    // keep start for one tick
    @(posedge tick);
    start = 0;

    #2000;
    $finish;
end
endmodule