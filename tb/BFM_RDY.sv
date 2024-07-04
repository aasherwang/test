class rand_rdy;
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

module BFM_RDY#(
    parameter module_name = "bfm_rdy"
)
(
    input bit clk,
    input bit rst_n,
    input bit vld,
    output bit rdy,
    input int min_rdy,
    input int max_rdy,
    input int min_non_rdy,
    input int max_non_rdy
);

bit timer_en;
int output_cnt;

function void init();
        //variable init
        output_cnt = 0;
        //output signal init
        rdy = 1'b0;
endfunction

function int reconfig(input int min=5,
                      input int max=5);
        rand_rdy rg;
        rg = new(min,max);
        a_rdy: assert(rg.randomize())
        else $error("reconfiguration fail at time: %t,module name: %s",$time,module_name);
        if(rg.p>0)
            reconfig = rg.p-1;
        else
            reconfig = rg.p;
        rg = null;
endfunction

always @( posedge clk or negedge rst_n ) begin
        if( !rst_n ) begin
            init();
            output_cnt <= reconfig(0,0);
            end
            else begin
                if(timer_en) begin
                    if(output_cnt==0) begin
                        if(max_non_rdy==0) begin
                        rdy <= 1'b1;
                        output_cnt <= reconfig(min_rdy,max_rdy);
                end
                else if(max_rdy==0) begin
                    rdy <= 1'b0;
                    output_cnt <= reconfig(min_rdy,max_rdy);
                end
                else begin
                    if(rdy==0) begin
                        rdy <= 1'b1;
                        output_cnt <= reconfig(min_rdy,max_rdy);
                    end
                    else begin
                        rdy  <= 1'b0;
                        output_cnt <= reconfig(min_non_rdy,max_non_rdy);
                    end
                end
            end
            else begin
                output_cnt--;
            end
        end
    end
end

assign timer_en = (vld & rdy) || ~rdy;

endmodule
