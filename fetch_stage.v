
module fetch_stage(
    input  wire        clk,
    input  wire        rst,
    input  wire        block,
    input  wire   [31:0] next_pc,
    output wire   [31:0] PC_plus_4,
    output reg    [31:0] fe_pc,           //fetch_stage pc
    output fe_Abortion
);
assign PC_plus_4 = fe_pc + 4;
assign fe_Abortion = 1'b0;
always @(posedge clk)
begin
  fe_pc <= (rst)? 32'hbfc00000: (block)? fe_pc: next_pc;
end

endmodule //fetch_stage
