module test_fifo (ifa.testbench tbus);
  
  timeunit 1ns;
  timeprecision 1ns;
  
  
// Monitor Results
  initial begin
    $timeformat ( -9, 0, " ns", 9 );
    #90000ns $display ( "MEMORY TEST TIMEOUT" );
    $finish;
  end
  
  logic [tbus.DATA_WIDTH-1:0] test_buffer[0:tbus.DEPTH -1];
  logic [7:0] rdata;
  logic debug = 1;
  logic [7:0] j = 12;
  logic [7:0] h = $random;
    int i;
  
  initial
    begin: test_fifo
      tbus.wr_en = 0;
      tbus.rd_en = 0;
      
       /*//Test Case 1:
      $display("######## TEST 1:Filling the FIFO to its maximum capacity! ########");

      for(int i = 0; i< tbus.DEPTH; i++)begin
        tbus.fifo_write(j);
      end
      
      for(int i = 0; i< tbus.DEPTH; i++)begin
        tbus.fifo_read(rdata);
        if(rdata != j) begin
          $display("########TEST FAIL!#########");
        end
      
      end

      $display("########Test Passed!########");
      */
      
       //Test Case 2:
      $display("######## TEST 2:Full Flag and Overflow test ########");
       fifo_flag_test();

      
      //Test Case 3:
     
      $display("######## TEST 3:Randomized Checker########");
      randomized_test();
     
      
      
    
    end //INITIAL BLOCK ENDS
  
  
 // TASKS

  
  task fifo_flag_test;
  // Fill the FIFO to its maximum capacity
    for (int i = 0; i < tbus.DEPTH; i++) begin
      tbus.fifo_write(h);
    end

  // Try to write one more data item
    tbus.fifo_write(j);

  // Check if the full flag is set and overflow flag is unset
    if (!tbus.full || tbus.overflow) begin
      $display("TEST FAILED! Incorrect full or overflow flag");
    end

  // Empty the FIFO
    for (int i = 0; i < tbus.DEPTH; i++) begin
      tbus.fifo_read(rdata);
    end

  // Try to read one more data item
    tbus.fifo_read(rdata);

  // Check if the empty flag is set and underflow flag is unset
    if (!tbus.empty || tbus.underflow) begin
      $display("TEST FAILED! Incorrect empty or underflow flag");
    end
    
    else begin
      $display("########Test Passed!########");
    end
endtask

  
task randomized_test;
  logic [7:0] expected_data[tbus.DEPTH];
  logic [7:0] random_data;
  int i;

  // Generate random data and write it to FIFO
  for (i = 0; i < tbus.DEPTH; i++) begin
    random_data = $urandom; 
    expected_data[i] = random_data;
    tbus.fifo_write(random_data);
  end

  // Verify data integrity
  for (i = 0; i < tbus.DEPTH; i++) begin
    logic [7:0] rdata;
    tbus.fifo_read(rdata);
    if (rdata != expected_data[i]) begin
      $display("TEST FAIL: Expected %h, Actual %h", expected_data[i], rdata);
    end
  end
endtask

  
endmodule
