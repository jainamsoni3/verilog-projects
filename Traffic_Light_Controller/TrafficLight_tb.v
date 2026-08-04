`timescale 1ns/1ps
module TrafficLight_tb;
    reg clk,rst;

    wire ns_g,ns_y,ns_r,ew_g,ew_y,ew_r;

    TrafficLight dut (.clk(clk),
                      .rst(rst),
                      .ns_g(ns_g),
                      .ns_y(ns_y),
                      .ns_r(ns_r),
                      .ew_g(ew_g),
                      .ew_y(ew_y),
                      .ew_r(ew_r)
                      );
    initial 
        clk=0;
    always 
        #5 clk=~clk;

    initial begin
        rst=1;
        #20 rst=0;
    end

    initial begin
        $dumpfile("TrafficLight.vcd");
        $dumpvars(0,TrafficLight_tb);
    end

    initial begin
        #250;
        $finish;
    end
endmodule

