`define DLY #1

module tb;

reg     clk;
reg     rst_n;
reg     frm_start;

initial begin
    clk       = 0;
    rst_n     = 0;
    frm_start = 0;
    #15
    rst_n     = 1;
end

always #10 clk = ~clk;

//===========================================================
//* Dut instance
//=========================================================== 
parameter   DATA_WIDTH = 8;

wire                        i_vld;
wire                        i_rdy;
wire [DATA_WIDTH*16-1:0]    i_data;

wire                        o_vld;
wire                        o_rdy;
wire [(DATA_WIDTH+8)*16-1:0]o_data;

dct8x8_top
#( .DATA_WIDTH(DATA_WIDTH) ) 
dct8x8_top_inst(
.clk               ( clk    ) ,
.rst_n             ( rst_n  ) ,
.dct8x8_top_vld_i  ( i_vld  ) ,
.dct8x8_top_data_i ( i_data ) ,
.dct8x8_top_rdy_i  ( i_rdy  ) ,
.dct8x8_top_vld_o  ( o_vld  ) ,
.dct8x8_top_data_o ( o_data ) ,
.dct8x8_top_rdy_o  ( o_rdy  )
);

//===========================================================
//* vld BFM for data input
//=========================================================== 
integer     min_vld     = 1  ;
integer     max_vld     = 10 ;
integer     min_non_vld = 0  ;
integer     max_non_vld = 0  ;

wire data_output_done_vld_bfm;

BFM_VLD #(.filename("../data/blk_8x8_orig_data.txt"),
          .d_width ( 16*DATA_WIDTH ))

bfm_vld(.clk              (clk                      ) ,
        .rst_n            (rst_n                    ) ,
        .vld              (i_vld               ) ,
        .rdy              (i_rdy               ) ,
        .data_o           (i_data              ) ,
        .min_vld          (min_vld                  ) ,
        .max_vld          (max_vld                  ) ,
        .min_non_vld      (min_non_vld              ) ,
        .max_non_vld      (max_non_vld              ) ,
        .data_output_done (data_output_done_vld_bfm )
                                                    ) ;
//===========================================================
//* rdy BFM for data output
//=========================================================== 
integer  min_rdy     = 1  ;
integer  max_rdy     = 10 ;
integer  min_non_rdy = 0  ;
integer  max_non_rdy = 0  ;

BFM_RDY #( .module_name("bfm_rdy")) 
bfm_rdy(
        .clk         ( clk         ) ,
        .rst_n       ( rst_n       ) ,
        .vld         ( o_vld  ) ,
        .rdy         ( o_rdy  ) ,
        .min_rdy     ( min_rdy     ) ,
        .max_rdy     ( max_rdy     ) ,
        .min_non_rdy ( min_non_rdy ) ,
        .max_non_rdy ( max_non_rdy )
                                   ) ;
//===========================================================
//* CHECKER
//=========================================================== 
//check 1d row
assign blk_8x8_1d_row_check_en = dct8x8_top_inst.dct8x8_top_vld_i && dct8x8_top_inst.dct8x8_top_rdy_i;

CHECKER#(.filename ("../data/blk_8x8_1d_row_0246_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+4) ))
checker_1d_row_0246       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_1d_row_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_1d_row0 ) ,
         .data_check_done (                                )
                                                           ) ;


CHECKER#(.filename ("../data/blk_8x8_1d_row_1357_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+4) ))
checker_1d_row_1357       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_1d_row_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_1d_row1 ) ,
         .data_check_done (                                )
                                                           ) ;

//check 1d col
assign blk_8x8_1d_col_check_en = dct8x8_top_inst.dct8x8_buf1_vld_o && dct8x8_top_inst.dct8x8_buf1_rdy_o;

CHECKER#(.filename ("../data/blk_8x8_1d_col_0246_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+4) ))
checker_1d_col_0246       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_1d_col_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_1d_col0 ) ,
         .data_check_done (                                )
                                                           ) ;


CHECKER#(.filename ("../data/blk_8x8_1d_col_1357_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+4) ))
checker_1d_col_1357       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_1d_col_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_1d_col1 ) ,
         .data_check_done (                                )
                                                           ) ;

//check 2d col
assign blk_8x8_2d_col_check_en = dct8x8_top_inst.dct8x8_buf1_vld_o && dct8x8_top_inst.dct8x8_buf1_rdy_o;

CHECKER#(.filename ("../data/blk_8x8_2d_col_0246_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+8) ))
checker_2d_col_0246       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_2d_col_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_2d_col0 ) ,
         .data_check_done (                                )
                                                           ) ;


CHECKER#(.filename ("../data/blk_8x8_2d_col_1357_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+8) ))
checker_2d_col_1357       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_2d_col_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_2d_col1 ) ,
         .data_check_done (                                )
                                                           ) ;

//check 2d row
assign blk_8x8_2d_row_check_en = dct8x8_top_inst.dct8x8_top_vld_o && dct8x8_top_inst.dct8x8_top_rdy_o;

CHECKER#(.filename ("../data/blk_8x8_2d_row_0246_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+8) ))
checker_2d_row_0246       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_2d_row_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_2d_row0 ) ,
         .data_check_done ( data_check_done                )
                                                           ) ;


CHECKER#(.filename ("../data/blk_8x8_2d_row_1357_data.txt"),
         .d_width  ( 8*(DATA_WIDTH+8) ))
checker_2d_row_1357       (
         .clk             ( clk                            ) ,
         .rst_n           ( rst_n                          ) ,
         .input_en        ( blk_8x8_2d_row_check_en        ) ,
         .data_i          ( dct8x8_top_inst.dct8x8_2d_row1 ) ,
         .data_check_done (                                )
                                                           ) ;

//finish the simulation
always@( posedge data_check_done )
    #500
    if(data_check_done == 1'b1)
        $finish;


initial begin
    $fsdbDumpfile(" hello.fsdb ");
    $fsdbDumpvars("+all");
end

endmodule

