module alu_tb;
reg [7:0]a;
reg [7:0]b;
reg [2:0]op;

wire [7:0]out;
wire zero_f,carry_f,negative_f,overflow_f;

alu uut(.a(a),.b(b),.op(op),.out(out),.zero_f(zero_f),.carry_f(carry_f),.negative_f(negative_f),.overflow_f(overflow_f));
initial begin 
    $dumpfile("wave.vcd");
    $dumpvars(0, alu_tb);
    a=8'd10; b=8'd5; 
    op=3'b000; #10;
    op=3'b001; #10;
    op=3'b010; #10;
    op=3'b011; #10;
    op=3'b100; #10;
    op=3'b101; #10;
    op=3'b110; #10;
    op=3'b111; #10;

    $finish; 
end
endmodule

