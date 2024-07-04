class rand_vld;
    rand int p;
    int min;
    int max;
    function new(input int min=5,max=5);
        this.min = min;
        this.max = max;
    endfunction
    constraint c1{
        p inside {[min:max]};
    }
endclass

module BFM_VLD#(
    parameter string filename = " ",
    parameter int d_width = 16
)
(
    input bit clk,
    input bit rst_n,
    input bit rdy,
    output bit vld,
    input int min_vld,
    input int max_vld,
    input int min_non_vld,
    input int max_non_vld,
    output bit [d_width-1:0] data_o,
    output bit data_output_done
);

bit [d_width-1:0] data_bank[$];
bit [d_width-1:0] data_read;
bit timer_en;
int output_cnt;
int file_handle;
int fp;
int read_data_num;

function void init(input string fileaddr=" ");
    //init variable
    data_bank.delete();
    data_read = 0;
    output_cnt = 0;
    read_data_num = 0;
    //init output signal
    vld = 1'b0;
    data_o = 0;
    data_output_done = 1'b0;
    //read input testcase file
    file_handle = $fopen(fileaddr,"r");
    if(file_handle==0) begin
        $display("open file failed at testcase file %s",fileaddr);
        $finish;
    end
    while(!$feof(file_handle)) begin
        fp = $fscanf(file_handle,"%h",data_read);
        if(fp==1) begin
            data_bank.push_front(data_read);
            read_data_num++;
        end
    end
    $fclose(file_handle);
    $display("read file finished at testcase file %s",fileaddr);
endfunction

function int reconfig(input int min=5,
                      input int max=5);
    rand_vld rg;
    rg = new(min,max);
    a_vld:assert(rg.randomize())
    else $error("reconfiguration failed at time: %t, testcase file: %s",$time,filename);
    if(rg.p>0)
        reconfig = rg.p-1;
    else
        reconfig = rg.p;
    rg = null;
endfunction

always @( posedge clk or negedge rst_n ) begin
if( !rst_n ) begin
    init(filename);
    output_cnt <= reconfig(0,0);
    end
    else begin
        if(timer_en) begin
            if(read_data_num==0) begin
                data_output_done <= 1'b1;
                vld <= 1'b0;
                if(data_output_done==0) begin
                    $display("data from testcase file: %s has all been outputed at time: %t",filename,$time);
                end
            end
            else begin
                if(output_cnt==0) begin
                    if(max_non_vld==0) begin
                        output_cnt <= reconfig(min_vld,max_vld);
                        vld <= 1'b1;
                        data_o <= data_bank.pop_back;
                        read_data_num--;
                    end
                    else if(max_vld==0) begin
                        output_cnt <= reconfig(min_non_vld,max_non_vld);
                        vld <= 1'b0;
                    end
                    else begin
                        if(vld==0) begin
                            output_cnt <= reconfig(min_vld,max_vld);
                            vld <= 1'b1;
                            data_o <= data_bank.pop_back;
                            read_data_num--;
                        end
                        else begin
                            output_cnt <= reconfig(min_non_vld,max_non_vld);
                            vld <= 1'b0;
                        end
                    end
                end
                else if(vld==1) begin
                    vld <= 1'b1;
                    data_o <= data_bank.pop_back;
                    read_data_num--;
                    output_cnt--;
                end
                else begin
                    output_cnt--;
                end
            end
        end
    end
end

assign timer_en = (vld & rdy) || ~vld;

endmodule
