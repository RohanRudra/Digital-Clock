module digi_clk(clk,rst,load,loadin,select,Anode_Activate,LED_out,swrst,swp,sw,alm,almin,buzz,tmr,tmrin,buzz2,tmrp,th1,th2);
input clk,rst,load;
input [3:0]loadin;
input [2:0]select;
input alm,almin;
input swrst,swp,sw;
input tmr,tmrin;
input tmrp;
output reg buzz2;
output [3:0]Anode_Activate;
output [6:0]LED_out;
output reg buzz;
output reg [3:0]th1;
output reg [3:0]th2;

reg [3:0]tm1,tm2,ts1,ts2;

reg clk_out=0;
reg [25:0]count=0;

////////////////////////////////////////////////////////////////////////////
//Clock Divider

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

reg [16:0]SEC_CNT=0;
reg [4:0]shh;
reg [5:0]smm,sss;
reg [3:0]sh1,sh2,sm1,sm2,ss1,ss2;

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
        else
        begin
            if(swp == 0)
               SEC_CNT = SEC_CNT + 1;     
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

////////////////////////////////////////////////////////////////////////////
//Alarm

reg [3:0]ah1=0;
reg [3:0]ah2=0;
reg [3:0]am1=0;
reg [3:0]am2=0;
reg [16:0]alm_cnt=0;

always@(posedge clk_out)
begin

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
    alm_cnt <= (am2 * 60) + (am1 * 600) + (ah2 * 3600) + (ah1 * 36000);
end
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

////////////////////////////////////////////////////////////////////////////
//Timer

reg [16:0]tmr_cnt=0;
reg [4:0]Thh=0;
reg [5:0]Tmm=0;
reg [5:0]Tss=0;
reg [3:0]Th1=0;
reg [3:0]Th2=0;
reg [3:0]Tm1=0;
reg [3:0]Tm2=0;
reg [3:0]Ts1=0;
reg [3:0]Ts2=0;

always@(posedge clk_out)
begin

if(tmrin==1 && load==0 && almin==0)
begin
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
    tmr_cnt <= Ts2 + (Ts1 * 10) + (Tm2 * 60) + (Tm1 * 600) + (Th2 * 3600) + (Th1 * 36000);        
end
if(tmr==1 && sw==0 && alm==0)
begin
    if(tmrp==0 && tmr_cnt>0)
    begin
        tmr_cnt=tmr_cnt-1;
    end
    Thh = tmr_cnt / 3600;
    Tmm = (tmr_cnt % 3600)/60;
    Tss = tmr_cnt % 60;
    Th1 = Thh / 10;
    Th2 = Thh % 10;
    Tm1 = Tmm / 10;
    Tm2 = Tmm % 10;
    Ts1 = Tss / 10;
    Ts2 = Tss % 10; 
    if(tmr_cnt==0) 
        buzz2=1;
    else
        buzz2=0;
 
end
else
   buzz2=0;
end

////////////////////////////////////////////////////////////////////////////
//Clock

reg [16:0]sec_cnt=0;
reg [4:0]hh;
reg [5:0]mm,ss;
reg [3:0]h1,h2,m1,m2,s1,s2;

always@(posedge clk_out or posedge rst)
begin
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
            sec_cnt <= s2 + (s1 * 10) + (m2 * 60) + (m1 * 600) + (h2 * 3600) + (h1 * 36000);
        end
       if(load==0)
        begin
           sec_cnt = sec_cnt+1;
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



module sseg(
   input clk_100MHz,               // Nexys 3 clock
   input [3:0] ones,  // ones value of the input number
	input [3:0] tens,  // tens value of the input number
	input [3:0] hundreds, // hundreds value of the input nnumber
	input [3:0] thousands ,// thousands value of the input number
    output reg [6:0] SEG,           // 7 Segments of Displays
    output reg [3:0] AN             // 4 Anodes Display
    );
    
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9


    // To select each digit in turn
    reg [1:0] anode_select;        
    reg [16:0] anode_timer;             
    // Logic for controlling digit select and digit timer
    always @(posedge clk_100MHz) begin  // 1ms x 4 displays = 4ms refresh period
        if(anode_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
            anode_timer <= 0;                   // 10ns x 100,000 = 1ms
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end
    
    // Logic for driving the 4 bit anode output based on digit select
    always @(anode_select) begin
        case(anode_select) 
            2'b00 : AN = 4'b1110;   // Turn on ones digit
            2'b01 : AN = 4'b1101;   // Turn on tens digit
            2'b10 : AN = 4'b1011;   // Turn on hundreds digit
            2'b11 : AN = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    always @*
        case(anode_select)
            2'b00 : begin 				
								case(ones)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                        endcase
                    end
                        
            2'b01 : begin 
								case(tens)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                        endcase
                    end
				
                    
            2'b10 : begin       
                        case(hundreds)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                        endcase
                    end
                    
            2'b11 : begin      
                        case(thousands)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                        endcase
                    end
        endcase  
endmodule