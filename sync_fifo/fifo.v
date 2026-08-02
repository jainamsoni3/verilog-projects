module fifo #(parameter data_width=8, parameter depth=8)
(input clk, rst, write_en, read_en,
input wire [data_width-1:0]din,
output reg [data_width-1:0]dout,
output wire full, empty);

reg [data_width-1:0]mem[0:depth-1];

reg [$clog2(depth)-1:0]write_ptr;
reg [$clog2(depth)-1:0]read_ptr;
reg [$clog2(depth):0]count;

assign full = (count==depth);
assign empty = (count==0);
always @ (posedge clk) begin
    if (rst) begin
        write_ptr<=0;
        read_ptr<=0;
        dout<=0;
        count<=0;
    end
    else begin
        if (write_en && (!full || read_en))begin
            mem[write_ptr]<=din;
            write_ptr<=(write_ptr==depth-1)?0: write_ptr+1;
        end
        if (read_en && (!empty || write_en))begin
            dout<=mem[read_ptr];
            read_ptr<=(read_ptr==depth-1)?0 :read_ptr+1;
        end
        if ((write_en && !full) && !(read_en && !empty))begin
            count<=count+1;
        end
        else if (!(write_en && !full) && (read_en && !empty))begin
            count<=count-1;
        end
        end
end
endmodule
