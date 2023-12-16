`timescale 1ns / 1ps

module allCollider (input clk, input cue_on, input [1:0] collisionFlag,

input [10:0] x_f, input [10:0] y_f, input [4:0] v_xt, input [4:0] v_yt, 
input [10:0] rx_f, input [10:0] ry_f, input [4:0] rv_xt, input [4:0] rv_yt, 
input [10:0] bx_f, input [10:0] by_f, input [4:0] bv_xt, input [4:0] bv_yt, 
input [10:0] gx_f, input [10:0] gy_f, input [4:0] gv_xt, input [4:0] gv_yt, 
input [10:0] yx_f, input [10:0] yy_f, input [4:0] yv_xt, input [4:0] yv_yt, 
input [10:0] mx_f, input [10:0] my_f, input [4:0] mv_xt, input [4:0] mv_yt, 
input [10:0] cx_f, input [10:0] cy_f, input [4:0] cv_xt, input [4:0] cv_yt, 

output [4:0] v_xf, output [4:0] v_yf, 
output [4:0] rv_xf, output [4:0] rv_yf,
output [4:0] bv_xf, output [4:0] bv_yf,
output [4:0] gv_xf, output [4:0] gv_yf,
output [4:0] yv_xf, output [4:0] yv_yf,
output [4:0] mv_xf, output [4:0] mv_yf,
output [4:0] cv_xf, output [4:0] cv_yf,

output [1:0] moverFlag
    );
    
wire [1:0] collision2;
wire [1:0] collision3;
wire [1:0] collision4;
wire [1:0] collision5;
wire [1:0] collision6;
wire [1:0] collision7;
wire [1:0] collision8;
wire [1:0] collision9;
wire [1:0] collision10;
wire [1:0] collision11;
wire [1:0] collision12;
wire [1:0] collision13;
wire [1:0] collision14;
wire [1:0] collision15;
wire [1:0] collision16;
wire [1:0] collision17;
wire [1:0] collision18;
wire [1:0] collision19;
wire [1:0] collision20;
wire [1:0] collision21;


wire [4:0] v_xt1; 
wire [4:0] v_yt1;
wire [4:0] v_xt2; 
wire [4:0] v_yt2;
wire [4:0] v_xt3; 
wire [4:0] v_yt3;
wire [4:0] v_xt4; 
wire [4:0] v_yt4;
wire [4:0] v_xt5; 
wire [4:0] v_yt5;

wire [4:0] rv_xt1; 
wire [4:0] rv_yt1;
wire [4:0] rv_xt2; 
wire [4:0] rv_yt2;
wire [4:0] rv_xt3; 
wire [4:0] rv_yt3;
wire [4:0] rv_xt4; 
wire [4:0] rv_yt4;
wire [4:0] rv_xt5; 
wire [4:0] rv_yt5;

wire [4:0] bv_xt1; 
wire [4:0] bv_yt1;
wire [4:0] bv_xt2; 
wire [4:0] bv_yt2;
wire [4:0] bv_xt3; 
wire [4:0] bv_yt3;
wire [4:0] bv_xt4; 
wire [4:0] bv_yt4;
wire [4:0] bv_xt5; 
wire [4:0] bv_yt5;

wire [4:0] gv_xt1; 
wire [4:0] gv_yt1;
wire [4:0] gv_xt2; 
wire [4:0] gv_yt2;
wire [4:0] gv_xt3; 
wire [4:0] gv_yt3;
wire [4:0] gv_xt4; 
wire [4:0] gv_yt4;
wire [4:0] gv_xt5; 
wire [4:0] gv_yt5;

wire [4:0] yv_xt1; 
wire [4:0] yv_yt1;
wire [4:0] yv_xt2; 
wire [4:0] yv_yt2;
wire [4:0] yv_xt3; 
wire [4:0] yv_yt3;
wire [4:0] yv_xt4; 
wire [4:0] yv_yt4;
wire [4:0] yv_xt5; 
wire [4:0] yv_yt5;

wire [4:0] mv_xt1; 
wire [4:0] mv_yt1;
wire [4:0] mv_xt2; 
wire [4:0] mv_yt2;
wire [4:0] mv_xt3; 
wire [4:0] mv_yt3;
wire [4:0] mv_xt4; 
wire [4:0] mv_yt4;
wire [4:0] mv_xt5; 
wire [4:0] mv_yt5;

wire [4:0] cv_xt1; 
wire [4:0] cv_yt1;
wire [4:0] cv_xt2; 
wire [4:0] cv_yt2;
wire [4:0] cv_xt3; 
wire [4:0] cv_yt3;
wire [4:0] cv_xt4; 
wire [4:0] cv_yt4;
wire [4:0] cv_xt5; 
wire [4:0] cv_yt5;

//wire [4:0] gv_xt1; 
//wire [4:0] gv_yt1;

collisionResolver cr_wr(clk, cue_on, collisionFlag[1], x_f, y_f, v_xt, v_yt, rx_f, ry_f, rv_xt, rv_yt, v_xt1, v_yt1, rv_xt1, rv_yt1, collision2);
collisionResolver cr_wb(clk, cue_on, collision2[1], x_f, y_f, v_xt1, v_yt1, bx_f, by_f, bv_xt, bv_yt, v_xt2, v_yt2, bv_xt1, bv_yt1, collision3);
collisionResolver cr_wg(clk, cue_on, collision3[1], x_f, y_f, v_xt2, v_yt2, gx_f, gy_f, gv_xt, gv_yt, v_xt3, v_yt3, gv_xt1, gv_yt1, collision4);
collisionResolver cr_wy(clk, cue_on, collision4[1], x_f, y_f, v_xt3, v_yt3, yx_f, yy_f, yv_xt, yv_yt, v_xt4, v_yt4, yv_xt1, yv_yt1, collision5);
collisionResolver cr_wm(clk, cue_on, collision5[1], x_f, y_f, v_xt4, v_yt4, mx_f, my_f, mv_xt, mv_yt, v_xt5, v_yt5, mv_xt1, mv_yt1, collision6);
collisionResolver cr_wc(clk, cue_on, collision6[1], x_f, y_f, v_xt5, v_yt5, cx_f, cy_f, cv_xt, cv_yt, v_xf, v_yf, cv_xt1, cv_yt1, collision7);

collisionResolver cr_rb(clk, cue_on, collision7[1], rx_f, ry_f, rv_xt1, rv_yt1, bx_f, by_f, bv_xt1, bv_yt1, rv_xt2, rv_yt2, bv_xt2, bv_yt2, collision8);
collisionResolver cr_rg(clk, cue_on, collision8[1], rx_f, ry_f, rv_xt2, rv_yt2, gx_f, gy_f, gv_xt1, gv_yt1, rv_xt3, rv_yt3, gv_xt2, gv_yt2, collision9);
collisionResolver cr_ry(clk, cue_on, collision9[1], rx_f, ry_f, rv_xt3, rv_yt3, yx_f, yy_f, yv_xt1, yv_yt1, rv_xt4, rv_yt4, yv_xt2, yv_yt2, collision10);
collisionResolver cr_rm(clk, cue_on, collision10[1], rx_f, ry_f, rv_xt4, rv_yt4, mx_f, my_f, mv_xt1, mv_yt1, rv_xt5, rv_yt5, mv_xt2, mv_yt2, collision11);
collisionResolver cr_rc(clk, cue_on, collision11[1], rx_f, ry_f, rv_xt5, rv_yt5, cx_f, cy_f, cv_xt1, cv_yt1, rv_xf, rv_yf, cv_xt2, cv_yt2, collision12);

collisionResolver cr_bg(clk, cue_on, collision12[1], bx_f, by_f, bv_xt2, bv_yt2, gx_f, gy_f, gv_xt2, gv_yt2, bv_xt3, bv_yt3, gv_xt3, gv_yt3, collision13);
collisionResolver cr_by(clk, cue_on, collision13[1], bx_f, by_f, bv_xt3, bv_yt3, yx_f, yy_f, yv_xt2, yv_yt2, bv_xt4, bv_yt4, yv_xt3, yv_yt3, collision14);
collisionResolver cr_bm(clk, cue_on, collision14[1], bx_f, by_f, bv_xt4, bv_yt4, mx_f, my_f, mv_xt2, mv_yt2, bv_xt5, bv_yt5, mv_xt3, mv_yt3, collision15);
collisionResolver cr_bc(clk, cue_on, collision15[1], bx_f, by_f, bv_xt5, bv_yt5, cx_f, cy_f, cv_xt2, cv_yt2, bv_xf, bv_yf, cv_xt3, cv_yt3, collision16);

collisionResolver cr_gy(clk, cue_on, collision16[1], gx_f, gy_f, gv_xt3, gv_yt3, yx_f, yy_f, yv_xt3, yv_yt3, gv_xt4, gv_yt4, yv_xt4, yv_yt4, collision17);
collisionResolver cr_gm(clk, cue_on, collision17[1], gx_f, gy_f, gv_xt4, gv_yt4, mx_f, my_f, mv_xt3, mv_yt3, gv_xt5, gv_yt5, mv_xt4, mv_yt4, collision18);
collisionResolver cr_gc(clk, cue_on, collision18[1], gx_f, gy_f, gv_xt5, gv_yt5, cx_f, cy_f, cv_xt3, cv_yt3, gv_xf, gv_yf, cv_xt4, cv_yt4, collision19);

collisionResolver cr_ym(clk, cue_on, collision19[1], yx_f, yy_f, yv_xt4, yv_yt4, mx_f, my_f, mv_xt4, mv_yt4, yv_xt5, yv_yt5, mv_xt5, mv_yt5, collision20);
collisionResolver cr_yc(clk, cue_on, collision20[1], yx_f, yy_f, yv_xt5, yv_yt5, cx_f, cy_f, cv_xt4, cv_yt4, yv_xf, yv_yf, cv_xt5, cv_yt5, collision21);

collisionResolver cr_mc(clk, cue_on, collision21[1], mx_f, my_f, mv_xt5, mv_yt5, cx_f, cy_f, cv_xt5, cv_yt5, mv_xf, mv_yf, cv_xf, cv_yf, moverFlag);

//collisionResolver cr_rb(clk, collision7[1], rx_f, ry_f, rv_xt1, rv_yt1, bx_f, by_f, bv_xt1, bv_yt1, rv_xf, rv_yf, bv_xf, bv_yf, moverFlag);
//three more collision resolvers for green 
//collisionResolver cr_wg(clk, collision4[1], x_f, y_f, v_xt, v_yt, gx_f, gy_f, gv_xt, gv_yt, v_xt1, v_yt1, gv_xt1, gv_yt1, collision5);
//collisionResolver cr_gb(clk, collision5[1], gx_f, gy_f, gv_xt1, gv_yt1, bx_f, by_f, bv_xt, bv_yt, gv_xf, gv_yf, bv_xt1, bv_yt1, collision6);
//collisionResolver cr_rg(clk, collision6[1], rx_f, ry_f, rv_xt1, rv_yt1, gx_f, gy_f, gv_xt1, gv_yt1, rv_xf, rv_yf, gv_xf, gv_yf, moverFlag);

endmodule