module Clock(clk_out, rst, load, almin, tmrin, sec_cnt, h1, h2, m1, m2, s1, s2, loadin);
    input clk_out,rst,load,almin,tmrin;
    input [2:0]select; 
    output reg [16:0]sec_cnt;
    reg [4:0]hh;
    reg [5:0]mm,ss;
    input [3:0]loadin;
    output reg [3:0]h1,h2,m1,m2,s1,s2;

    reg update_cnt;

    always@(posedge clk_out or posedge rst)
    begin
        update_cnt <= 0;

        if(rst)
        begin
            sec_cnt<=0;
            hh <= 0;
            mm <= 0;
            ss <= 0;
            h1 <= 0;
            h2 <= 0;
            m1 <= 0;
            m2 <= 0;
            s1 <= 0;
            s2 <= 0;
        end
        else if(sec_cnt==86400)
        begin
            sec_cnt<=0;
            hh <= 0;
            mm <= 0;
            ss <= 0;
            h1 <= 0;
            h2 <= 0;
            m1 <= 0;
            m2 <= 0;
            s1 <= 0;
            s2 <= 0;
        end

        else
        begin
            if(load==1 && almin==0 && tmrin==0)
            begin
                case ({select[2], select[1], select[0]})
                    3'b000:
                        begin
                            if(loadin<=9)
                                s2 <= loadin;
                        end
                    3'b001:
                        begin
                            if(loadin<=5)
                                s1 <= loadin;
                        end
                    3'b010:
                        begin
                            if(loadin<=9)
                                m2 <= loadin;
                        end
                    3'b011:
                        begin
                            if(loadin<=5)
                                m1 <= loadin;
                        end
                    3'b100:
                        begin
                            if(loadin<=4)
                                h2 <= loadin;
                        end
                    3'b101:
                        begin
                            if(loadin<=2)
                                h1 <= loadin;
                        end
                endcase
            end

            if(update_cnt)
                sec_cnt <= s2 + (s1 * 10) + (m2 * 60) + (m1 * 600) + (h2 * 3600) + (h1 * 36000);

            if(load==0)
            begin
                sec_cnt <= sec_cnt+1;
            end
        end

        hh <= sec_cnt / 3600;
        mm <= (sec_cnt % 3600)/60;
        ss <= sec_cnt % 60;
        h1 = hh / 10;
        h2 = hh % 10;
        m1 = mm / 10;
        m2 = mm % 10;
        s1 = ss / 10;
        s2 = ss % 10; 
    end
endmodule