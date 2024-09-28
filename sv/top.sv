module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
bit         clk;
  bit         rst_n;
  ifa memory_bus(clk, rst_n);
  
assign rst_n = 1;
// SYSTEMVERILOG:: implicit .* port connections.
  test_fifo test (.tbus(memory_bus));

// SYSTEMVERILOG:: implicit .name port connections
  fifo block ( .mbus(memory_bus));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

always #5 clk = ~clk;
endmodule
