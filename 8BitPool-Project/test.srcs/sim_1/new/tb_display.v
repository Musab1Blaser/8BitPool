`timescale 1ns / 1ps

module tb_display();
reg clk, hit, joy, vauxp6, vauxn6, vauxp7, vauxn7, vauxp15, vauxn15, vauxp14, vauxn14, diagFlag, downB, leftB, upB, rightB;
wire [3:0] an;
wire dp;
wire [6:0] seg;
wire h_sync;
wire v_sync;
wire [3:0] red;
wire [3:0] green;
wire [3:0] blue;
wire diagLED, joyLED;
display d1(
clk,
hit,
joy,
vauxp6,
vauxn6,
vauxp7,
vauxn7,
vauxp15,
vauxn15,
vauxp14,
vauxn14,
diagFlag,
downB,
leftB,
upB,
rightB,
an,
dp,
seg,
h_sync,
v_sync,
red,
green,
blue,
// output led1,
diagLED,
joyLED);

reg [5:0] count;

initial 
begin
    clk <= 0;
    hit <= 0;
    joy <= 0;
    vauxp6 <= 0;
    vauxn6 <= 0;
    vauxp7 <= 0;
    vauxn7 <= 0;
    vauxp15 <= 0;
    vauxn15 <= 0;
    vauxp14 <= 0;
    vauxn14 <= 0;
    diagFlag <= 0;
    downB <= 0;
    leftB <= 0;
    upB <= 0;
    rightB <= 0;
    
//    #50 hit <= 1;
//    count <= 0;
end
   
//always @(negedge v_sync)
//    if (count < 30)
//        count = count + 1;
//    else
//        hit = 0;

always
    #5 clk <= ~clk;


endmodule
