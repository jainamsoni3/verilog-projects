module alu(input [7:0]a,b, input [2:0]op, output reg [7:0]out, output reg zero_f, carry_f, negative_f, overflow_f);
reg [8:0]temp;
always @(*)begin
    carry_f=0;
    overflow_f=0;
    case(op)
    3'b000: begin
        temp=a+b;
        out=temp[7:0];
        carry_f=temp[8];
    end
    3'b001: begin
        temp=a-b;
        out=temp[7:0];
        carry_f=temp[8];
    end
    3'b010: out=a&b;
    3'b011: out=a|b;
    3'b100: out=a^b;
    3'b101: out=~a;
    3'b110: out=a<<1;
    3'b111: out=a>>1;
    endcase
    zero_f=(out==8'b00000000);
    negative_f=out[7];              // if MSB is 1 then the number is negative
end
endmodule
