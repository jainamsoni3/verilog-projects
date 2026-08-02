`timescale 1ns/1ps
module fifo_tb;
    integer i;
    parameter data_width=8;
    parameter depth=8;

    reg clk;
    reg rst;
    reg write_en;
    reg read_en;
    reg [data_width-1:0]din;
    wire [data_width-1:0]dout;
    wire full;
    wire empty;
    
    fifo #(.data_width(data_width), .depth(depth))
    dut (.clk(clk),
     .rst(rst),
     .write_en(write_en),
     .read_en(read_en),
     .din(din),
     .dout(dout),
     .full(full),
     .empty(empty));
    
    initial clk=0;
    always #5 clk=~clk;
    
    task write_fifo;
         input [data_width-1:0] data;
         begin
            @ (posedge clk); #1;
            write_en = 1;
            read_en = 0;
            din = data;
            @ (posedge clk); #1;
            write_en = 0;
         end
    endtask

    task read_fifo;
         begin
            @ (posedge clk); #1;
            read_en = 1;
            write_en = 0;
            @ (posedge clk); #1;
            read_en = 0;
         end
    endtask

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        write_en=0;
        read_en=0;
        din=0;

        $display("\n Test 1: Reset ");
        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        @(posedge clk); 
        $display("After reset -> empty=%b full=%b (expect 1,0)", empty, full);

        $display("\n Test 2: Fill FIFO ");
        for (i = 1; i <= 8; i = i + 1) begin
            write_fifo(i * 10);     
            $display("Wrote %0d | full=%b empty=%b", i*10, full, empty);
        end
        $display("FIFO should be FULL now -> full=%b (expect 1)", full);

        $display("\n Test 3: Write to FULL FIFO (should be ignored)");
        write_fifo(8'hFF);
        $display("Tried writing 0xFF to full FIFO -> full=%b (should still be 1)", full);
        
        $display("\n--- TEST 4: Read all values (check order = FIFO order) ---");
        for (i = 1; i <= 8; i = i + 1) begin
            read_fifo();
            $display("Read #%0d -> dout=%0d (expect %0d)", i, dout, i*10);
        end
        $display("FIFO should be EMPTY now -> empty=%b (expect 1)", empty);

        $display("\n Test 5: Read from EMPTY FIFO (should be ignored)");
        read_fifo();
        $display("Tried reading from empty FIFO -> empty=%b (should still be 1)", empty);

         $display("\n Test 6: Simultaneous Read+Write ");
        write_fifo(8'hAA);          
        @(posedge clk); #1;
        write_en = 1;
        read_en  = 1;
        din      = 8'hBB;
        @(posedge clk); #1;
        write_en = 0;
        read_en  = 0;
        $display("Simultaneous RW done -> full=%b empty=%b", full, empty);

         $display("\n Test 7: Pointer Wrap-Around");
        rst = 1; repeat(2) @(posedge clk); #1; rst = 0; 
        for (i = 0; i < 6; i = i + 1) begin
            if (!full) begin
            write_fifo(i);
            end
        end
        for (i = 0; i<3; i=i+1)begin
            if (!empty)begin
            read_fifo();
            end
        end
        for (i = 0; i < 4; i = i + 1) begin
            if (!full) begin
            write_fifo(i);
            end
        end
        for (i = 0; i<8; i=i+1)begin
            if (!empty)
            begin
            read_fifo();
            $display("Wrap i=%0d -> dout=%0d full=%b empty=%b", i, dout, full, empty);
            end
        end

        $display("\n All tests complete");
        #20;
        $finish;    
    end
endmodule