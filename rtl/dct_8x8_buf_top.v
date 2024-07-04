module dct8x8_buf_top#(
parameter DATA_WIDTH = 8
)(
input                           clk                    ,
input                           rst_n                  ,
input                           dct8x8_buf_wr_row_flag ,
input                           dct8x8_buf_rd_row_flag ,

input                           dct8x8_buf_vld_i       ,
input  wire [DATA_WIDTH*16-1:0] dct8x8_buf_data_i      ,
output wire                     dct8x8_buf_rdy_i       ,

output wire                     dct8x8_buf_vld_o       ,
output wire [DATA_WIDTH*16-1:0] dct8x8_buf_data_o      ,
input                           dct8x8_buf_rdy_o
);

//===========================================================
//* buffer control instance
//===========================================================

wire            dct8x8_buf_wen  ;
wire [2:0]      dct8x8_buf_wptr ;
wire            dct8x8_buf_ren  ;
wire [2:0]      dct8x8_buf_rptr ;

dct8x8_buf_ctrl dct8x8_buf_ctrl_inst(.clk                   (clk             ),
                                     .rst_n                 (rst_n           ),
                                     .dct8x8_buf_vld_i      (dct8x8_buf_vld_i),
                                     .dct8x8_buf_rdy_i      (dct8x8_buf_rdy_i),
                                                            
                                     .dct8x8_buf_vld_o      (dct8x8_buf_vld_o),
                                     .dct8x8_buf_rdy_o      (dct8x8_buf_rdy_o),
                                                            
                                     .dct8x8_buf_wen        (dct8x8_buf_wen  ),
                                     .dct8x8_buf_wptr       (dct8x8_buf_wptr ),
                                     .dct8x8_buf_ren        (dct8x8_buf_ren  ),
                                     .dct8x8_buf_rptr       (dct8x8_buf_rptr )
);

//===========================================================
//* buffer data instance
//===========================================================
dct8x8_buf_data#(
.DATA_WIDTH(DATA_WIDTH)
)
dct8x8_buf_data_inst(.clk                    (clk                   ),
                     .dct8x8_buf_wen         (dct8x8_buf_wen        ),
                     .dct8x8_buf_wr_row_flag (dct8x8_buf_wr_row_flag),
                     .dct8x8_buf_wptr        (dct8x8_buf_wptr       ),
                     .dct8x8_buf_wdata       (dct8x8_buf_data_i     ),

                     .dct8x8_buf_rd_row_flag (dct8x8_buf_rd_row_flag),
                     .dct8x8_buf_rptr        (dct8x8_buf_rptr       ),
                     .dct8x8_buf_rdata       (dct8x8_buf_data_o     )
);

endmodule
