interface ifa #(
    parameter DATA_WIDTH = 8, // Width of data in bits
    parameter DEPTH = 16      // Depth of FIFO
)(
  input clk, input rst_n);
  logic wr_en, rd_en; 
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty, overflow, underflow; 
  
  modport fifoport (input wr_en, rd_en, data_in, clk, rst_n, output data_out, full, empty, overflow, underflow);
  modport testbench (input data_out, full, empty, overflow, underflow, clk, rst_n, output wr_en, rd_en, data_in, import fifo_write, fifo_read);

task fifo_write(input [7:0] wdata);
    
    @(negedge clk) begin
      wr_en <= 1;    
      
    end
    
    data_in = wdata;
    @(posedge clk);
    wr_en <= 0;
    
    if(full) begin
      $display("FIFO is full! Cannot Enter more values!");     
    end
    

    $display("Write Data Value :%d", data_in);

    
  endtask
  
  task fifo_read(output [DATA_WIDTH-1:0] rdata);
    
    @(negedge clk) begin 
      #1
      rd_en <= 1;
      
    end
   
    @(posedge clk);
    rd_en <= 0;
    rdata = data_out;
    
    if(empty) begin
      
      $display("FIFO is empty! Cannot read values!");
    end
 
    $display("Read Data Value :%d", rdata);
    
    
  endtask
  
endinterface : ifa
