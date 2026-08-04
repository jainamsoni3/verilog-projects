    module TrafficLight (input clk,rst,  
            output reg
            ns_g,ns_y,ns_r,
            ew_g,ew_y,ew_r);

        localparam nsg = 2'b00;
        localparam nsy = 2'b01;
        localparam ewg = 2'b10;
        localparam ewy = 2'b11;

        wire timer_done;

        reg [1:0] current,next;

        always @ (posedge clk or posedge rst) begin
            if(rst)
                current<=nsg;
            else
                current<=next;
        end
        reg [3:0]timer;
        always @ (posedge clk or posedge rst) begin
            if(rst)
                timer<=0;
            else if(timer_done)
                timer<=0;
            else
                timer<=timer+1;
        end
        assign timer_done=(current==nsg && timer==4'd10)||
                        (current==nsy && timer==4'd3)||
                        (current==ewg && timer==4'd10)||
                        (current==ewy && timer==4'd3);
        always @ (*) begin
            next=current;
            case(current)
                nsg:
                    if(timer_done)
                        next=nsy;
                nsy:
                    if(timer_done)
                        next=ewg;
                ewg:
                    if(timer_done)
                        next=ewy;
                ewy:
                    if(timer_done)
                        next=nsg;
                default:
                    next=nsg;
            endcase
        end
        always @ (*) begin
            case(current)
                nsg: begin
                    ns_g=1;
                    ns_y=0;
                    ns_r=0;
                    ew_g=0;
                    ew_y=0;
                    ew_r=1;
                end
                nsy: begin
                    ns_g=0;
                    ns_y=1;
                    ns_r=0;
                    ew_g=0;
                    ew_y=0;
                    ew_r=1;
                end
                ewg: begin
                    ns_g=0;
                    ns_y=0;
                    ns_r=1;
                    ew_g=1;
                    ew_y=0;
                    ew_r=0;
                end
                ewy: begin
                    ns_g=0;
                    ns_y=0;
                    ns_r=1;
                    ew_g=0;
                    ew_y=1;
                    ew_r=0;
                end
                default:begin
                    ns_g=0;
                    ns_y=0;
                    ns_r=1;
                    ew_g=0;
                    ew_y=0;
                    ew_r=1;
                end
            endcase
        end
    endmodule