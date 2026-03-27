module baud_gen_tb;

reg clk = 0;
reg reset = 1;
wire tick;

// instantiate your module
baud_gen uut (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// clock generation (100MHz → 10ns period)
always #5 clk = ~clk;

initial begin
    #20 reset = 0;   // release reset

    #200000 $finish; // run simulation
end

endmodule