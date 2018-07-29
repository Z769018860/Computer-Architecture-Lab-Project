
`define ZERO_5 5'b00000

`define ADDIU_opcode 6'b001001
`define LW_opcode 6'b100011
`define SW_opcode 6'b101011
`define BNE_opcode 6'b000101//if rs != rt then branch
`define BEQ_opcode 6'b000100///if rs = rt then branch
`define J_opcode 6'b000010//jump target
`define JAL_opcode 6'b000011//I: GPR[31]?? PC + 8 ; I+1:PC ?? PCGPRLEN..28 || instr_index || 02
`define SLTI_opcode 6'b001010
`define SLTIU_opcode 6'b001011
`define LUI_opcode 6'b001111
`define ADDI_opcode 6'b001000
`define ANDI_opcode 6'b001100
`define ORI_opcode 6'b001101
`define XORI_opcode 6'b001110
`define BGTZ_opcode 6'b000111
`define BLEZ_opcode 6'b000110
`define LB_opcode 6'b100000
`define LBU_opcode 6'b100100
`define LH_opcode 6'b100001
`define LHU_opcode 6'b100101
`define LWL_opcode 6'b100010
`define LWR_opcode 6'b100110
`define SB_opcode 6'b101000
`define SH_opcode 6'b101001
`define SWL_opcode 6'b101010
`define SWR_opcode 6'b101110



`define REGIMM_opcode 6'b000001
    `define BGEZ_rtcode 5'b00001//�����ź�[20:16],00001
    `define BLTZ_rtcode 5'b00000//�����ź�[20:16],00000
    `define BGEZAL_rtcode 5'b10001//�����ź�[20:16],10001
    `define BLTZAL_rtcode 5'b10000//�����ź�[20:16],10000


`define SPECIAL_opcode 6'b000000
    `define ADD_func_code 6'b100000
    `define ADDU_func_code 6'b100001
    `define SUB_func_code 6'b100010
    `define SUBU_func_code 6'b100011
    `define AND_func_code 6'b100100
    `define OR_func_code 6'b100101
    `define SLT_func_code 6'b101010
    `define SLL_func_code 6'b000000
    `define JR_func_code 6'b001000
    `define SLTU_func_code 6'b101011
    `define ADD_func_code 6'b100000
    `define SUB_func_code 6'b100010
    `define SUBU_func_code 6'b100011
    `define AND_func_code 6'b100100
    `define NOR_func_code 6'b100111
    `define XOR_func_code 6'b100110
    `define SLLV_func_code 6'b000100
    `define SRA_func_code 6'b000011
    `define SRAV_func_code 6'b000111
    `define SRL_func_code 6'b000010
    `define SRLV_func_code 6'b000110
    `define DIV_func_code 6'b011010
    `define DIVU_func_code 6'b011011
    `define MULT_func_code 6'b011000
    `define MULTU_func_code 6'b011001
    `define MFHI_func_code 6'b010000
    `define MFLO_func_code 6'b010010
    `define MTHI_func_code 6'b010001
    `define MTLO_func_code 6'b010011
    `define JALR_func_code 6'b001001

    `define ERET_func_code 6'b011000
    `define SYSCALL_func_code 6'b001100
    `define BREAK_func_code 6'b001101
    `define TLBP_func_code 6'b001000
    `define TLBR_func_code 6'b000001
    `define TLBWI_func_code 6'b000010


`define COP0_opcode 6'b010000
    `define MF_rscode 5'b00000
    `define MT_rscode 5'b00100
    `define CO_rscode 5'b10000


`define CP0_EPC 5'd14
`define EXCEPTION_ENTRY 32'hbfc00380
`define TLB_REFILL_ENTRY 32'hbfc00200

