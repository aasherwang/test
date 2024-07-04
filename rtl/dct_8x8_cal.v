module dct8x8_cal#(
    parameter DATA_WIDTH = 8
)(
    input  [8*DATA_WIDTH-1:0]    dct8x8_cal_data_in,
    output [8*(DATA_WIDTH+4)-1:0]dct8x8_cal_data_out
);

//===========================================================
//* Internal variables
//===========================================================
wire signed [DATA_WIDTH-1:0]    dct8x8_i0;
wire signed [DATA_WIDTH-1:0]    dct8x8_i1;
wire signed [DATA_WIDTH-1:0]    dct8x8_i2;
wire signed [DATA_WIDTH-1:0]    dct8x8_i3;
wire signed [DATA_WIDTH-1:0]    dct8x8_i4;
wire signed [DATA_WIDTH-1:0]    dct8x8_i5;
wire signed [DATA_WIDTH-1:0]    dct8x8_i6;
wire signed [DATA_WIDTH-1:0]    dct8x8_i7;

wire signed [DATA_WIDTH:0]      dct8x8_p0;
wire signed [DATA_WIDTH:0]      dct8x8_p1;
wire signed [DATA_WIDTH:0]      dct8x8_p2;
wire signed [DATA_WIDTH:0]      dct8x8_p3;
wire signed [DATA_WIDTH:0]      dct8x8_p4;
wire signed [DATA_WIDTH:0]      dct8x8_p5;
wire signed [DATA_WIDTH:0]      dct8x8_p6;
wire signed [DATA_WIDTH:0]      dct8x8_p7;

wire signed [DATA_WIDTH+1:0]    dct8x8_q0;
wire signed [DATA_WIDTH+1:0]    dct8x8_q1;
wire signed [DATA_WIDTH+1:0]    dct8x8_q2;
wire signed [DATA_WIDTH+1:0]    dct8x8_q3;
wire signed [DATA_WIDTH+1:0]    dct8x8_q4;
wire signed [DATA_WIDTH+1:0]    dct8x8_q5;
wire signed [DATA_WIDTH+1:0]    dct8x8_q6;
wire signed [DATA_WIDTH+1:0]    dct8x8_q7;

wire signed [DATA_WIDTH+3:0]    dct8x8_tmp0;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp1;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp2;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp3;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp4;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp5;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp6;
wire signed [DATA_WIDTH+3:0]    dct8x8_tmp7;

//===========================================================
//* COMBINATIONAL LOGIC OF DCT8X8_1D OR DCT8X8_2D
//===========================================================
assign dct8x8_i0 = dct8x8_cal_data_in[1*DATA_WIDTH-1:0*DATA_WIDTH];
assign dct8x8_i1 = dct8x8_cal_data_in[2*DATA_WIDTH-1:1*DATA_WIDTH];
assign dct8x8_i2 = dct8x8_cal_data_in[3*DATA_WIDTH-1:2*DATA_WIDTH];
assign dct8x8_i3 = dct8x8_cal_data_in[4*DATA_WIDTH-1:3*DATA_WIDTH];
assign dct8x8_i4 = dct8x8_cal_data_in[5*DATA_WIDTH-1:4*DATA_WIDTH];
assign dct8x8_i5 = dct8x8_cal_data_in[6*DATA_WIDTH-1:5*DATA_WIDTH];
assign dct8x8_i6 = dct8x8_cal_data_in[7*DATA_WIDTH-1:6*DATA_WIDTH];
assign dct8x8_i7 = dct8x8_cal_data_in[8*DATA_WIDTH-1:7*DATA_WIDTH];

assign dct8x8_p0 = dct8x8_i0 + dct8x8_i7;
assign dct8x8_p1 = dct8x8_i3 - dct8x8_i4;
assign dct8x8_p2 = dct8x8_i1 + dct8x8_i6;
assign dct8x8_p3 = dct8x8_i2 - dct8x8_i5;
assign dct8x8_p4 = dct8x8_i2 + dct8x8_i5;
assign dct8x8_p5 = dct8x8_i1 - dct8x8_i6;
assign dct8x8_p6 = dct8x8_i3 + dct8x8_i4;
assign dct8x8_p7 = dct8x8_i0 - dct8x8_i7;

assign dct8x8_q0 =  dct8x8_p0       +  dct8x8_p6      ;
assign dct8x8_q1 =  dct8x8_p1       - (dct8x8_p7>>>2) ;
assign dct8x8_q2 =  dct8x8_p2       +  dct8x8_p4      ;
assign dct8x8_q3 =  dct8x8_p3       + (dct8x8_p5>>>2) ;
assign dct8x8_q4 =  dct8x8_p2       -  dct8x8_p4      ;
assign dct8x8_q5 = (dct8x8_p3>>>2)  -  dct8x8_p5      ;
assign dct8x8_q6 =  dct8x8_p0       -  dct8x8_p6      ;
assign dct8x8_q7 = (dct8x8_p1>>>2)  +  dct8x8_p7      ;

assign dct8x8_tmp0 =  dct8x8_q0      + dct8x8_q2                                        ;
assign dct8x8_tmp1 =  dct8x8_q3      - dct8x8_q5     + dct8x8_q7      +(dct8x8_q7>>>1)  ;
assign dct8x8_tmp2 = (dct8x8_q4>>>1) + dct8x8_q6                                        ;
assign dct8x8_tmp3 = -dct8x8_q1      - dct8x8_q3     -(dct8x8_q3>>>1) + dct8x8_q7       ;
assign dct8x8_tmp4 =  dct8x8_q0      - dct8x8_q2                                        ;
assign dct8x8_tmp5 =  dct8x8_q1      + dct8x8_q5     +(dct8x8_q5>>>1) + dct8x8_q7       ;
assign dct8x8_tmp6 = -dct8x8_q4      +(dct8x8_q6>>>1)                                   ;
assign dct8x8_tmp7 = -dct8x8_q1      -(dct8x8_q1>>>1)+ dct8x8_q3      + dct8x8_q5       ;

assign dct8x8_cal_data_out = {dct8x8_tmp7,
                              dct8x8_tmp6,
                              dct8x8_tmp5,
                              dct8x8_tmp4,
                              dct8x8_tmp3,
                              dct8x8_tmp2,
                              dct8x8_tmp1,
                              dct8x8_tmp0};

endmodule
