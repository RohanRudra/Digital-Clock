module StopWatch(clk_out, swrst, swp, sw, SEC_CNT, sh1, sh2, sm1, sm2, ss1, ss2);
    input clk_out, swrst, swp, sw;
    output reg [16:0]SEC_CNT;
    reg [4:0]shh;
    reg [5:0]smm,sss;
    output reg [3:0]sh1,sh2,sm1,sm2,ss1,ss2;

    always@(posedge clk_out or posedge swrst)
    begin
        if(sw)
        begin
            if(swrst)
            begin
                SEC_CNT<=0;
                shh <= 0;
                smm <= 0;
                sss <= 0;
                sh1 <= 0;
                sh2 <= 0;
                sm1 <= 0;
                sm2 <= 0;
                ss1 <= 0;
                ss2 <= 0;
            end
            else begin
                if(swp == 0)
                SEC_CNT <= SEC_CNT + 1;     
            end
            shh <= SEC_CNT / 3600;
            smm <= (SEC_CNT % 3600)/60;
            sss <= SEC_CNT % 60;

            sh1 = shh / 10;
            sh2 = shh % 10;
            sm1 = smm / 10;
            sm2 = smm % 10;
            ss1 = sss / 10;
            ss2 = sss % 10;
        end
    end
endmodule