`define EX_INTR 0
`define EX_INST_READ 1
`define EX_RI 2
`define EX_OVER 3
`define EX_BREAK 4
`define EX_SYS 5
`define EX_DATA_READ 6
`define EX_DATA_WRITE 7
`define EX_INST_TLBL 8
`define EX_DATA_TLBL 9
`define EX_DATA_TLBS 10
`define EX_TLB_MOD 11
`define EXCEPTION_NUM 12


module decode_stage(
    input  wire        clk,
    input  wire        rst,
    input  wire        block,
    input  wire [31:0] inst_in,
    //input  wire [31:0] fe_PC_in,
    output wire [ 4:0] de_rf_raddr1,
    input  wire [31:0] de_rf_rdata1,
    output wire [ 4:0] de_rf_raddr2,
    input  wire [31:0] de_rf_rdata2,

    input  wire [31:0] HL_rdata,

    //input  wire [31:0] PC_plus_4,
    //output wire [31:0] de_branch_out,
    //output wire [31:0] de_jump_out,
    output wire [ 4:0] de_write_reg_dest,         //reg num of dest operand, zero if no dest
    output wire [31:0] de_srcA_value,        //value of source operand 1
    output wire [31:0] de_srcB_value,        //value of source operand 2
    output wire [31:0] de_st_value,      //value stored to memory
    output wire [31:0] de_PC_plus_8,
    output wire [31:0] de_out_debug_PC,
    output wire [31:0] next_pc,
    /*control signal from ControlUnit*/
    //output wire [1:0] de_PC_src,
    //output wire [1:0] de_Write_dest,
    output wire       de_Reg_write,

    output wire        de_Mem_write, // SRAM enable 4-bit
    output wire [ 3:0] de_ALU_op,

    output wire [ 1:0] de_Data_src,

    //output wire       de_Read_reg1,
    //output wire       de_Read_reg2,
    output wire       de_Mem_read,

    output wire de_HL_en,
    //output wire [31:0] de_HL_rdata,
    output wire [ 1:0] de_RW_HL,
    output wire de_MUL,
    output wire de_DIV,
    output wire de_Sign,
    output wire [2:0] de_Unalign_l,
    output wire [2:0] de_Unalign_s, 
    
    //CP0 registers ports
    output wire [4:0] de_cp0_raddr,
    input  wire [31:0]de_cp0_rdata,
    output wire [4:0] de_cp0_waddr,
    output  wire [31:0]de_cp0_wdata,
    output wire de_cp0_wen, 
    //output wire 

    //exception and interruption signals and data
    //input  wire [31:0] inst_sram_addr,
    input  wire exception,
    input  wire exe_ERET,
    input  wire [31:0] cp0_epc,
    //output wire syscall, 
    output wire de_jorbran,
    output wire de_Abortion,
    output wire [`EXCEPTION_NUM-1:0]de_exbit,
    output wire de_Overflow_en,
    output wire de_ERET,
    // jump or branch in decode means delay slot in fetch
    output wire de_inst_fetch,
    //output wire PC_jorbran
    output wire de_TLBP,
    output wire de_TLBR,
    output wire de_TLBWI,
    //TLB exception
    input  wire fe_tlb_miss,
    input  wire fe_tlb_invalid,
    input  wire pcmux_tlbref,

    output wire de_tlb_miss,
    output wire de_tlb_invalid
    //TLB exception end
);
/*
`ifndef SIMU_DEBUG
reg  [31:0] de_inst;        //instr code @decode stage
`endif
*/
 reg [31:0] de_PC;
 reg [31:0] de_inst;
 reg de_tlb_miss_r;
 reg de_tlb_invalid_r;
//branch


//wire [31:0] jump_imm;
//wire [31:0] jump_reg;
wire [31:0] offset_mux;
wire branch_taken;
wire [31:0] true_offset;
wire [31:0] sign_ex_imm;
wire [31:0] zero_ex_imm;
wire [1:0] de_Write_dest;
wire       de_ALU_srcA;
wire [2:0] de_ALU_srcB;
//wire [2:0] de_Branch;
wire       de_Jump_src;
wire [4:0] de_rs, de_rt, de_rd;
wire BEQ, BNE, BGEZ, BGTZ, BLTZ, BLEZ;
wire br_euqal, br_zero, br_lt_zero;
wire [1:0] PC_src;
wire [31:0] de_jump_reg;
wire ERET, de_Jump_epc;
//wire ex_sign;
wire syscall, break;
wire de_RI_signal;
wire [31:0] pc_plus_4;
assign de_ERET = ERET;
assign de_rd = de_inst[15:11];
assign de_rs = de_inst[25:21];
assign de_rt = de_inst[20:16];

assign de_PC_plus_8 = de_PC + 32'd8;
assign de_srcA_value = ({32{de_ALU_srcA}} & de_inst) 
                    | ({32{~de_ALU_srcA}} & de_rf_rdata1);
