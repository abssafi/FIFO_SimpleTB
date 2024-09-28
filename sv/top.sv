#include "ifa"
module fifo (ifa.fifoport mbus);

// Internal variables
  reg [mbus.DATA_WIDTH-1:0] buffer[0:mbus.DEPTH-1]; // FIFO buffer
  reg [$clog2(mbus.DEPTH):0] count = 0; // Number of items in FIFO, extra bit for full detection
  reg [$clog2(mbus.DEPTH)-1:0] wr_ptr = 0; // Write pointer
  reg [$clog2(mbus.DEPTH)-1:0] rd_ptr = 0; // Read pointer

// Full and empty logic
  assign mbus.full = (count == mbus.DEPTH);
assign mbus.empty = (count == 0);


// Simultaneous read and write handling
  always @(posedge mbus.clk or negedge mbus.rst_n) begin
    if (!mbus.rst_n) begin
        // Asynchronous reset
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
        mbus.overflow <= 0;
        mbus.underflow <= 0;
    end else begin
        // Default the flags to 0
        mbus.overflow <= 0;
        mbus.underflow <= 0;
        
        // Check for write attempt when FIFO is full
      if (mbus.wr_en && mbus.full) begin
            mbus.overflow <= 1;
        end

        // Check for read attempt when FIFO is empty
      if (mbus.rd_en && mbus.empty) begin
            mbus.underflow <= 1;
        end

        // Perform write operation if enabled and not full
      if (mbus.wr_en && !mbus.full) begin
        buffer[wr_ptr] <= mbus.data_in;
        wr_ptr <= (wr_ptr + 1) % mbus.DEPTH;
            // Only increment count if a read is not also happening
        if (!mbus.rd_en || mbus.empty) begin
                count <= count + 1;
            end
        end

        // Perform read operation if enabled and not empty
      if (mbus.rd_en && !mbus.empty) begin
            mbus.data_out <= buffer[rd_ptr];
        rd_ptr <= (rd_ptr + 1) % mbus.DEPTH;
            // Only decrement count if a write is not also happening
        if (!mbus.wr_en || mbus.full) begin
                count <= count - 1;
            end
        end
    end
end


endmodule
