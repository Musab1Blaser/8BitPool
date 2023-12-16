`timescale 1ns / 1ps

module allMover(input v_sync, input [1:0] state, input hit, input [2:0] rot,

// ball input positions and velocities
input [10:0] x_i, input [10:0] y_i, input [4:0] u_x, input [4:0] u_y,
input [10:0] rx_i, input [10:0] ry_i, input [4:0] ru_x, input [4:0] ru_y,
input [10:0] bx_i, input [10:0] by_i, input [4:0] bu_x, input [4:0] bu_y,
input [10:0] gx_i, input [10:0] gy_i, input [4:0] gu_x, input [4:0] gu_y,
input [10:0] yx_i, input [10:0] yy_i, input [4:0] yu_x, input [4:0] yu_y,
input [10:0] mx_i, input [10:0] my_i, input [4:0] mu_x, input [4:0] mu_y,
input [10:0] cx_i, input [10:0] cy_i, input [4:0] cu_x, input [4:0] cu_y,



// ball output positions and velocities
output [10:0] x_f, output [10:0] y_f, output [4:0] v_xt, output [4:0] v_yt,
output [10:0] rx_f, output [10:0] ry_f, output [4:0] rv_xt, output [4:0] rv_yt,
output [10:0] bx_f, output [10:0] by_f, output [4:0] bv_xt, output [4:0] bv_yt,
output [10:0] gx_f, output [10:0] gy_f, output [4:0] gv_xt, output [4:0] gv_yt,
output [10:0] yx_f, output [10:0] yy_f, output [4:0] yv_xt, output [4:0] yv_yt,
output [10:0] mx_f, output [10:0] my_f, output [4:0] mv_xt, output [4:0] mv_yt,
output [10:0] cx_f, output [10:0] cy_f, output [4:0] cv_xt, output [4:0] cv_yt,

// strength + cue_state
output [6:0] strength, output cue_on
    );

wire hit_white;
assign hit_white = (state == 1) && hit;

reg hit_fake;
initial
    hit_fake = 0;
    
wire [6:0] strengthR;
wire [6:0] strengthB;
wire [6:0] strengthG;
wire [6:0] strengthY;
wire [6:0] strengthM;
wire [6:0] strengthC;

//assign cue_on = 1;
assign cue_on = (u_x[3:0] == 0 && u_y[3:0] == 0
&& ru_x[3:0] == 0 && ru_y[3:0] == 0
&& bu_x[3:0] == 0 && bu_y[3:0] == 0
&& gu_x[3:0] == 0 && gu_y[3:0] == 0
&& yu_x[3:0] == 0 && yu_y[3:0] == 0
&& mu_x[3:0] == 0 && mu_y[3:0] == 0
&& cu_x[3:0] == 0 && cu_y[3:0] == 0);

moverModule mv_w (v_sync, cue_on, x_i, y_i, u_x, u_y, hit_white, rot, x_f, y_f, v_xt, v_yt, strength);
moverModule mv_r (v_sync, cue_on, rx_i, ry_i, ru_x, ru_y, hit_fake, rot, rx_f, ry_f, rv_xt, rv_yt, strengthR);
moverModule mv_b (v_sync, cue_on, bx_i, by_i, bu_x, bu_y, hit_fake, rot, bx_f, by_f, bv_xt, bv_yt, strengthB);     
// moverModule including the green ball 
moverModule mv_g (v_sync, cue_on, gx_i, gy_i, gu_x, gu_y, hit_fake, rot, gx_f, gy_f, gv_xt, gv_yt, strengthG);     
moverModule mv_y (v_sync, cue_on, yx_i, yy_i, yu_x, yu_y, hit_fake, rot, yx_f, yy_f, yv_xt, yv_yt, strengthY);     
moverModule mv_m (v_sync, cue_on, mx_i, my_i, mu_x, mu_y, hit_fake, rot, mx_f, my_f, mv_xt, mv_yt, strengthM);     
moverModule mv_c (v_sync, cue_on, cx_i, cy_i, cu_x, cu_y, hit_fake, rot, cx_f, cy_f, cv_xt, cv_yt, strengthC);     

endmodule
