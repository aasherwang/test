module dct8x8_top#(parameter DATA_WIDTH  =  8)
(
input								clk				  ,
input                               rst_n             ,
input                               dct8x8_top_vld_i  ,
input  wire [DATA_WIDTH*16-1:0]     dct8x8_top_data_i ,
output wire                         dct8x8_top_rdy_i  ,

output wire                         dct8x8_top_vld_o  ,
output wire [(DATA_WIDTH+8)*16-1:0] dct8x8_top_data_o ,
input                               dct8x8_top_rdy_o
);

//===========================================================
//* 1D calculation instance
//===========================================================
wire    [(DATA_WIDTH+4)*8-1:0]      dct8x8_1d_row0;
wire    [(DATA_WIDTH+4)*8-1:0]      dct8x8_1d_row1;

dct8x8_cal#(
.DATA_WIDTH     (DATA_WIDTH)
)
dct8x8_cal_1d_0(.dct8x8_cal_data_in (dct8x8_top_data_i[DATA_WIDTH*8-1:0]),
                .dct8x8_cal_data_out(dct8x8_1d_row0)
);

dct8x8_cal#(
.DATA_WIDTH     (DATA_WIDTH)
)
dct8x8_cal_1d_1(.dct8x8_cal_data_in (dct8x8_top_data_i[DATA_WIDTH*16-1:DATA_WIDTH*8]),
                .dct8x8_cal_data_out(dct8x8_1d_row1)
);

//===========================================================
//* buffer1 instance : row in col out
//===========================================================
wire    [(DATA_WIDTH+4)*8-1:0]      dct8x8_1d_col0;
wire    [(DATA_WIDTH+4)*8-1:0]      dct8x8_1d_col1;

wire    dct8x8_buf1_rdy_o;
wire    dct8x8_buf1_vld_o;

dct8x8_buf_top#(.DATA_WIDTH(DATA_WIDTH + 4))
dct8x8_buf_inst1(
.clk                    (  clk                              ),
.rst_n                  (  rst_n                            ),
.dct8x8_buf_wr_row_flag (  1'b1                             ),//row in
.dct8x8_buf_rd_row_flag (  1'b0                             ),//col out

.dct8x8_buf_vld_i       (  dct8x8_top_vld_i                 ),
.dct8x8_buf_data_i      ( {dct8x8_1d_row1,dct8x8_1d_row0}   ),
.dct8x8_buf_rdy_i       (  dct8x8_top_rdy_i                 ),

.dct8x8_buf_vld_o       (  dct8x8_buf1_vld_o                ),
.dct8x8_buf_data_o      ( {dct8x8_1d_col1,dct8x8_1d_col0}   ),
.dct8x8_buf_rdy_o       (  dct8x8_buf1_rdy_o                )
);

//===========================================================
//* 2D calculation instance
//===========================================================
wire    [(DATA_WIDTH+8)*8-1:0]  dct8x8_2d_col0;
wire    [(DATA_WIDTH+8)*8-1:0]  dct8x8_2d_col1;

dct8x8_cal #( .DATA_WIDTH(DATA_WIDTH + 4) ) 
dct8x8_cal_2d_0(
.dct8x8_cal_data_in   ( dct8x8_1d_col0 ),
.dct8x8_cal_data_out  ( dct8x8_2d_col0 )
);


dct8x8_cal #( .DATA_WIDTH(DATA_WIDTH + 4) ) 
dct8x8_cal_2d_1(
.dct8x8_cal_data_in   ( dct8x8_1d_col1 ),
.dct8x8_cal_data_out  ( dct8x8_2d_col1 )
);

//===========================================================
//* buffer2 instance : col in row out
//===========================================================
wire    [(DATA_WIDTH+8)*8-1:0]  dct8x8_2d_row0;
wire    [(DATA_WIDTH+8)*8-1:0]  dct8x8_2d_row1;

dct8x8_buf_top #( .DATA_WIDTH(DATA_WIDTH+8) ) 
dct8x8_buf_inst2(
.clk                    ( clk                            ) ,
.rst_n                  ( rst_n                          ) ,
.dct8x8_buf_wr_row_flag ( 1'b0                           ) ,//col in
.dct8x8_buf_rd_row_flag ( 1'b1                           ) ,//row out

.dct8x8_buf_vld_i       ( dct8x8_buf1_vld_o              ) ,
.dct8x8_buf_data_i      ({dct8x8_2d_col1,dct8x8_2d_col0} ) ,
.dct8x8_buf_rdy_i       ( dct8x8_buf1_rdy_o              ) ,

.dct8x8_buf_vld_o       ( dct8x8_top_vld_o               ) ,
.dct8x8_buf_data_o      ({dct8x8_2d_row1,dct8x8_2d_row0} ) ,
.dct8x8_buf_rdy_o       ( dct8x8_top_rdy_o               )
);

assign dct8x8_top_data_o = {dct8x8_2d_row1,dct8x8_2d_row0};

endmodule
