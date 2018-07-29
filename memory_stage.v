module memory_stage(
    input wire      clk,
    input wire      rst,
    input wire      exe_Abortion,
    input wire      inst_wait,
    //input wire [1:0] exe_out_PC_src,
    //input wire [1:0] exe_out_Write_dest,
    input wire       exe_out_Reg_write,
    //input wire       exe_out_ALU_srcA,
    //input wire       exe_out_ALU_srcB,
    //input wire [3:0] exe_out_Mem_en,
    //input wire [2:0] exe_out_ALU_op,
    //input wire       exe_out_Branch,
    input wire [1:0] exe_out_Data_src,
    //input wire       exe_out_Jump_src,
    input wire       exe_out_Mem_read,
    //input wire       exe_out_Mem_write,
    input wire       exe_out_MUL,
    input wire [31:0] debug_pc_exe_out,//debug
    
    input wire [31:0] exe_ALU_out,
    //input wire [31:0] exe_out_mem_data,
    input wire [31:0] exe_to_mem_rdata2,
    input wire [4:0] exe_out_write_reg,
    input wire [31:0] exe_out_pc_plus_8,
    input wire  [1:0] exe_RW_HL,
    input wire        exe_HL_en,
    
    input wire [31:0] mem_in_data,//data ram
  
    //output wire [31:0] align_mem_address,//data ram
    //output wire [31:0] mem_data,//data ram 
    //output wire [3:0] out_Mem_en,//data ram
    output reg [4:0] mem_write_reg,
    output wire [31:0] mem_out_data_write_back,

    output reg [31:0] debug_pc_mem_out,

    //output wire [1:0] mem_out_PC_src,
    //output wire [1:0] mem_out_Write_dest,
    output wire       mem_out_Reg_write,
    //output wire       mem_out_ALU_srcA,
    //output wire       mem_out_ALU_srcB,
    //output wire [3:0] mem_out_Mem_en,
    //output wire [2:0] mem_out_ALU_op,
    //output wire       mem_out_Branch,
    //output wire [1:0] mem_out_Data_src,
    //output wire       mem_out_Jump_src
    //output reg         mem_out_MUL,
    output reg   [1:0] mem_RW_HL,
    output reg         mem_HL_en,
    input  wire  [2:0] exe_to_mem_Unalign_l,
    //output wire mem_access,
    output wire mem_invalid
    //input  wire  exception,
    //input  wire  exe_Abortion
    //input  wire  exe_jorbran
    //output reg  mem_jorbran
);

//reg [1:0] mem_PC_src;
//reg [1:0] mem_Write_dest;
reg       mem_Reg_write;
//reg       mem_ALU_srcA;
//reg       mem_ALU_srcB;
//reg [2:0] mem_ALU_op;
//reg       mem_Branch;
reg [1:0] mem_Data_src;
//reg       mem_Jump_src;

reg [31:0] mem_ALU_out;
reg [31:0] mem_pc_plus_8;

wire [31:0] data_write_back_mux;
reg [31:0] rf_rdata2;

wire raddr_00, raddr_01, raddr_10, raddr_11;
wire LW_wen, LB_wen, LBU_wen, LH_wen, LHU_wen, LWL_wen, LWR_wen;
wire [31:0] LB_wdata, LBU_wdata, LH_wdata, LHU_wdata, LWL_wdata, LWR_wdata;
wire [31:0] unalign_ldata;
reg  [2:0] mem_Unalign_l;
reg  [31:0] mem_data_r;
always@(posedge clk)
begin
  //mem_PC_src <= (rst)? 2'b0 : exe_out_PC_src;
  //mem_Write_dest <= (rst)? 2'b0 : exe_out_Write_dest;
  mem_Reg_write <= (rst)? 1'b0 : (inst_wait)? mem_Reg_write : (exe_Abortion)? 1'b0 : exe_out_Reg_write;
  //mem_ALU_srcA <= (rst)? 1'b0 : exe_out_ALU_srcA;
  //mem_ALU_srcB <= (rst)? 1'b0 : exe_out_ALU_srcB;
  //mem_ALU_op <= (rst)? 2'b0 : exe_out_ALU_op;
  //mem_Branch <= (rst)? 1'b0 : exe_out_Branch;
  mem_Data_src <= (rst )? 2'b0 : (inst_wait)? mem_Data_src : (exe_Abortion)? 2'b0 : exe_out_Data_src;
  //mem_Jump_src <= (rst)? 1'b0 : exe_out_Jump_src;

  mem_ALU_out <= (rst )? 32'b0 : (inst_wait)? mem_ALU_out :(exe_Abortion)? 32'b0: exe_ALU_out;
  mem_pc_plus_8 <= (rst )? 32'b0 : (inst_wait)?mem_pc_plus_8 : (exe_Abortion)?32'b0: exe_out_pc_plus_8;
  mem_write_reg <= (rst )? 5'b0 : (inst_wait)? mem_write_reg :(exe_Abortion)? 5'b0: exe_out_write_reg;

  debug_pc_mem_out <= (rst )? 32'b0: (inst_wait)? debug_pc_mem_out :(exe_Abortion)? 32'b0: debug_pc_exe_out;
  //mem_out_MUL <= (rst )? 1'b0: (inst_wait)? mem_out_MUL: (exe_Abortion)? 1'b0:exe_out_MUL;
  mem_RW_HL <= (rst )? 2'b0: (inst_wait)?mem_RW_HL : (exe_Abortion)? 2'b0: exe_RW_HL;
  mem_HL_en <= (rst )? 1'b0:(inst_wait)? mem_HL_en : (exe_Abortion)? 1'b0:exe_HL_en ;

  rf_rdata2 <= (rst )? 32'b0 :(inst_wait)? rf_rdata2 : (exe_Abortion)? 32'b0:exe_to_mem_rdata2;
  mem_Unalign_l <= (rst )? 3'b0 : (inst_wait)? mem_Unalign_l : (exe_Abortion)? 3'b0:exe_to_mem_Unalign_l;
  //to imply whether exception happens in delay slot
  //mem_jorbran <= (rst?) 1'b0:exe_jorbran; 
  mem_data_r <= (rst)? 32'b0: (inst_wait)? mem_data_r :(exe_Abortion)? 32'b0: mem_in_data;

