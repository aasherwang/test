module dct8x8_buf_ctrl(
input            clk,
input            rst_n,
input            dct8x8_buf_vld_i,
output wire      dct8x8_buf_rdy_i,

output wire      dct8x8_buf_vld_o,
input            dct8x8_buf_rdy_o,

output wire      dct8x8_buf_wen,
output reg [2:0] dct8x8_buf_wptr,

output wire      dct8x8_buf_ren,
output reg [2:0] dct8x8_buf_rptr
);

//===========================================================
//* Local parameter
//===========================================================
localparam      IDLE     = 3'd0;
localparam      SAVED_01 = 3'd1;
localparam      SAVED_03 = 3'd2;
localparam      SAVED_05 = 3'd3;
localparam      SAVED_07 = 3'd4;
localparam      SENT_01  = 3'd5;
localparam      SENT_03  = 3'd6;
localparam      SENT_05  = 3'd7;

//===========================================================
//* data in and data out flag
//===========================================================
wire data_i_en;
wire data_o_en;

assign data_i_en = dct8x8_buf_vld_i && dct8x8_buf_rdy_i;
assign data_o_en = dct8x8_buf_vld_o && dct8x8_buf_rdy_o;
assign dct8x8_buf_wen = data_i_en;
assign dct8x8_buf_ren = data_o_en;
//===========================================================
//* BFM
//===========================================================
reg     [2:0]   buf_cur_state;
reg     [2:0]   buf_nxt_state;

always @( posedge clk or negedge rst_n ) begin
    if( ~rst_n ) begin
        buf_cur_state <= IDLE;
    end
    else begin
        buf_cur_state <= buf_nxt_state;
    end
end      

always @(*) begin
    case(buf_cur_state)
        IDLE     :  buf_nxt_state = dct8x8_buf_wen ? SAVED_01 : buf_cur_state;
        SAVED_01 :  buf_nxt_state = dct8x8_buf_wen ? SAVED_03 : buf_cur_state;
        SAVED_03 :  buf_nxt_state = dct8x8_buf_wen ? SAVED_05 : buf_cur_state;
        SAVED_05 :  buf_nxt_state = dct8x8_buf_wen ? SAVED_07 : buf_cur_state;
        SAVED_07 :  buf_nxt_state = dct8x8_buf_ren ? SENT_01  : buf_cur_state;
        SENT_01  :  buf_nxt_state = dct8x8_buf_ren ? SENT_03  : buf_cur_state;
        SENT_03  :  buf_nxt_state = dct8x8_buf_ren ? SENT_05  : buf_cur_state;
        default  :  buf_nxt_state = dct8x8_buf_ren ? IDLE     : buf_cur_state;
    endcase
end

//===========================================================
//* dct8x8_buf_rdy_i generate
//* when current state is IDLE,SAVED_01-SAVED_05, buffer can receive data
//===========================================================
assign dct8x8_buf_rdy_i = ~buf_cur_state[2];

//===========================================================
//* dct8x8_buf_vld_o generate
//* when current state is SAVED_07,SENT_01-SENT_05, buffer can output data 
//===========================================================
assign dct8x8_buf_vld_o = buf_cur_state[2];

//===========================================================
//* write enable and pointer
//===========================================================
always @(*) begin
    case(buf_cur_state[1:0])
        2'b00   : dct8x8_buf_wptr = 3'd0;
        2'b01   : dct8x8_buf_wptr = 3'd2;
        2'b10   : dct8x8_buf_wptr = 3'd4;
        default : dct8x8_buf_wptr = 3'd6;
    endcase
end

//===========================================================
//* read enable and pointer
//===========================================================
always @(*) begin
    case(buf_cur_state[1:0])
        2'b00   : dct8x8_buf_rptr = 3'd0;
        2'b01   : dct8x8_buf_rptr = 3'd2;
        2'b10   : dct8x8_buf_rptr = 3'd4;
        default : dct8x8_buf_rptr = 3'd6;
    endcase
end

endmodule


