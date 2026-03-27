module uart_rx_tb;

reg clk = 0;
reg reset = 1;
reg rx = 1;   // idle state is HIGH
wire tick;

wire [7:0] data_out;
wire done;

// clock
always #5 clk = ~clk;

// baud generator
baud_gen bg (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// UART RX
uart_rx uut (
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .rx(rx),
    .data_out(data_out),
    .done(done)
);


// task to send 1 bit for 1 tick duration
task send_bit(input bit_val);
begin
    @(negedge tick);
    rx = bit_val;
    @(posedge tick);
end
endtask


initial begin
    // reset
    #20 reset = 0;

    // wait a little
    #20;

    // START BIT
    send_bit(0);

    // DATA (LSB first for 8'b10110010)
    send_bit(0); // bit 0
    send_bit(1); // bit 1
    send_bit(0); // bit 2
    send_bit(0); // bit 3
    send_bit(1); // bit 4
    send_bit(1); // bit 5
    send_bit(0); // bit 6
    send_bit(1); // bit 7

    // STOP BIT
    send_bit(1);

    // wait for done
    @(posedge done);

    $display("Received Data = %b", data_out);

    #50 $finish;
end

endmodule