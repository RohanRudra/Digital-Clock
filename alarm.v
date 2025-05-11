module Alarm(ah1, ah2, am1, am2, alm_cnt, buzz, clk_out, loadin, load, almin, alm, sec_cnt, select);
    input clk_out,load,almin,alm;
    input [16:0]sec_cnt;
    output reg [16:0] alm_cnt;
    input [2:0]select;
    input [3:0]loadin;
    output reg [3:0]ah1, ah2, am1, am2;
    output reg buzz;

    reg update_cnt;

    always@(posedge clk_out)
    begin
        update_cnt <= 0;

        if(almin == 1 && load == 0)
        begin
            case ({select[2], select[1], select[0]})
                3'b010:
                    begin
                        if(loadin<=9)
                            am2 <= loadin;
                    end
                3'b011:
                    begin 
                        if(loadin<=5)
                            am1 <= loadin;
                    end
                3'b100:
                    begin 
                        if(loadin<=4)
                            ah2 <= loadin;
                    end
                3'b101:
                    begin 
                        if(loadin<=2)
                            ah1 <= loadin;
                    end
            endcase
        end

        // Update the alarm time value after loading digits
        if(update_cnt)
            alm_cnt <= (am2 * 60) + (am1 * 600) + (ah2 * 3600) + (ah1 * 36000);

        if(alm==1)
        begin
            if(alm_cnt<=sec_cnt && sec_cnt<alm_cnt+60)
                buzz=1;
            else
                buzz=0; 
        end
        else
            buzz=0;
    end

endmodule