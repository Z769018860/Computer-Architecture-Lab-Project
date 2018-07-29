module writeback_stage(
    input wire      clk,
    input wire      rst,
    input wire      inst_wait,
    input wire      wb_block,
    input wire      mem_invalid,
    input wire       mem_out_Reg_write,
    //input wire mem_out_MUL,
    input wire [31:0] debug_pc_mem_out,
    //input wire [1:0]  mem_RW_HL,
    //input wire        mem_HL_en,

    input wire [4:0] mem_dest,
    input wire [31:0] mem_value,

    output wire wb_rf_wen,
    output wire [4:0] wb_rf_waddr,
    output wire [31:0] wb_rf_wdata,

    output reg [31:0] debug_pc_wb_out,
    //output reg wb_MUL,
    //output reg [1:0]  wb_RW_HL,
    //output reg wb_HL_en,
    output wire [3:0] debug_Reg_write
);


reg       wb_Reg_write;


reg [4:0] wb_dest;
reg [31:0] wb_value;
reg write_enable;
always@(posedge clk)
begin

wb_Reg_write <= (rst )? 1'b0 :(inst_wait)? 1'b0 : mem_out_Reg_write;
wb_dest <= (rst)? 5'b0 : (inst_wait)? wb_dest : mem_dest;
wb_value <= (rst)? 32'b0 : (inst_wait)? wb_value : mem_value;

debug_pc_wb_out <= (rst)? 32'hbfc00000: (inst_wait)? debug_pc_wb_out : debug_pc_mem_out;
//wb_RW_HL <= (rst||mem_invalid)? 2'b0:(inst_wait)? wb_RW_HL : mem_RW_HL;
//wb_HL_en <= (rst||mem_invalid)? 1'b0: (inst_wait)? wb_HL_en : mem_HL_en;
//write_enable <= (rst)? 1'b0: (write_enable & )  

end   

assign wb_rf_wen=wb_Reg_write &&(debug_pc_wb_out != debug_pc_mem_out);
assign wb_rf_waddr=wb_dest;
assign wb_rf_wdata=wb_value;
assign debug_Reg_write = {4{wb_rf_wen}};
endmodule  