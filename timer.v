module Timer(clk_out, tmr, tmrp, tmrin, loadin, load, almin, alm, sw, tmr_cnt, select, buzz2);
    input clk_out, tmr, tmrp, tmrin, load, almin, alm, sw;
    output reg buzz2;
    output reg [16:0]tmr_cnt;
    input [2:0]select;
    reg [4:0]Thh = 0;
    reg [5:0]Tmm = 0,Tss = 0;
    input [3:0]loadin;
    output reg [3:0]Th1, Th2, Tm1, Tm2, Ts1, Ts2;

    reg update_cnt;

    always@(posedge clk_out)
    begin
        update_cnt <= 0;

        if(tmrin==1 && load==0 && almin==0)
        begin
            update_cnt <= 1;  // Set flag to update tmr_cnt next cycle
            case ({select[2], select[1], select[0]})
                3'b000:
                    begin
                        if(loadin<=9)
                            Ts2 <= loadin;
                    end
                3'b001:
                    begin
                        if(loadin<=5)
                            Ts1 <= loadin;
                    end
                3'b010:
                    begin
                        if(loadin<=9)
                            Tm2 <= loadin;
                    end
                3'b011:
                    begin
                        if(loadin<=5)
                            Tm1 <= loadin;
                    end
                3'b100:
                    begin
                        if(loadin<=4)
                            Th2 <= loadin;
                    end
                3'b101:
                    begin
                        if(loadin<=2)
                            Th1 <= loadin;
                    end
            endcase       
        end

        // Update the countdown timer value after loading digits
        if (update_cnt)
            tmr_cnt <= Ts2 + (Ts1 * 10) + (Tm2 * 60) + (Tm1 * 600) + (Th2 * 3600) + (Th1 * 36000); 


        if(tmr==1 && sw==0 && alm==0)
        begin
            if(tmrp==0 && tmr_cnt>0)
                tmr_cnt = tmr_cnt-1;
            
            Thh <= tmr_cnt / 3600;
            Tmm <= (tmr_cnt % 3600)/60;
            Tss <= tmr_cnt % 60;

            Th1 <= Thh / 10;
            Th2 <= Thh % 10;
            Tm1 <= Tmm / 10;
            Tm2 <= Tmm % 10;
            Ts1 <= Tss / 10;
            Ts2 <= Tss % 10; 

            if(tmr_cnt==0) 
                buzz2=1;
            else
                buzz2=0;
        end
        else
            buzz2=0;
    end
endmodule