end

//assign align_mem_address={exe_out_mem_address[31:2], 2'b00}; //RAM32λ����
//assign mem_data=exe_out_mem_data;
//assign out_Mem_en=exe_out_Mem_en;


assign data_write_back_mux = {32{mem_Data_src == 2'b00}} & (mem_data_r)
                            |{32{mem_Data_src == 2'b01}}& (mem_ALU_out)
                            |{32{mem_Data_src ==2'b10}} & (mem_pc_plus_8)
                            |{32{mem_Data_src ==2'b11}} & (unalign_ldata);


assign mem_out_data_write_back=data_write_back_mux;
assign mem_out_Reg_write=mem_Reg_write;


assign raddr_00 = mem_ALU_out[1:0] == 2'b00;
assign raddr_01 = mem_ALU_out[1:0] == 2'b01;
assign raddr_10 = mem_ALU_out[1:0] == 2'b10;
assign raddr_11 = mem_ALU_out[1:0] == 2'b11;

assign LW_wen = mem_Unalign_l == 3'b000 && mem_Reg_write;
assign LB_wen = mem_Unalign_l == 3'b001;
assign LBU_wen = mem_Unalign_l == 3'b010;
assign LH_wen = mem_Unalign_l == 3'b011;
assign LHU_wen = mem_Unalign_l == 3'b100;
assign LWL_wen = mem_Unalign_l == 3'b101;
assign LWR_wen = mem_Unalign_l == 3'b110;

assign LB_wdata = {32{raddr_00}} & {{24{mem_data_r[7]}}, mem_data_r[7:0]}
                 |{32{raddr_01}} & {{24{mem_data_r[15]}}, mem_data_r[15:8]}
                 |{32{raddr_10}} & {{24{mem_data_r[23]}}, mem_data_r[23:16]}
                 |{32{raddr_11}} & {{24{mem_data_r[31]}}, mem_data_r[31:24]};
                 
assign LBU_wdata = {32{raddr_00}} & {24'b0, mem_data_r[7:0]}
                  |{32{raddr_01}} & {24'b0, mem_data_r[15:8]}
                  |{32{raddr_10}} & {24'b0, mem_data_r[23:16]}
                  |{32{raddr_11}} & {24'b0, mem_data_r[31:24]};

assign LH_wdata = {32{raddr_00}} & {{16{mem_data_r[15]}}, mem_data_r[15:0]}
                 |{32{raddr_10}} & {{16{mem_data_r[31]}}, mem_data_r[31:16]};
    
assign LHU_wdata = {32{raddr_00}} & {16'b0, mem_data_r[15:0]}
                 |{32{raddr_10}} & {16'b0, mem_data_r[31:16]};   



assign LWL_wdata = {32{raddr_00}} & {mem_data_r[7:0],rf_rdata2[23:0]} 
                 |{32{raddr_01}} & {mem_data_r[15:0], rf_rdata2[15:0]}
                 |{32{raddr_10}} & {mem_data_r[23:0], rf_rdata2[7:0]}
                 |{32{raddr_11}} & mem_data_r[31:0];

assign LWR_wdata = {32{raddr_00}} & mem_data_r[31:0]
                  |{32{raddr_01}} & {rf_rdata2[31:24], mem_data_r[31:8]}
                  |{32{raddr_10}} & {rf_rdata2[31:16], mem_data_r[31:16]}
                  |{32{raddr_11}} & {rf_rdata2[31:8], mem_data_r[31:24]};

assign unalign_ldata = {32{LB_wen}} & LB_wdata
                      |{32{LBU_wen}}& LBU_wdata
                      |{32{LH_wen}} & LH_wdata
                      |{32{LHU_wen}}& LHU_wdata
                      |{32{LWL_wen}}& LWL_wdata
                      |{32{LWR_wen}}& LWR_wdata;
//handle exception


//handle exception end

//assign mem_access = exe_out_Mem_write | exe_out_Mem_read;
assign mem_invalid = ~(rst || exe_Abortion) && inst_wait;
endmodule