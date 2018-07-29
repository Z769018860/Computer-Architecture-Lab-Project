`timescale 1ns / 1ps
`define COMPLETE_CNT 33
module my_divider(
    input div_clk,
    input resetn,
    input div,
    input div_signed,
    input [31:0]x,
    input [31:0]y,
    output wire  [31:0]s,
    output wire  [31:0]r,
    output complete
    );
    
reg [1:0]sign_table; 
wire [32:0] ex_x, ex_y;
wire [32:0] abs_x, abs_y;
wire s_sign, r_sign;
reg [65:0] dividend;
reg [33:0] divisor;
reg [5:0]counter;
reg div_run;
reg [32:0]quotient;
wire [33:0]temp_dividend;
wire neg;
wire [32:0]ex_s;
wire [32:0]ex_r;
wire no_shift;
assign ex_x = {div_signed & x[31],x[31:0]};
assign ex_y = {div_signed & y[31],y[31:0]};
assign abs_x = (ex_x[32])? (~ex_x + 1):ex_x;
assign abs_y = (ex_y[32])? (~ex_y + 1):ex_y;
//assign  sign_table = {ex_x[32],ex_y[32]};
assign s_sign = (sign_table == 2'b01 || sign_table ==2'b10);
assign r_sign = (sign_table == 2'b10 || sign_table ==2'b11);

assign ex_s = (s_sign)? ~quotient+1 : quotient;
assign s =  ex_s[31:0];
assign ex_r = (r_sign)? ~dividend[64:32]+1: dividend[64:32];
assign r = ex_r[31:0];

assign complete = (counter == `COMPLETE_CNT);
assign no_shift = (counter == `COMPLETE_CNT-1);
always @(posedge div_clk)
begin
    div_run <= (~resetn | complete)? 1'b0:(div)? 1'b1:div_run;
    divisor <= (~resetn | complete)? 34'd0: 
               (~div_run && div)? {1'b0,abs_y[32:0]}:divisor;
    if(div)sign_table <= {ex_x[32], ex_y[32]};
end
 
assign temp_dividend = dividend[65:32] - divisor;
assign neg = temp_dividend[33];
 
always @(posedge div_clk)
begin
    if(~resetn)
    begin
        counter <= 6'b0;
        dividend <= 66'b0;
        quotient <= 33'b0;
    end
    else if(counter < `COMPLETE_CNT) //这里先随便写一个数字 之后再改!!!
    begin
        counter <= (div_run & ~complete)? counter+6'b1: 6'b0;
        dividend <= (~div_run && div)? {33'b0, abs_x[32:0]}:
                      ({66{(neg & no_shift)}}  & dividend)
                     |({66{(~neg & no_shift)}} & {temp_dividend[33:0],dividend[31:0]})
                     |({66{(neg &~no_shift)}}  & dividend << 1)
                     |({66{(~neg &~no_shift)}} & {temp_dividend[33:0],dividend[31:0]}<<1);
                  
        quotient <= (~div_run && div)? 33'b0:
                    ({33{(neg & no_shift)}}  & quotient)
                   |({33{(~neg & no_shift)}} & {quotient[32:1],1'b1})
                   |({33{(neg &~no_shift)}}  & {quotient[32:1],1'b0}<<1)
                   |({33{(~neg &~no_shift)}} & {quotient[32:1],1'b1}<<1);
    end
    else if(counter == `COMPLETE_CNT)
    begin
        counter <= 6'b0;
    end
end
    
endmodule



module My_divider(
    input div_clk,
    input div_resetn,
    input [31:0] divisor,
    input [31:0] dividend,
    input div_signed,
    input div_valid,
    output div_ready,
    output div_complete,
    output [31:0] div_rem,
    output [31:0] div_quo
);
reg ready_r;
always @(posedge div_clk)
begin
    ready_r <= (~div_resetn)? 1'b1:
                (div_complete)? 1'b1:
                (ready_r && div_valid)? 1'b0:ready_r;  
end
assign div_ready = ready_r;

my_divider div (
    .div_clk(div_clk),
    .resetn(div_resetn),
    .div(div_valid & ready_r),
    .div_signed(div_signed),
    .x(dividend),
    .y(divisor),
    .s(div_quo),
    .r(div_rem),
    .complete(div_complete)
);


endmodule