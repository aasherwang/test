`define right 1

module CHECKER#(
    parameter string filename = " ",
    parameter int d_width = 16

)
(
    input bit clk,
    input bit rst_n,
    input bit input_en,
    input [d_width-1:0] data_i,
    output bit data_check_done
);


bit [d_width-1:0] data_bank[$];
bit [d_width-1:0] data;
int file_handle;
int fp;
int read_data_num;
int check_data_num;

function void init(input string fileaddr=" ");
    //init variable
    data_bank.delete();
    data = 0;
    read_data_num = 0;
    check_data_num = 0;
    //init output  signal
    data_check_done = 1'b0;
    //read input verification data from file
    file_handle = $fopen(fileaddr,"r");
    if(file_handle==0) begin
        $display("open file failed at verification file: %s",fileaddr);
        $finish;
        end
    while(!$feof(file_handle)) begin
        fp = $fscanf(file_handle,"%h",data);
        if(fp==1) begin
            data_bank.push_front(data);
            read_data_num++;
            end
        end
    $fclose(file_handle);
    $display("read file finished at verification file: %s", fileaddr);
endfunction

always @( posedge clk or negedge rst_n ) begin
    if( !rst_n ) begin
        init(filename);
    end
    else begin
        if(input_en) begin
            data = data_bank.pop_back;
            if(data_i!==data)begin
                $display("verification error: current time:%t, verification file:%s,data num:%0d, DUT data:%h, reference data: %h",$time,filename,check_data_num,data_i,data);
        end
        `ifdef right
            if(check_data_num%10==0) begin
                $display("verification current time:%t,verification file:%s,data num:%0d",$time,filename,check_data_num);
        end      
        `endif

        check_data_num++;
        if(check_data_num==read_data_num) begin
            data_check_done <= 1'b1;
            if(data_check_done==0) begin
                $display("data from verification file: %s has all been checked at time: %t",filename,$time);
                end
            end
        end
    end
end

endmodule