assign de_srcB_value = ({32{de_ALU_srcB == 3'b001}} & sign_ex_imm)
                      |({32{de_ALU_srcB == 3'b000}}& de_rf_rdata2)
                      |({32{de_ALU_srcB == 3'b010}}& zero_ex_imm)
                      |({32{de_ALU_srcB == 3'b011}}& HL_rdata)
                      |({32{de_ALU_srcB == 3'b100}}& de_cp0_rdata);


assign de_write_reg_dest = ({5{de_Write_dest == 2'b00}} & de_rt)
                         | ({5{de_Write_dest == 2'b01}} & de_rd)
                         | ({5{de_Write_dest == 2'b10}} & 5'd31);
assign de_st_value = de_rf_rdata2;
assign de_out_debug_PC = de_PC;

assign de_inst_fetch = ~(rst|block);
assign de_tlb_miss = de_tlb_miss_r;
assign de_tlb_invalid = de_tlb_invalid_r;
always @(posedge clk)
  begin
    de_PC <= (rst)? 32'hbfbffffc:(block)? de_PC :(exception|exe_ERET)? 32'b0: next_pc;
    de_inst <= (rst)? 32'b0 : (block)? de_inst :(exception|exe_ERET)? 32'b0: inst_in;
    de_tlb_miss_r <= (rst)? 1'b0:(block)? de_tlb_miss_r:(exception|exe_ERET)? 1'b0:fe_tlb_miss;
    de_tlb_invalid_r <= (rst)? 1'b0: (block)? de_tlb_invalid_r: (exception|exe_ERET)? 1'b0: fe_tlb_invalid;
    //inst_in <= (rst)? 32'b0: (block)? inst_in : inst_in;
  end

assign true_offset = {sign_ex_imm[29:0],2'b00} + 32'd4;
assign sign_ex_imm = {{16{de_inst[15]}}, de_inst[15:0]};
assign zero_ex_imm = {16'b0, de_inst[15:0]};

//NOTE: now we use normal cp0 ports to transfer cp0_epc
assign de_jump_reg = (de_Jump_epc)? de_cp0_rdata:de_rf_rdata1;
assign de_jorbran = (|PC_src);

//CP0 register ports control 
//NOTE: special implementation
assign de_cp0_raddr = (ERET)? `CP0_EPC:de_rd; 
assign de_cp0_wdata = de_srcB_value;
assign de_cp0_waddr = de_rd;
assign de_Abortion = exception | exe_ERET;

//CP0 end

//handle_exception
assign de_exbit[`EX_INST_READ] = (de_out_debug_PC[1:0] != 2'b0)? 1'b1: 1'b0;
assign de_exbit[`EX_RI] = de_RI_signal;
assign de_exbit[`EX_BREAK] = break; 
assign de_exbit[`EX_SYS] = syscall;
assign de_exbit[`EX_INST_TLBL] = de_tlb_miss | de_tlb_invalid;

assign de_exbit[`EX_INTR] = 1'b0;
assign de_exbit[`EX_OVER] = 1'b0;
assign de_exbit[`EX_DATA_READ] = 1'b0;
assign de_exbit[`EX_DATA_WRITE] = 1'b0;
assign de_exbit[`EX_DATA_TLBL] = 1'b0;
assign de_exbit[`EX_DATA_TLBS] = 1'b0;
assign de_exbit[`EX_TLB_MOD] = 1'b0;

assign pc_plus_4 = de_out_debug_PC + 32'd4;

//handle_exception end


//--------------second clk-------------------  

//we calculate the new pc in the second phase 
reg [31:0] jump_imm_r;
reg [31:0] jump_reg_r;
reg de_Jump_src_r;
reg BEQ_r, BNE_r, BGEZ_r, BGTZ_r, BLEZ_r, BLTZ_r;
reg [31:0] true_offset_r;
reg [31:0] de_rf_rdata1_r, de_rf_rdata2_r;
reg [31:0] de_PC_r;
reg [1:0]  PC_src_r;
wire [31:0] PC_jump, PC_branch;
wire [31:0] PC_mux;
reg [31:0] PC_except;
//jump start
always @(posedge clk)
begin
    jump_imm_r <= (block)? jump_imm_r:{de_PC[31:28],de_inst[25:0],2'b00};
    jump_reg_r <= (block)? jump_reg_r : de_jump_reg;
    //jump_reg_r <= (block)? jump_reg_r : de_rf_rdata1;
    de_rf_rdata1_r <= (block)? de_rf_rdata1_r:de_rf_rdata1;
    de_rf_rdata2_r <= (block)? de_rf_rdata2_r:de_rf_rdata2;
    de_Jump_src_r <= (block)? de_Jump_src_r:de_Jump_src;
    {BEQ_r,BNE_r,BGEZ_r,BGTZ_r,BLEZ_r,BLTZ_r} <=
                (block)? {BEQ_r,BNE_r,BGEZ_r,BGTZ_r,BLEZ_r,BLTZ_r}:
                {BEQ,BNE,BGEZ,BGTZ,BLEZ,BLTZ};
    de_PC_r <= (block)? de_PC_r:de_PC;
    true_offset_r <= (block)? true_offset_r : true_offset;
    PC_src_r <= (rst)? 2'b00 : (block)? PC_src_r : (exception | exe_ERET)? 2'b11 : PC_src;
end
assign PC_jump = ({32{de_Jump_src_r}} & jump_reg_r) 
                    | ({32{~de_Jump_src_r}} & jump_imm_r);
//jump end


//branch start
assign offset_mux = ({32{branch_taken}} & true_offset_r)
                   |({32{~branch_taken}} & 32'd8);
assign branch_taken = BEQ_r & (br_euqal)
                     |BNE_r & ~(br_euqal)
                     |BGEZ_r & (br_zero | ~br_lt_zero)
                     |BGTZ_r & (~br_lt_zero & ~br_zero)
                     |BLEZ_r & (br_zero | br_lt_zero)
                     |BLTZ_r & (br_lt_zero);

assign br_euqal = (de_rf_rdata1_r == de_rf_rdata2_r);
assign br_zero = ~|de_rf_rdata1_r;
assign br_lt_zero = de_rf_rdata1_r[31];   //signed number
assign PC_branch = de_PC_r + offset_mux;



assign PC_mux = ({32{PC_src_r == 2'b00}} & (pc_plus_4))
                |({32{PC_src_r == 2'b01}} & (PC_jump))
                |({32{PC_src_r == 2'b10}} & (PC_branch))
                |({32{PC_src_r ==2'b11}} & (PC_except));
//assign PC_jorbran = |PC_src_r;

//assign context_pc = (rst)? 32'hbfc00000: (block)? fe_PC_in : PC_mux;
//assign next_pc = (rst)? 32'hbfc00000 :(exception)? 32'hbfc00380 : (exe_ERET)? cp0_epc : PC_mux;
assign next_pc = (rst)? 32'hbfc00000:PC_mux;
always @(posedge clk)
begin
    PC_except <= (block)? PC_except : (pcmux_tlbref)? 32'hbfc00200 : (exception)? 32'hbfc00380 : (exe_ERET)? cp0_epc : 32'hbfc00380;
end
//assign PC_except = (exception)?32'hbfc00380 : (exe_ERET)? cp0_epc : 32'hbfc00380 ; 
//branch end






ControlUnit ctrl_unit(
  .inst(de_inst),
  .Jump_src(de_Jump_src),
  .PC_src(PC_src),
  .Write_dest(de_Write_dest),
  .Mem_write(de_Mem_write),
  .Reg_write(de_Reg_write),
  .ALU_op(de_ALU_op),
  .ALU_srcA(de_ALU_srcA),
  .ALU_srcB(de_ALU_srcB),
  //.Branch(de_Branch),
  .Data_src(de_Data_src),
  //.Read_reg1(de_Read_reg1),
  //.Read_reg2(de_Read_reg2),
  .Mem_read(de_Mem_read),
  .BEQ_br(BEQ),
  .BNE_br(BNE),
  .BGEZ_br(BGEZ),
  .BGTZ_br(BGTZ),
  .BLEZ_br(BLEZ),
  .BLTZ_br(BLTZ),
  .RW_HL(de_RW_HL),
  .HL_en(de_HL_en),
  .MUL_en(de_MUL),
  .DIV_en(de_DIV),
  .Sign(de_Sign),
  .Unalign_l(de_Unalign_l),
  .Unalign_s(de_Unalign_s),
  .Jump_epc(de_Jump_epc),
  .CP0_write(de_cp0_wen),
  .SYSCALL(syscall),
  .BREAK(break),
  .ERET(ERET),
  .RI(de_RI_signal),
  .Overflow_en(de_Overflow_en),
  .TLBP(de_TLBP),
  .TLBR(de_TLBR),
  .TLBWI(de_TLBWI)
);

assign de_rf_raddr1 = de_rs;
assign de_rf_raddr2 = de_rt;




endmodule //decode_stage


module ControlUnit(//CPU??????
    input   [31:0] inst,
    output  Jump_src,
    output  [1:0] PC_src,
    output  [1:0] Write_dest,
    output  Mem_write,
    output  Reg_write,
    output  [3:0]ALU_op,
    output  [2:0]ALU_srcB,
    output  ALU_srcA,
    output  [1:0]Data_src,
    //output  [2:0]Branch,
    output  Mem_read,
    output  BEQ_br,
    output  BNE_br,
    output  BGEZ_br,
    output  BGTZ_br,
    output  BLEZ_br,
    output  BLTZ_br,
    output  [1:0] RW_HL,
    output  HL_en,
    output  MUL_en,
    output  DIV_en,
    output  Sign,
    output  [2:0] Unalign_l,
    output  [2:0] Unalign_s,
    output  Jump_epc,
    output  CP0_write,
    output  SYSCALL,
    output  BREAK,
    output  ERET,
    output  RI,
    output  Overflow_en,
    output  TLBP,
    output  TLBR,
    output  TLBWI
);
wire [5:0] opcode, func_code;
wire [4:0] rs_code, rt_code, rd_code, reser_code;



//wire [10:3] cp0_reser;
wire [4:0] RS_0, RT_0, RD_0, RESER_0;

wire SPECIAL;
wire ADDIU, LW, SW, BEQ, BNE, ADDU, J, JAL, JR, LUI, SLL, SLTI, SLTIU, SLT, OR, SLTU;//stage 1
wire ADD, ADDI, SUB, SUBU, AND, ANDI, NOR, ORI, XOR, XORI, SLLV, SRA, SRAV, SRL, SRLV;//stage 2
wire REGIMM, DIV, DIVU, MULT, MULTU, MFHI, MFLO, MTHI, MTLO,BGTZ, BLEZ, BLTZ, BGEZ,  BLTZAL, BGEZAL, JALR;
wire LB, LBU, LH, LHU, LWL, LWR, SB, SH, SWL, SWR;
wire COP0, MFC0, MTC0;
//wire SYSCALL, ERET, BREAK
//wire TLBP, TLBR, TLBWI;

assign opcode     = inst[31:26];
assign func_code  = inst[5:0];
assign rs_code    = inst[25:21];
assign rt_code    = inst[20:16];
assign rd_code    = inst[15:11];
assign reser_code = inst[10:6];





//assign cp0_reser = {reser_code[4:0],func_code[5:3]};

assign REGIMM = (opcode == `REGIMM_opcode);
assign SPECIAL = ~(|opcode);
assign COP0 = (opcode == `COP0_opcode);

assign RS_0 = rs_code == 5'b00000;
assign RT_0 = rt_code == 5'b00000;
assign RD_0 = rd_code == 5'b00000;
assign RESER_0 = reser_code == 5'b00000;

assign ADDIU = (opcode == `ADDIU_opcode)? 1:0;
assign LW = (opcode == `LW_opcode)? 1:0;
assign SW = (opcode == `SW_opcode)? 1:0;
assign BNE = (opcode == `BNE_opcode)? 1:0;
assign BEQ = (opcode == `BEQ_opcode)? 1:0;
assign J = (opcode == `J_opcode)? 1:0;
assign JAL = (opcode == `JAL_opcode)? 1:0;
assign SLTI = (opcode == `SLTI_opcode)? 1:0;
assign SLTIU = (opcode == `SLTIU_opcode)? 1:0;
assign LUI = (opcode == `LUI_opcode && RS_0)? 1:0;
assign ADDI = (opcode == `ADDI_opcode)? 1:0;
assign ANDI = (opcode == `ANDI_opcode)? 1:0;
assign ORI = (opcode == `ORI_opcode)? 1:0;
assign XORI = (opcode == `XORI_opcode)? 1:0;
assign BGTZ = (opcode == `BGTZ_opcode && RT_0)? 1:0;
assign BLEZ = (opcode == `BLEZ_opcode && RT_0)? 1:0;
assign LB = (opcode == `LB_opcode)? 1:0;
assign LBU = (opcode == `LBU_opcode)?1:0;
assign LH = (opcode == `LH_opcode)? 1:0;
assign LHU = (opcode == `LHU_opcode)? 1:0;
assign LWL = (opcode == `LWL_opcode)? 1:0;
assign LWR = (opcode == `LWR_opcode)? 1:0;
assign SB = (opcode == `SB_opcode)? 1:0;
assign SH = (opcode == `SH_opcode)? 1:0;
assign SWL = (opcode == `SWL_opcode)? 1:0;
assign SWR = (opcode == `SWR_opcode)? 1:0;


assign ADDU = (SPECIAL & (func_code == `ADDU_func_code && RESER_0))? 1:0;
assign JR = (SPECIAL & (func_code == `JR_func_code && RT_0 && RD_0))? 1:0;
assign OR = (SPECIAL & (func_code == `OR_func_code && RESER_0))? 1:0;
assign SLL = (SPECIAL & (func_code == `SLL_func_code && RS_0))? 1:0;
assign SLT = (SPECIAL & (func_code == `SLT_func_code && RESER_0))? 1:0;
assign SLTU = (SPECIAL & (func_code == `SLTU_func_code && RESER_0))? 1:0;
assign ADD = (SPECIAL & (func_code == `ADD_func_code && RESER_0))? 1:0;
assign SUB = (SPECIAL & (func_code == `SUB_func_code && RESER_0))? 1:0;
assign SUBU = (SPECIAL & (func_code == `SUBU_func_code && RESER_0))? 1:0;
assign AND = (SPECIAL & (func_code == `AND_func_code && RESER_0))? 1:0;
assign NOR = (SPECIAL & (func_code == `NOR_func_code && RESER_0))? 1:0;
assign XOR = (SPECIAL & (func_code == `XOR_func_code && RESER_0))? 1:0;
assign SLLV = (SPECIAL & (func_code == `SLLV_func_code && RESER_0))? 1:0;
assign SRA = (SPECIAL & (func_code == `SRA_func_code && RS_0))? 1:0;
assign SRAV = (SPECIAL & (func_code == `SRAV_func_code && RESER_0))? 1:0;
assign SRL = (SPECIAL & (func_code == `SRL_func_code && RS_0))? 1:0;
assign SRLV = (SPECIAL & (func_code == `SRLV_func_code && RESER_0))? 1:0;
assign DIV = (SPECIAL & (func_code == `DIV_func_code && RD_0 && RESER_0))? 1:0;
assign DIVU = (SPECIAL & (func_code == `DIVU_func_code && RD_0 && RESER_0))? 1:0;
assign MULT = (SPECIAL & (func_code == `MULT_func_code && RD_0 && RESER_0))? 1:0;
assign MULTU = (SPECIAL & (func_code == `MULTU_func_code && RD_0 && RESER_0))? 1:0;
assign MFHI = (SPECIAL & (func_code == `MFHI_func_code && RS_0 && RT_0 && RESER_0))? 1:0;
assign MFLO = (SPECIAL & (func_code == `MFLO_func_code && RS_0 && RT_0 && RESER_0))? 1:0;
assign MTHI = (SPECIAL & (func_code == `MTHI_func_code && RD_0 && RT_0 && RESER_0))? 1:0;
assign MTLO = (SPECIAL & (func_code == `MTLO_func_code && RD_0 && RT_0 && RESER_0))? 1:0;
assign JALR = (SPECIAL & (func_code == `JALR_func_code && RT_0))? 1:0;
assign SYSCALL = (SPECIAL & (func_code == `SYSCALL_func_code))?1:0;
assign BREAK = (SPECIAL & (func_code == `BREAK_func_code))? 1:0;

assign BGEZ = ((REGIMM) & (rt_code == `BGEZ_rtcode))? 1:0;
assign BLTZ = ((REGIMM) & (rt_code == `BLTZ_rtcode))? 1:0;
assign BGEZAL = ((REGIMM) & (rt_code == `BGEZAL_rtcode))? 1:0;
assign BLTZAL = ((REGIMM) & (rt_code == `BLTZAL_rtcode))? 1:0;

assign MFC0 = (COP0 && rs_code == `MF_rscode && inst[10:3] == 8'b0);
assign MTC0 = (COP0 && rs_code == `MT_rscode && inst[10:3] == 8'b0);
assign ERET = (COP0 && rs_code == `CO_rscode && func_code == `ERET_func_code 
                        && RT_0 && RD_0 && RESER_0);
assign TLBP = (COP0 && rs_code == `CO_rscode  && func_code == `TLBP_func_code && RT_0 && RT_0 && RESER_0);
assign TLBR = (COP0 && rs_code == `CO_rscode  && func_code == `TLBR_func_code && RT_0 && RT_0 && RESER_0);
assign TLBWI = (COP0 && rs_code == `CO_rscode  && func_code == `TLBWI_func_code && RT_0 && RT_0 && RESER_0);
// PC_src: 00:pc+4; 01:jump; 10:branch; 11: 0x380/cp0_epc
assign PC_src[0] = J | JAL | JR | JALR;
assign PC_src[1] = BEQ | BNE | BGEZ | BGTZ | BLEZ | BLTZ | BLTZAL | BGEZAL ;
//assign Write_dest[0] = ADDU | OR | SLT | SLL | SLTU;
//assign Write_dest[1] = JAL;

//Write_dest: 00:rt; 01:rd; 10:31
assign Write_dest = ({2{ ADDU|OR|SLT|SLL|SLTU //inst in stage 1
                    | ADD|SUB|SUBU|AND|NOR|XOR|SLLV|SRA|SRAV|SRL|SRLV //inst in stage 2
                    | MFHI | MFLO}}) & (2'b01) //stage 3
                    |({2{JAL | JALR | BLTZAL | BGEZAL }}) & (2'b10)
                    |({2{MFC0}} & (2'b00))//GPR[rt] �???????? CPR[0,rd,sel]
                    |2'b00;
assign Reg_write = LUI | ADDIU | ADDU | LW | OR | SLT | SLTI  // stage1
                    | SLTIU | SLL | JAL| SLTU //stage 1
                    |ADD|ADDI|SUB|SUBU|AND|ANDI|NOR|ORI|XOR|XORI // stage 2
                    |SLLV|SRA|SRAV|SRL|SRLV //stage2 
                    | JALR | BLTZAL | BGEZAL | MFHI | MFLO//stage3s  
                    | LB | LBU | LH | LHU | LWL | LWR //stage 4
                    | MFC0; //stage 5
assign ALU_srcA = SLL|SRA|SRL;


//ALU_srcB: 000: de_rf_rdata2; 001: sign_ex_imm;
// 010: zero_ex_imm; 011:HL_rdata; 100: de_cp0_rdata
assign ALU_srcB = ({3{LUI | ADDIU | LW | SLTI | SLTIU | SW | ADDI
                    | LB | LBU | LH | LHU | LWL | LWR | SB | SH | SWL | SWR}}) & (3'b001)
                    | ({3{ ANDI | XORI | ORI }}) & 3'b010
                    | ({3{MFHI | MFLO}}) & 3'b011
                    | ({3{MFC0}} & 3'b100)
                    | 3'b000;
                    
assign Mem_write = SW | SB | SH | SWL | SWR;

assign Mem_read = LW | LB | LBU | LH | LHU | LWL | LWR;
assign ALU_op = ({4{LUI}}   & 4'b0101)
               |({4{ADDU}}  & 4'b0010)
               |({4{ADDIU}} & 4'b0010)
               |({4{LW}}    & 4'b0010)
               |({4{OR}}    & 4'b0001)
               |({4{SLT}}   & 4'b0111)
               |({4{SLTI}}  & 4'b0111)
               |({4{SLTIU}} & 4'b0100)
               |({4{SLL}}   & 4'b0011)
               |({4{SW}}    & 4'b0010)
               |({4{SLTU}}  & 4'b0100)
               |({4{ADD}}   & 4'b0010)
               |({4{ADDI}}  & 4'b0010)
               |({4{SUB}}   & 4'b0110)
               |({4{SUBU}}  & 4'b0110)
               |({4{AND}}   & 4'b0000)
               |({4{ANDI}}  & 4'b0000)
               |({4{NOR}}   & 4'b1000)
               |({4{ORI}}   & 4'b0001)
               |({4{XOR}}   & 4'b1001)
               |({4{XORI}}  & 4'b1001)
               |({4{SLLV}}  & 4'b1010)
               |({4{SRA}}   & 4'b1101)
               |({4{SRAV}}  & 4'b1110)
               |({4{SRL}}   & 4'b1011)
               |({4{SRLV}}  & 4'b1100)
               |({4{MFHI}} & 4'b0010)
               |({4{MFLO}} & 4'b0010)
               |({4{MTHI}} & 4'b0010)
               |({4{MTLO}} & 4'b0010)
               |({4{LB}} & 4'b0010)
               |({4{LBU}} & 4'b0010)
               |({4{LH}} & 4'b0010)
               |({4{LHU}} & 4'b0010)
               |({4{LWL}} & 4'b0010)
               |({4{LWR}} & 4'b0010)
               |({4{SB}} & 4'b0010)
               |({4{SH}} & 4'b0010)
               |({4{SWL}} & 4'b0010)
               |({4{SWR}} & 4'b0010)
               |({4{MFC0}}& 4'b0010)
               |4'b0000;
/*
assign Branch = ({3{BEQ}} & 3'b001) // BEQ
              |({3{BNE}} & 3'b010) // BNE
              | 3'b000;
*/
//assign Data_src[0] = LUI | ADDU | ADDIU | OR | SLT | SLTI
//                    | SLTIU | SLL| SLTU;
//assign Data_src[1] = JAL;

//Data_src controls mux in mem stage, deciding which data to write in to regfiles
//00:mem_rdata; 01: alu_out; 10: mem_pc_plus_8; 11:unaligned data
assign Data_src = ({2{LUI | ADDU | ADDIU | OR | SLT | SLTI | SLTIU | SLL| SLTU  //stage 1
                |     ADD|ADDI|SUB|SUBU|AND|ANDI|NOR|ORI|XOR|XORI // stage 2
                |     SLLV|SRA|SRAV|SRL|SRLV// stage 2
                |     MFHI | MFLO | MTHI | MTLO | MFC0}}) & (2'b01) //stage 
                | ({2{ JAL | JALR | BGEZAL | BLTZAL }}) & (2'b10)
                |({2{LB| LBU | LH | LHU | LWL | LWR}}) &(2'b11) //unaligned load 
                | 2'b00;
//Jump_src: 0: Jump imm , 1:Jump reg
assign Jump_src = JR | JALR | ERET;
assign BEQ_br = BEQ;
assign BNE_br = BNE;
assign BGEZ_br = BGEZ | BGEZAL;
assign BGTZ_br = BGTZ;
assign BLEZ_br = BLEZ;
assign BLTZ_br = BLTZ | BLTZAL;

assign RW_HL = ({2{MFHI}}) & (2'b00) //Read HI
                |({2{MFLO}} & (2'b01)) // Read LO
                |({2{MTHI}} & (2'b10)) //Write HI
                |({2{MTLO}} & (2'b11)); // Write LO
assign HL_en = MFHI | MFLO | MTHI | MTLO; //����HI LO ��һ��Ĵ�������????????
assign MUL_en = MULT | MULTU;
assign DIV_en = DIV | DIVU;
assign Sign = MULT | DIV;


// Unalign_l == 3'b000 is reserved for aligned LW
assign Unalign_l = {3{LB}}  & (3'b001)
                  |{3{LBU}} & (3'b010)
                  |{3{LH}}  & (3'b011)
                  |{3{LHU}} & (3'b100)
                  |{3{LWL}} & (3'b101)
                  |{3{LWR}} & (3'b110)
                  |3'b000; //LW

assign Unalign_s = {3{SB}}  & (3'b100)
                  |{3{SH}}  & (3'b101)
                  |{3{SWL}} & (3'b110)
                  |{3{SWR}} & (3'b111)
                  |3'b000;//SW

assign Jump_epc = ERET;
assign CP0_write = MTC0;
assign RI = ~(ADDIU| LW| SW| BEQ| BNE| ADDU| J| JAL| JR| LUI| SLL| SLTI| SLTIU| SLT| OR| SLTU|//stage 1 16
            ADD| ADDI| SUB| SUBU| AND| ANDI| NOR| ORI| XOR| XORI| SLLV| SRA| SRAV| SRL| SRLV|//stage 2 15
            DIV| DIVU| MULT| MULTU| MFHI| MFLO| MTHI| MTLO|BGTZ| BLEZ| BLTZ| BGEZ|  BLTZAL| BGEZAL| JALR| //15
            LB| LBU| LH| LHU| LWL| LWR| SB| SH| SWL| SWR| //10
            MFC0| MTC0| SYSCALL| ERET| BREAK |//5
            TLBP | TLBR | TLBWI); //7
assign Overflow_en = ADD | ADDI | SUB;

endmodule