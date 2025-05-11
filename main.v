`include "sevenseg.v"
`include "stopwatch.v"
`include "alarm.v"
`include "timer.v"
`include "clock.v"

module digi_clk(clk,rst,load,loadin,select,Anode_Activate,LED_out,swrst,swp,sw,alm,almin,buzz,tmr,tmrin,buzz2,tmrp,th1,th2);
    input clk,rst,load;
    input [3:0]loadin;
    input [2:0]select;
    input alm,almin;
    input swrst,swp,sw;
    input tmr,tmrin;
    input tmrp;
    output buzz2;
    output [3:0]Anode_Activate;
    output [6:0]LED_out;
    output buzz;
    output reg [3:0]th1;
    output reg [3:0]th2;

    reg [3:0]tm1,tm2,ts1,ts2;

    reg clk_out = 0; // 1Hz clock output
    reg [25:0]count = 0;

    ////////////////////////////////////////////////////////////////////////////
    //Clock Divider (Converts 50MHz clk to 1Hz clk_out)

    always@(negedge clk)
    begin
        count = count+1;
        if(count == 50000000)
        begin
            clk_out <= !clk_out;
            count <= 0;
        end
    end

    ////////////////////////////////////////////////////////////////////////////
    //StopWatch

    wire [16:0]SEC_CNT;
    wire [3:0]sh1,sh2,sm1,sm2,ss1,ss2;

    StopWatch stopwatch(clk_out,swrst,swp,sw,SEC_CNT,sh1,sh2,sm1,sm2,ss1,ss2);

    ////////////////////////////////////////////////////////////////////////////
    //Alarm

    wire [3:0]ah1,ah2,am1,am2;
    wire [16:0]alm_cnt;

    Alarm alarm(ah1,ah2,am1,am2,alm_cnt,buzz,clk_out,loadin,load,almin,alm,SEC_CNT,select);

    ////////////////////////////////////////////////////////////////////////////
    //Timer

    wire [16:0]tmr_cnt;
    wire [3:0]Th1,Th2,Tm1,Tm2,Ts1,Ts2;

    Timer Timer(clk_out,tmr,tmrp,tmrin,loadin,load,almin,alm,sw,tmr_cnt,select,buzz2);

    ////////////////////////////////////////////////////////////////////////////
    //Clock

    wire [16:0]sec_cnt;
    wire [3:0]h1,h2,m1,m2,s1,s2;

    Clock Clock(clk_out, rst, load, almin, tmrin, sec_cnt, h1, h2, m1, m2, s1, s2, loadin);

    ////////////////////////////////////////////////////////////////////////////
    //Setting the 7 segment display

    always@(posedge clk)
    begin
        if(sw)
        begin
            ts2 = ss2;
            ts1 = ss1;
            tm2 = sm2;
            tm1 = sm1;
            th2 = sh2;
            th1 = sh1;
        end
        else if(almin)
        begin
            ts2 = 0;
            ts1 = 0;
            tm2 = am2;
            tm1 = am1;
            th2 = ah2;
            th1 = ah1;
        end
        else if(tmrin || tmr)
        begin
            ts2 = Ts2;
            ts1 = Ts1;
            tm2 = Tm2;
            tm1 = Tm1;
            th2 = Th2;
            th1 = Th1;
        end
        else
        begin
            ts2 = s2;
            ts1 = s1;
            tm2 = m2;
            tm1 = m1;
            th2 = h2;
            th1 = h1;
        end 
    end

    sseg dis(clk,ts2,ts1,tm2,tm1,LED_out,Anode_Activate);

endmodule



