`timescale 1ns / 1ps

module display(
input switchReset,
input clk,
input hitFPGA,
input joy,
input vauxp6,
input vauxn6,
input vauxp7,
input vauxn7,
input vauxp15,
input vauxn15,
input vauxp14,
input vauxn14,
input diagFlag,
input downB,
input leftB,
input upB,
input rightB,
input hitPB,
output [3:0] an,
output dp,
output [6:0] seg,
output h_sync,
output v_sync,
output [3:0] red,
output [3:0] green,
output [3:0] blue,
// output led1,
output diagLED,
output joyLED
//,output coll1,
//output coll2,
//output coll3,
//output mov

// the following ports are only for debugging through simulation - comment/uncomment as per use. if uncommented, please ensure that the respective wire declarations are uncommented in the module
// also, for uncommented ports, make sure to pass them in testbench
//,output [9:0] x_loc,
//output [9:0] y_loc
//output signed [10:0] w_ball_x,
//output signed [10:0] w_ball_y
//output [4:0] cue_red,
//output [4:0] cue_green,
//output [4:0] cue_blue,
//,output [10:0] x_f,
//output [10:0] y_f,
//output [4:0] v_x,
//output [4:0] v_y
//,output reg [10:0] x_i,
//output reg [10:0] y_i,
//output reg [4:0] u_x,
//output  reg [4:0] u_y
//,output v_sync_d
);

wire hit;
assign hit = hitFPGA | hitPB;

wire clk_d; 
wire [9:0] h_count;
wire v_trig; 
wire [9:0] v_count;
wire video_on;

// screen management
reg [1:0] state;
reg buttonFlag;
reg resetFlag;
reg resetDone;
reg overFlag;
reg [2:0] score;

initial
begin
    state = 0;
    buttonFlag = 0;
    resetFlag = 0;
    resetDone = 0;
    overFlag = 0;
    score = 0;
end

//wire v_sync_d;
wire [10:0] x_f;
wire [10:0] y_f;
//wire [4:0] v_x;
//wire [4:0] v_y;

// wires for red ball
wire [10:0] rx_f;
wire [10:0] ry_f;

// wires for blue ball
wire [10:0] bx_f;
wire [10:0] by_f;

// wires for green ball
wire [10:0] gx_f;
wire [10:0] gy_f;

// wires for yellow ball
wire [10:0] yx_f;
wire [10:0] yy_f;

// wires for magenta ball
wire [10:0] mx_f;
wire [10:0] my_f;

// wires for cyan ball
wire [10:0] cx_f;
wire [10:0] cy_f;


// final velocity for all balls
wire [4:0] v_xf;
wire [4:0] v_yf;

wire [4:0] rv_xf;
wire [4:0] rv_yf;

wire [4:0] bv_xf;
wire [4:0] bv_yf;

wire [4:0] gv_xf;
wire [4:0] gv_yf;

wire [4:0] yv_xf;
wire [4:0] yv_yf;

wire [4:0] mv_xf;
wire [4:0] mv_yf;

wire [4:0] cv_xf;
wire [4:0] cv_yf;

// tmp velocity for all balls
wire [4:0] v_xt;
wire [4:0] v_yt;

wire [4:0] rv_xt;
wire [4:0] rv_yt;

wire [4:0] bv_xt;
wire [4:0] bv_yt;

wire [4:0] gv_xt;
wire [4:0] gv_yt;

wire [4:0] yv_xt;
wire [4:0] yv_yt;

wire [4:0] mv_xt;
wire [4:0] mv_yt;

wire [4:0] cv_xt;
wire [4:0] cv_yt;

wire [9:0] x_loc; // comment when simulating
wire [9:0] y_loc;

// should come as input
reg [10:0] x_i; // comment when simulating
reg [10:0] y_i;
reg [4:0] u_x;
reg [4:0] u_y;

reg [10:0] rx_i; // putting red ball 
reg [10:0] ry_i;
reg [4:0] ru_x;
reg [4:0] ru_y;

reg [10:0] bx_i; // putting blue ball 
reg [10:0] by_i;
reg [4:0] bu_x;
reg [4:0] bu_y;

reg [10:0] gx_i; // putting green ball 
reg [10:0] gy_i;
reg [4:0] gu_x;
reg [4:0] gu_y;

reg [10:0] yx_i; // putting yellow ball 
reg [10:0] yy_i;
reg [4:0] yu_x;
reg [4:0] yu_y;

reg [10:0] mx_i; // putting magenta ball 
reg [10:0] my_i;
reg [4:0] mu_x;
reg [4:0] mu_y;

reg [10:0] cx_i; // putting cyan ball 
reg [10:0] cy_i;
reg [4:0] cu_x;
reg [4:0] cu_y;

//reg [4:0] u_x;
//reg [4:0] u_y;
//reg [10:0] x_f; // idk
//reg [10:0] y_f;

//wire [10:0] w_ball_x; // idk, i think useless
//wire [10:0] w_ball_y;

wire cue_on; // enable cue
reg [2:0] rot; // cue rotation state - only even (0, 2, 4, 6) implemented so far
        
// corner hole position registers
reg [9:0] top_left_x;
reg [9:0] top_left_y;

reg [9:0] bottom_left_x;
reg [9:0] bottom_left_y;

reg [9:0] top_middle_x;
reg [9:0] top_middle_y;

reg [9:0] bottom_middle_x;
reg  [9:0] bottom_middle_y;

reg [9:0] top_right_x;
reg [9:0] top_right_y;

reg [9:0] bottom_right_x;
reg [9:0] bottom_right_y;

reg [9:0] score_x;
initial
    score_x=0;
    
    
// initialise ball position + cue_state. Place corner holes
initial
begin
        score = 0;
        // cue initial rotation
        rot = 0;
        
        // white ball initial position and velocity
        x_i = 150;
        y_i = 240;
        u_x = 0;
        u_y = 0;
        
        // red ball initial position and velocity
        rx_i = 400;
        ry_i = 240;
        ru_x = 0;
        ru_y = 0;
        
        // blue ball initial position and velocity
        bx_i = 435;
        by_i = 258;
        bu_x = 0;
        bu_y = 0;
        
        // green ball initial position and velocity
        gx_i = 435;
        gy_i = 222;
        gu_x = 0;
        gu_y = 0;
        
        // yellow ball initial position and velocity
        yx_i = 470;
        yy_i = 205;
        yu_x = 0;
        yu_y = 0;
        
        // magenta ball initial position and velocity
        mx_i = 470;
        my_i = 240;
        mu_x = 0;
        mu_y = 0;    
        
        // cyan ball initial position and velocity
        cx_i = 470;
        cy_i = 275;
        cu_x = 0;
        cu_y = 0;
        
    //    cue_on = 1;
    
        
    //    x_f = 70; // for testing if a hardcoded ball will appear, remove the respective wires
    //    y_f = 90;
        
        top_left_x = 54;
        top_left_y = 74;
        bottom_left_x = 54;
        bottom_left_y = 405;
        
        top_middle_x = 320;
        top_middle_y = 74;
        bottom_middle_x = 320;
        bottom_middle_y = 405;
        
        
        top_right_x = 585;
        top_right_y = 74;
        bottom_right_x = 585;
        bottom_right_y = 405;  
end

reg [10:0] div;
initial
    div = 0;
    
wire down, left, up, right, upright, upleft, downright, downleft;

XADCdemo x1 (clk,
   vauxp6,
   vauxn6,
   vauxp7,
   vauxn7,
   vauxp15,
   vauxn15,
   vauxp14,
   vauxn14,
//   output reg [15:0] LED,
   an,
   dp,
   seg,
   right,
   up, 
   left,
   down,  
   upright,
   downright,
   upleft,
   downleft
);

reg [3:0] beststrokes0;
reg [3:0] beststrokes1;

reg [3:0] strokes0;
reg [3:0] strokes1;

always @(posedge clk)
begin
    if (resetDone)
        resetFlag = 0;
    if (switchReset)
    begin
        state = 0;
        resetFlag = 1;
    end
    else if (score == 6 && state == 1)
    begin
        if (10*strokes1 + strokes0 < 10*beststrokes1 + beststrokes0)
        begin
            beststrokes0 = strokes0;
            beststrokes1 = strokes1;
        end
        state = 2;
    end
    else if (state == 1 && overFlag)
        state = 3;
    else if (hit)
        buttonFlag = 1;
    if (~hit)
    begin
        if (buttonFlag && (state == 0 || state == 2  || state == 3))
        begin
            resetFlag = 1;
            state = 1;
        end
        buttonFlag = 0;
    end
end

// rotate cue
always @(posedge v_sync)
        if (resetFlag)
            rot <= 0;
        else if ((joy & down) | (downB & ~diagFlag))
            rot <= 0;
        else if ((joy & downleft) | (downB & diagFlag)) 
            rot <= 1;
        else if ((joy & left) | (leftB & ~diagFlag))
            rot <= 2;
        else if ((joy & upleft) | (leftB & diagFlag)) 
            rot <= 3;
        else if ((joy & up) | (upB & ~diagFlag))
            rot <= 4;
        else if ((joy & upright) | (upB & diagFlag)) 
            rot <= 5;
        else if ((joy & right) | (rightB & ~diagFlag))
            rot <= 6;
        else if ((joy & downright) | (rightB & diagFlag)) 
            rot <= 7;

reg flag;

reg [1:0] collisionFlag;

reg cue_on_prev;

initial
begin
    strokes0 = 0;
    strokes1 = 0;
    beststrokes0 = 9;
    beststrokes1 = 9;
    cue_on_prev = 1;
end

//always @(negedge cue_on)
//begin
//    if (state == 1)
//        if (strokes0 < 9)
//            strokes0 = strokes0 + 1;
//        else if (strokes1 < 9)
//            strokes1 = strokes1 + 1;
//    else
//    begin
//        strokes0 = 4;
//        strokes1 = 2;
//    end
//end

//always @(posedge clk)
//begin
//    if (resetFlag)
//    begin
//        cue_on_prev <= 1;
//        strokes0 <= 4;
//        strokes1 <= 4;
//    end
//    else
//    if (cue_on != cue_on_prev)
//        begin
//        cue_on_prev = cue_on;
//        if (~cue_on_prev)
//             if (strokes0 < 9)
//                 strokes0 = strokes0 + 1;
//             else if (strokes1 < 9)
//             begin
//                 strokes1 = strokes1 + 1;
//                 strokes0 = 0;
//             end
//        end
//end

initial 
begin
    collisionFlag = 0;
    flag = 0;
end
    
always @(negedge v_sync)
    if (flag == 0)
        flag = 1;
    
always @(posedge clk)
    if (flag)
    begin
        if (~v_sync)
            collisionFlag <= 0;
        else
        if (collisionFlag < 2)
            collisionFlag <= collisionFlag + 1;
    end
        
wire [1:0] moverFlag;


always @(posedge moverFlag[1])
begin
    resetDone = 0;
    if (resetFlag)
    begin
        overFlag <= 0;
        score <= 0;
        score_x <= 0;
        strokes0 <= 0;
        strokes1 <= 0;
        cue_on_prev <= 1;
        // cue initial rotation
//        rot = 0;
        
        // white ball initial position and velocity
        x_i = 150;
        y_i = 240;
        u_x = 0;
        u_y = 0;
        
        // red ball initial position and velocity
        rx_i = 400;
        ry_i = 240;
        ru_x = 0;
        ru_y = 0;
        
        // blue ball initial position and velocity
        bx_i = 435;
        by_i = 258;
        bu_x = 0;
        bu_y = 0;
        
        // green ball initial position and velocity
        gx_i = 435;
        gy_i = 222;
        gu_x = 0;
        gu_y = 0;
        
        // yellow ball initial position and velocity
        yx_i = 470;
        yy_i = 205;
        yu_x = 0;
        yu_y = 0;
        
        // magenta ball initial position and velocity
        mx_i = 470;
        my_i = 240;
        mu_x = 0;
        mu_y = 0;    
        
        // cyan ball initial position and velocity
        cx_i = 470;
        cy_i = 275;
        cu_x = 0;
        cu_y = 0;
        resetDone = 1;
    end
    else
    begin
        if (cue_on != cue_on_prev)
        begin
            cue_on_prev = cue_on;
            if (~cue_on_prev)
                if (strokes0 < 9)
                    strokes0 = strokes0 + 1;
                else if (strokes1 < 9)
                begin
                    strokes1 = strokes1 + 1;
                    strokes0 = 0;
                end
        end
            
//        if (flag == 0) 
//            flag = 1;
//        else 
//        begin
            // update white ball  
            // x_i <= x_f; 
            // y_i <= y_f;
            // u_x <= v_xf;  
            // u_y <= v_yf;
            
            // update white ball 
            if (~((x_f >= (top_left_x - 14) & x_f <= (top_left_x + 14) & ry_f >= (top_left_y - 14) & y_f <= (top_left_y + 14)) | (x_f  >= (top_right_x - 14) & x_f  <= (top_right_x + 14) & y_f >= (top_right_y - 14) & y_f <= (top_right_y + 14)) | (x_f >= (top_middle_x - 14) & x_f <= (top_middle_x + 14) & y_f >= (top_middle_y - 14) & y_f <= (top_middle_y + 14)) | (x_f >= (bottom_right_x - 14) & x_f <= (bottom_right_x + 14) & y_f >= (bottom_right_y - 14) & y_f <= (bottom_right_y + 14)) | (x_f >= (bottom_middle_x - 14) & x_f  <= (bottom_middle_x + 14) & y_f  >= (bottom_middle_y - 14) & y_f  <= (bottom_middle_y + 14)) | (x_f  >= (top_right_x - 14) & x_f  <= (top_right_x + 14) & y_f  >= (top_right_y - 14) & y_f <= (top_right_y + 14)) | (x_f  >= (bottom_left_x - 14) & x_f  <= (bottom_left_x + 14) & y_f >= (bottom_left_y - 14) & y_f <= (bottom_left_y + 14))))                             
                begin   
                    x_i <= x_f; 
                    y_i <= y_f;
                    u_x <= v_xf;  
                    u_y <= v_yf;
                end
            else
                begin
                    overFlag = 1;
//                    score = score + 1;
//                    score_x = score_x+35;    
//                    rx_i <= score_x; 
//                    ry_i <= 460;
//                    ru_x <= 0;  
//                    ru_y <= 0;
                end
            
            
            
            // update red ball 
            if (~((rx_f >= (top_left_x - 14) & rx_f <= (top_left_x + 14) & ry_f >= (top_left_y - 14) & ry_f <= (top_left_y + 14)) | (rx_f  >= (top_right_x - 14) & rx_f  <= (top_right_x + 14) & ry_f >= (top_right_y - 14) & ry_f <= (top_right_y + 14)) | (rx_f >= (top_middle_x - 14) & rx_f <= (top_middle_x + 14) & ry_f >= (top_middle_y - 14) & ry_f <= (top_middle_y + 14)) | (rx_f >= (bottom_right_x - 14) & rx_f <= (bottom_right_x + 14) & ry_f >= (bottom_right_y - 14) & ry_f <= (bottom_right_y + 14)) | (rx_f >= (bottom_middle_x - 14) & rx_f  <= (bottom_middle_x + 14) & ry_f  >= (bottom_middle_y - 14) & ry_f  <= (bottom_middle_y + 14)) | (rx_f  >= (top_right_x - 14) & rx_f  <= (top_right_x + 14) & ry_f  >= (top_right_y - 14) & ry_f <= (top_right_y + 14)) | (rx_f  >= (bottom_left_x - 14) & rx_f  <= (bottom_left_x + 14) & ry_f >= (bottom_left_y - 14) & ry_f <= (bottom_left_y + 14))))                             
                begin   
                    rx_i <= rx_f; 
                    ry_i <= ry_f;
                    ru_x <= rv_xf;  
                    ru_y <= rv_yf;
                end
            else
                begin
                    score = score + 1;
                    score_x = score_x+35;    
                    rx_i <= score_x; 
                    ry_i <= 460;
                    ru_x <= 0;  
                    ru_y <= 0;
                end
            
            // update blue ball
            if (~((bx_f >= (top_left_x - 14) & bx_f <= (top_left_x + 14) & by_f >= (top_left_y - 14) & by_f <= (top_left_y + 14)) | (bx_f  >= (top_right_x - 14) & bx_f  <= (top_right_x + 14) & by_f >= (top_right_y - 14) & by_f <= (top_right_y + 14)) | (bx_f >= (top_middle_x - 14) & bx_f <= (top_middle_x + 14) & by_f >= (top_middle_y - 14) & by_f <= (top_middle_y + 14)) | (bx_f >= (bottom_right_x - 14) & bx_f <= (bottom_right_x + 14) & by_f >= (bottom_right_y - 14) & by_f <= (bottom_right_y + 14)) | (bx_f >= (bottom_middle_x - 14) & bx_f  <= (bottom_middle_x + 14) & by_f  >= (bottom_middle_y - 14) & by_f  <= (bottom_middle_y + 14)) | (bx_f  >= (top_right_x - 14) & bx_f  <= (top_right_x + 14) & by_f  >= (top_right_y - 14) & by_f <= (top_right_y + 14)) | (bx_f  >= (bottom_left_x - 14) & bx_f  <= (bottom_left_x + 14) & by_f >= (bottom_left_y - 14) & by_f <= (bottom_left_y + 14))))                             
                begin   
                    bx_i <= bx_f; 
                    by_i <= by_f;
                    bu_x <= bv_xf;  
                    bu_y <= bv_yf; 
                end
            else
                begin
                    score = score + 1;
                    score_x=score_x+35;    
                    bx_i <= score_x; 
                    by_i <= 460;
                    bu_x <= 0;  
                    bu_y <= 0;
                end            
            
            
            // update green ball
            if (~((gx_f >= (top_left_x - 14) & gx_f <= (top_left_x + 14) & gy_f >= (top_left_y - 14) & gy_f <= (top_left_y + 14)) | (gx_f  >= (top_right_x - 14) & gx_f  <= (top_right_x + 14) & gy_f >= (top_right_y - 14) & gy_f <= (top_right_y + 14)) | (gx_f >= (top_middle_x - 14) & gx_f <= (top_middle_x + 14) & gy_f >= (top_middle_y - 14) & gy_f <= (top_middle_y + 14)) | (gx_f >= (bottom_right_x - 14) & gx_f <= (bottom_right_x + 14) & gy_f >= (bottom_right_y - 14) & gy_f <= (bottom_right_y + 14)) | (gx_f >= (bottom_middle_x - 14) & gx_f  <= (bottom_middle_x + 14) & gy_f  >= (bottom_middle_y - 14) & gy_f  <= (bottom_middle_y + 14)) | (gx_f  >= (top_right_x - 14) & gx_f  <= (top_right_x + 14) & gy_f  >= (top_right_y - 14) & gy_f <= (top_right_y + 14)) | (gx_f  >= (bottom_left_x - 14) & gx_f  <= (bottom_left_x + 14) & gy_f >= (bottom_left_y - 14) & gy_f <= (bottom_left_y + 14))))                             
                begin   
                    gx_i <= gx_f; 
                    gy_i <= gy_f;
                    gu_x <= gv_xf;  
                    gu_y <= gv_yf;
                end
            else
                begin
                    score = score + 1;
                    score_x = score_x+35;    
                    gx_i <= score_x; 
                    gy_i <= 460;
                    gu_x <= 0;  
                    gu_y <= 0;
                end
            
            
            // update yellow ball
            if (~((yx_f >= (top_left_x - 14) & yx_f <= (top_left_x + 14) & yy_f >= (top_left_y - 14) & yy_f <= (top_left_y + 14)) | (yx_f  >= (top_right_x - 14) & yx_f  <= (top_right_x + 14) & yy_f >= (top_right_y - 14) & yy_f <= (top_right_y + 14)) | (yx_f >= (top_middle_x - 14) & yx_f <= (top_middle_x + 14) & yy_f >= (top_middle_y - 14) & yy_f <= (top_middle_y + 14)) | (yx_f >= (bottom_right_x - 14) & yx_f <= (bottom_right_x + 14) & yy_f >= (bottom_right_y - 14) & yy_f <= (bottom_right_y + 14)) | (yx_f >= (bottom_middle_x - 14) & yx_f  <= (bottom_middle_x + 14) & yy_f  >= (bottom_middle_y - 14) & yy_f  <= (bottom_middle_y + 14)) | (yx_f  >= (top_right_x - 14) & yx_f  <= (top_right_x + 14) & yy_f  >= (top_right_y - 14) & yy_f <= (top_right_y + 14)) | (yx_f  >= (bottom_left_x - 14) & yx_f  <= (bottom_left_x + 14) & yy_f >= (bottom_left_y - 14) & yy_f <= (bottom_left_y + 14))))                             
                begin   
                    yx_i <= yx_f; 
                    yy_i <= yy_f;
                    yu_x <= yv_xf;  
                    yu_y <= yv_yf; 
                end
            else
                begin
                    score = score + 1;
                    score_x = score_x+35;    
                    yx_i <= score_x; 
                    yy_i <= 460;
                    yu_x <= 0;  
                    yu_y <= 0;
                end          
            
            
            // update magenta ball
            if (~((mx_f >= (top_left_x - 14) & mx_f <= (top_left_x + 14) & my_f >= (top_left_y - 14) & my_f <= (top_left_y + 14)) | (mx_f  >= (top_right_x - 14) & mx_f  <= (top_right_x + 14) & my_f >= (top_right_y - 14) & my_f <= (top_right_y + 14)) | (mx_f >= (top_middle_x - 14) & mx_f <= (top_middle_x + 14) & my_f >= (top_middle_y - 14) & my_f <= (top_middle_y + 14)) | (mx_f >= (bottom_right_x - 14) & mx_f <= (bottom_right_x + 14) & my_f >= (bottom_right_y - 14) & my_f <= (bottom_right_y + 14)) | (mx_f >= (bottom_middle_x - 14) & mx_f  <= (bottom_middle_x + 14) & my_f  >= (bottom_middle_y - 14) & my_f  <= (bottom_middle_y + 14)) | (mx_f  >= (top_right_x - 14) & mx_f  <= (top_right_x + 14) & my_f  >= (top_right_y - 14) & my_f <= (top_right_y + 14)) | (mx_f  >= (bottom_left_x - 14) & mx_f  <= (bottom_left_x + 14) & my_f >= (bottom_left_y - 14) & my_f <= (bottom_left_y + 14))))                             
                begin   
                    mx_i <= mx_f; 
                    my_i <= my_f;
                    mu_x <= mv_xf;  
                    mu_y <= mv_yf; 
                end
            else
                begin
                    score = score + 1;
                    score_x = score_x+35;    
                    mx_i <= score_x; 
                    my_i <= 460;
                    mu_x <= 0;  
                    mu_y <= 0;
                end
            
            // update cyan ball
            if (~((cx_f >= (top_left_x - 14) & cx_f <= (top_left_x + 14) & cy_f >= (top_left_y - 14) & cy_f <= (top_left_y + 14)) | (cx_f  >= (top_right_x - 14) & cx_f  <= (top_right_x + 14) & cy_f >= (top_right_y - 14) & cy_f <= (top_right_y + 14)) | (cx_f >= (top_middle_x - 14) & cx_f <= (top_middle_x + 14) & cy_f >= (top_middle_y - 14) & cy_f <= (top_middle_y + 14)) | (cx_f >= (bottom_right_x - 14) & cx_f <= (bottom_right_x + 14) & cy_f >= (bottom_right_y - 14) & cy_f <= (bottom_right_y + 14)) | (cx_f >= (bottom_middle_x - 14) & cx_f  <= (bottom_middle_x + 14) & cy_f  >= (bottom_middle_y - 14) & cy_f  <= (bottom_middle_y + 14)) | (cx_f  >= (top_right_x - 14) & cx_f  <= (top_right_x + 14) & cy_f  >= (top_right_y - 14) & cy_f <= (top_right_y + 14)) | (cx_f  >= (bottom_left_x - 14) & cx_f  <= (bottom_left_x + 14) & cy_f >= (bottom_left_y - 14) & cy_f <= (bottom_left_y + 14))))                             
                begin   
                    cx_i <= cx_f; 
                    cy_i <= cy_f;
                    cu_x <= cv_xf;  
                    cu_y <= cv_yf;
                end
            else
                begin
                    score = score + 1;
                    score_x = score_x+35;    
                    cx_i <= score_x; 
                    cy_i <= 460;
                    cu_x <= 0;  
                    cu_y <= 0;
                end
        end
  end
// **TESTBENCH ENDS**//

wire [6:0] strength;
//wire [6:0] strengthR;
//wire [6:0] strengthB;
//wire cue_on_fakeR;
//wire cue_on_fakeB;
reg hit_fake;
initial
    hit_fake = 0;
//wire hit_fake;

//assign hit_fake=0;

// Module Connections
clk_div u1 (clk, clk_d);
h_counter u2 (clk_d, h_count, v_trig);
v_counter u3 (clk_d, v_trig, v_count);
vga_sync u4 (h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
//v_sync_div vd1 (v_sync, v_sync_d);
//allMover(v_sync,

//wire [1:0] collision2;
//wire [1:0] collision3;
//wire [1:0] collision4;
//wire [1:0] collision5;
//wire [1:0] collision6;

//assign coll1 = collisionFlag[1];
//assign coll2 = collision2[1];
//assign coll3 = collision3[1];
//assign mov = moverFlag[1];

assign joyLED = joy;
assign diagLED = diagFlag;

allMover MV (v_sync, state, hit, rot,
x_i, y_i, u_x, u_y,
rx_i, ry_i, ru_x, ru_y,
bx_i, by_i, bu_x, bu_y,
gx_i, gy_i, gu_x, gu_y,
yx_i, yy_i, yu_x, yu_y,
mx_i, my_i, mu_x, mu_y,
cx_i, cy_i, cu_x, cu_y,

x_f, y_f, v_xt, v_yt,
rx_f, ry_f, rv_xt, rv_yt,
bx_f, by_f, bv_xt, bv_yt,
gx_f, gy_f, gv_xt, gv_yt,
yx_f, yy_f, yv_xt, yv_yt,
mx_f, my_f, mv_xt, mv_yt,
cx_f, cy_f, cv_xt, cv_yt,

strength, cue_on
    );
 

//wire [4:0] v_xt1; wire [4:0] v_yt1;
//wire [4:0] rv_xt1; wire [4:0] rv_yt1;
//wire [4:0] bv_xt1; wire [4:0] bv_yt1;

//collisionResolver cr_wr(clk, collisionFlag[1], x_f, y_f, v_xt, v_yt, rx_f, ry_f, rv_xt, rv_yt, v_xt1, v_yt1, rv_xt1, rv_yt1, collision2);
//collisionResolver cr_wb(clk, collision2[1], x_f, y_f, v_xt1, v_yt1, bx_f, by_f, bv_xt, bv_yt, v_xf, v_yf, bv_xt1, bv_yt1, collision3);
//collisionResolver cr_rb(clk, collision3[1], rx_f, ry_f, rv_xt1, rv_yt1, bx_f, by_f, bv_xt1, bv_yt1, rv_xf, rv_yf, bv_xf, bv_yf, moverFlag);
//three more collision resolvers for green 
//collisionResolver cr_wg(clk, collision4[1], x_f, y_f, v_xt, v_yt, gx_f, gy_f, gv_xt, gv_yt, v_xt1, v_yt1, gv_xt1, gv_yt1, collision5);
//collisionResolver cr_gb(clk, collision5[1], gx_f, gy_f, gv_xt1, gv_yt1, bx_f, by_f, bv_xt, bv_yt, gv_xf, gv_yf, bv_xt1, bv_yt1, collision6);
//collisionResolver cr_rg(clk, collision6[1], rx_f, ry_f, rv_xt1, rv_yt1, gx_f, gy_f, gv_xt1, gv_yt1, rv_xf, rv_yf, gv_xf, gv_yf, moverFlag);

    
allCollider CR (clk, cue_on, collisionFlag,

x_f, y_f, v_xt, v_yt, 
rx_f, ry_f, rv_xt, rv_yt, 
bx_f, by_f, bv_xt, bv_yt, 
gx_f, gy_f, gv_xt, gv_yt, 
yx_f, yy_f, yv_xt, yv_yt, 
mx_f, my_f, mv_xt, mv_yt, 
cx_f, cy_f, cv_xt, cv_yt, 

v_xf, v_yf, 
rv_xf, rv_yf,
bv_xf, bv_yf,
gv_xf, gv_yf,
yv_xf, yv_yf,
mv_xf, mv_yf,
cv_xf, cv_yf,

moverFlag
    );

wire [4:0] redMenu, greenMenu, blueMenu;
wire [4:0] redOver, greenOver, blueOver;
wire [4:0] redWin, greenWin, blueWin;

pix_gen_menu MENU (clk_d, x_loc, y_loc, video_on,
redMenu, greenMenu, blueMenu);

pix_gen_game_over OVER (clk_d, x_loc, y_loc, video_on,
redOver, greenOver, blueOver);

pix_gen_win WIN (clk_d, x_loc, y_loc, video_on,
redWin, greenWin, blueWin);

wire [4:0] redGame, greenGame, blueGame;

pix_gen_pool_2 u5 (clk_d, x_loc, y_loc,
    cue_on, 
    strokes0, strokes1, beststrokes0, beststrokes1,
    rot, strength[6:3],
//    x_f, y_f, 
    x_i, y_i, 
    rx_i, ry_i,
    bx_i, by_i,
    gx_i, gy_i,
    yx_i, yy_i,
    mx_i, my_i,
    cx_i, cy_i,
    
    top_left_x, top_left_y,
    bottom_left_x, bottom_left_y,
    top_middle_x, top_middle_y,
    bottom_middle_x, bottom_middle_y,
    top_right_x, top_right_y,
    bottom_right_x, bottom_right_y,
    video_on, redGame, greenGame, blueGame
//    ,cue_red, cue_green, cue_blue - enable if desired for simulation output
    ); 
    

assign red = (state == 0) ? redMenu : (state == 1) ? redGame : (state == 2) ? redWin : (state == 3) ? redOver : 12'h0;
assign green = (state == 0) ? greenMenu : (state == 1) ? greenGame : (state == 2) ? greenWin : (state == 3) ? greenOver : 12'h0;
assign blue = (state == 0) ? blueMenu : (state == 1) ? blueGame : (state == 2) ? blueWin : (state == 3) ? blueOver : 12'h0;
    
endmodule
