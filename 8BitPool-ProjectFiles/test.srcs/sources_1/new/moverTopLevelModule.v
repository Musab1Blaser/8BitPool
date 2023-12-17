`timescale 1ns / 1ps

module moverTopLevelModule(
    input v_sync,
    input signed[10:0] x_i,
    input signed [10:0] y_i,
    input signed[4:0] u_x,
    input signed [4:0] u_y,
    output signed[10:0] x_f,
    output signed[10:0] y_f
//    ,output signed [4:0] v_x,
//    output signed [4:0] v_y
//    output reg [9:0] x_t,
//    output reg [9:0] y_t,
//    output reg signed [4:0] t_x,
//    output reg signed [4:0] t_y
    );
    
    reg flag;
    
    wire signed [4:0] v_x;
    wire signed [4:0] v_y;

    reg signed[10:0] x_t;
    reg signed[10:0] y_t;
    reg signed [4:0] t_x;
    reg signed [4:0] t_y;

    always @(negedge v_sync)
    begin
        #1 // if i don't have this delay, these will get assigned simultaneously with all of RHS in my testbench, which gives them undefined values
        x_t = x_i;
        y_t = y_i;
        t_x = u_x;
        t_y = u_y;
    end

    moverModule v1 (v_sync, x_t, y_t, t_x, t_y, x_f, y_f, v_x, v_y);
        
    always @(negedge v_sync) 
    begin
        x_t <= x_f; 
        y_t <= y_f;
        t_x <= v_x;  
        t_y <= v_y;
    end
    
endmodule
