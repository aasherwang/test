module dct8x8_buf_data
#(
parameter DATA_WIDTH    = 8
)(
input                          clk                    ,
input                          dct8x8_buf_wen         ,
input                          dct8x8_buf_wr_row_flag ,
input      [2:0]               dct8x8_buf_wptr        ,
input      [DATA_WIDTH*16-1:0] dct8x8_buf_wdata       ,

input                          dct8x8_buf_rd_row_flag ,
input      [2:0]               dct8x8_buf_rptr        ,
output reg [DATA_WIDTH*16-1:0] dct8x8_buf_rdata
);
//===========================================================
//* Internal variables
//===========================================================
reg [DATA_WIDTH*8-1:0] dct8x8_buf [0:7] ;

reg [6:0]   bit_offset_w_0            ;
reg [6:0]   bit_offset_r_0            ;

reg [6:0]   bit_offset_w_1            ;
reg [6:0]   bit_offset_r_1            ;
//===========================================================
//* BUF WRITE BLOCKS
//===========================================================`

always @(*) begin
    case(dct8x8_buf_wptr[2:1])
        3'd0:   bit_offset_w_0 = 0*DATA_WIDTH;
        3'd1:   bit_offset_w_0 = 2*DATA_WIDTH;
        3'd2:   bit_offset_w_0 = 4*DATA_WIDTH;
        default:bit_offset_w_0 = 6*DATA_WIDTH;
    endcase
end

always @(*) begin
    case(dct8x8_buf_wptr[2:1])
        3'd0:   bit_offset_w_1 = 1*DATA_WIDTH;
        3'd1:   bit_offset_w_1 = 3*DATA_WIDTH;
        3'd2:   bit_offset_w_1 = 5*DATA_WIDTH;
        default:bit_offset_w_1 = 7*DATA_WIDTH;
    endcase
end

always @( posedge clk ) begin
    if(dct8x8_buf_wen)begin
        if( dct8x8_buf_wr_row_flag == 1'b1 ) begin
            dct8x8_buf[{dct8x8_buf_wptr[2:1],1'b0}] <= dct8x8_buf_wdata[ DATA_WIDTH*8 -1:0 ];
            dct8x8_buf[{dct8x8_buf_wptr[2:1],1'b1}] <= dct8x8_buf_wdata[ DATA_WIDTH*16 -1:DATA_WIDTH*8 ];
        end
        else begin
            dct8x8_buf[0][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[1*DATA_WIDTH-1 : 0*DATA_WIDTH];
            dct8x8_buf[1][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[2*DATA_WIDTH-1 : 1*DATA_WIDTH];
            dct8x8_buf[2][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[3*DATA_WIDTH-1 : 2*DATA_WIDTH];
            dct8x8_buf[3][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[4*DATA_WIDTH-1 : 3*DATA_WIDTH];
            dct8x8_buf[4][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[5*DATA_WIDTH-1 : 4*DATA_WIDTH];
            dct8x8_buf[5][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[6*DATA_WIDTH-1 : 5*DATA_WIDTH];
            dct8x8_buf[6][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[7*DATA_WIDTH-1 : 6*DATA_WIDTH];
            dct8x8_buf[7][bit_offset_w_0+:DATA_WIDTH] <= dct8x8_buf_wdata[8*DATA_WIDTH-1 : 7*DATA_WIDTH];

            dct8x8_buf[0][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[9*DATA_WIDTH-1 : 8*DATA_WIDTH];
            dct8x8_buf[1][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[10*DATA_WIDTH-1: 9*DATA_WIDTH];
            dct8x8_buf[2][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[11*DATA_WIDTH-1:10*DATA_WIDTH];
            dct8x8_buf[3][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[12*DATA_WIDTH-1:11*DATA_WIDTH];
            dct8x8_buf[4][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[13*DATA_WIDTH-1:12*DATA_WIDTH];
            dct8x8_buf[5][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[14*DATA_WIDTH-1:13*DATA_WIDTH];
            dct8x8_buf[6][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[15*DATA_WIDTH-1:14*DATA_WIDTH];
            dct8x8_buf[7][bit_offset_w_1+:DATA_WIDTH] <= dct8x8_buf_wdata[16*DATA_WIDTH-1:15*DATA_WIDTH];
        end
    end      
end
//===========================================================
//*BUF READ BLOCKS
//===========================================================
always @(*) begin
    case(dct8x8_buf_rptr[2:1])
        3'd0:   bit_offset_r_0 = 0*DATA_WIDTH;
        3'd1:   bit_offset_r_0 = 2*DATA_WIDTH;
        3'd2:   bit_offset_r_0 = 4*DATA_WIDTH;
        default:bit_offset_r_0 = 6*DATA_WIDTH;
    endcase
end

always @(*) begin
    case(dct8x8_buf_rptr[2:1])
        3'd0:   bit_offset_r_1 = 1*DATA_WIDTH;
        3'd1:   bit_offset_r_1 = 3*DATA_WIDTH;
        3'd2:   bit_offset_r_1 = 5*DATA_WIDTH;
        default:bit_offset_r_1 = 7*DATA_WIDTH;
    endcase
end

always @(*) begin
    if(dct8x8_buf_rd_row_flag == 1'b1)begin
        dct8x8_buf_rdata = {dct8x8_buf[{dct8x8_buf_rptr[2:1],1'b1}],
                            dct8x8_buf[{dct8x8_buf_rptr[2:1],1'b0}]};
        end
    else begin
        dct8x8_buf_rdata = {dct8x8_buf[7][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[6][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[5][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[4][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[3][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[2][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[1][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[0][bit_offset_r_1+:DATA_WIDTH],
                            dct8x8_buf[7][bit_offset_r_0+:DATA_WIDTH],
                            dct8x8_buf[6][bit_offset_r_0+:DATA_WIDTH],
                            dct8x8_buf[5][bit_offset_r_0+:DATA_WIDTH], 
                            dct8x8_buf[4][bit_offset_r_0+:DATA_WIDTH],
                            dct8x8_buf[3][bit_offset_r_0+:DATA_WIDTH],
                            dct8x8_buf[2][bit_offset_r_0+:DATA_WIDTH],
                            dct8x8_buf[1][bit_offset_r_0+:DATA_WIDTH],
                            dct8x8_buf[0][bit_offset_r_0+:DATA_WIDTH]};
        end
end

endmodule
