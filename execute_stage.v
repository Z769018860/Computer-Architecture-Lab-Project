

`ifndef EXCEPTION_NUM 
`define EXCEPTION_NUM 8
`endif

`define CP0_INDEX 5'd0
`define CP0_ENTRYLO0 5'd2
`define CP0_ENTRYLO1 5'd3
`define CP0_PAGEMASK 5'd5
`define CP0_BADVADDR 5'd8
`define CP0_COUNT 5'd9
`define CP0_ENTRYHI 5'd10
`define CP0_COMPARE 5'd11
`define CP0_STATUS 5'd12
`define CP0_CAUSE 5'd13
`ifndef CP0_EPC
    `define CP0_EPC 5'd14
`endif

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

module execute_stage(
    input wire      clk,
    input wire      rst,
    input wire      inst_wait,
    input wire      suspend,
    input wire      block,
    //input wire [1:0] de_out_PC_src,
    //input wire [1:0] de_out_Write_dest,
    input wire       de_out_Reg_write,
    //input wire       de_out_ALU_srcA,
    //input wire       de_out_ALU_srcB,
    input wire       de_out_Mem_write,
    input wire [3:0] de_out_ALU_op,
    //input wire       de_out_Branch,
    input wire [1:0] de_out_Data_src,
    //input wire       de_out_Jump_src,
    input wire       de_out_Mem_read,
    input wire [1:0] de_RW_HL,
    input wire       de_HL_en,
    input wire       de_MUL,
    input wire       de_DIV,
    input wire       de_Sign,
    //input wire [31:0]de_HL_rdata,


    input wire [31:0] debug_pc_de_out,//debug

    input wire [31:0] de_out_A,
    input wire [31:0] de_out_B,
    input wire [31:0] de_out_read_data_2,
    input wire [4:0]  de_out_write_reg,
    input wire [31:0] de_out_pc_plus_8,

    input wire  Div_ready,
    //input wire  Div_block,

    output reg  [4:0] exe_write_reg,
    output reg  [31:0] exe_pc_plus_8,
    //output wire [31:0] exe_sram_wdata,
    output wire [31:0] exe_ALU_out,
    output reg  [31:0] debug_pc_exe_out,
    output wire [31:0] exe_bpdata,
    //output wire [1:0] exe_out_PC_src,
    //output wire [1:0] exe_out_Write_dest,
    output wire       exe_out_Reg_write,
    //output wire       exe_out_ALU_srcA,
    //output wire       exe_out_ALU_srcB,

    //output wire [2:0] exe_out_ALU_op,
    //output wire       exe_out_Branch,
    output wire [1:0] exe_out_Data_src,
    //output wire       exe_out_Jump_src
    output reg        exe_out_Mem_read,
    //output wire       exe_out_Mem_write,
    output reg        exe_Mem_write,
    output wire  [1:0] exe_RW_HL,
    output wire        exe_HL_en,
    //output reg [31:0] exe_HL_rdata,
    output wire[39:0] extended_A,
    output wire[39:0] extended_B,
    output wire exe_MUL,
    output reg DIV_valid,

    input wire [2:0] de_to_exe_Unalign_l,
    input wire [2:0] de_to_exe_Unalign_s,
    output reg [2:0] exe_to_mem_Unalign_l,
    output reg [31:0] exe_read_data_2,
    output wire div_signed,
    //data_sram
    output wire [31:0] exe_sram_wdata,
    output wire [31:0] align_mem_address,
    output wire [3:0] exe_out_Mem_en,
    //data_sram


    //exception
    output wire exe_Abortion,
    //NOTE: The most important thing is that,
    //since the data_ram is syncronized, we access the data_mem in the 
    //end of the exe stage. Thus we should set exe_out_Mem_en to 0 when 
    //exception signal is valid. 
    input  wire de_jorbran,
    //output reg  exe_jorbran,
    input  wire [`EXCEPTION_NUM-1:0] de_exbit,
    //output wire [7:0]   int_mask,
    input wire  [5:0]   hw_int,
    output wire exception,
    input wire de_Overflow_en,
    //input wire  mem_jorbran,

    //cp0 registers ports
    input wire  [4:0]   de_cp0_raddr,
    output wire [31:0]  de_cp0_rdata,
    input wire  [4:0]  de_cp0_waddr,
    input wire  [31:0]  de_cp0_wdata,
    input wire          de_cp0_wen,
    
    input wire de_ERET,
    output wire exe_ERET,
    output wire [31:0] cp0_epc,
    output wire mem_access,
    output wire exe_div_or_prod,


    input wire  de_to_exe_TLBP,
    input wire  de_to_exe_TLBR,
    input wire  de_to_exe_TLBWI,
    input wire  [31:0] TLB_entrylo0,
    input wire  [31:0] TLB_entrylo1,
    input wire  [31:0] TLB_entryhi,
    input wire  [31:0] TLB_pagemask,
    input wire  TLBP_hit,
    input wire  [31:0] TLBP_index,

    output wire [31:0] cp0_index,
    output wire [31:0] cp0_entrylo0,
    output wire [31:0] cp0_entrylo1,
    output wire [31:0] cp0_entryhi,
    output wire [31:0] cp0_pagemask,
    output wire exe_TLBWI,
    //TLB exception
    input  wire de_tlb_miss,
    input  wire de_tlb_invalid,
    input  wire tlb_data_miss,
    input  wire tlb_data_invalid,
    input  wire tlb_modified,

    output reg exe_inst_tlb_miss,
    output reg exe_inst_tlb_invalid,
    output wire pcmux_tlbref
    //TLB exception end

);

//reg [1:0] exe_PC_src;
//reg [1:0] exe_Write_dest;
reg       exe_Reg_write;
//reg       exe_ALU_srcA;
//reg       exe_ALU_srcB;
//reg exe_Mem_write;
reg [3:0] exe_ALU_op;
//reg       exe_Branch;
reg [1:0] exe_Data_src;
//reg       exe_Jump_src;
reg [31:0] exe_A;
reg [31:0] exe_B; 
wire      Overflow;
wire      CarryOut;
wire      Zero;
reg Sign;
reg [2:0] exe_Unalign_s;
//reg [31:0] exe_read_data_2;

wire SB, SH, SWL, SWR, SW, LW;
wire [31:0] sram_waddr;
wire waddr_00, waddr_01, waddr_10, waddr_11;
wire [3:0] SB_wen, SH_wen, SWL_wen, SWR_wen;
wire [31:0] SB_wdata, SH_wdata, SWL_wdata, SWR_wdata;



wire [`EXCEPTION_NUM-1:0] exe_exbit;
reg  exe_jorbran;
wire [4:0]Excode;
wire [31:0] invalid_addr;
wire ex_invalid_ad;
wire Status_wen, Cause_wen;
//important: cp0 can only be written when pipe flows!!!
wire exe_cp0_wen; 
reg [`EXCEPTION_NUM-1 :0 ]de_exbit_r;
reg Overflow_en_r ;
reg [31:0]cp0_register [0:31];
reg cp0_wen_r;
reg [31:0] cp0_waddr_r;
reg [31:0] cp0_wdata_r;


reg SR_EXL;
reg [7:0] SR_IM;
reg SR_IE;
reg CR_BD, CR_TI;
reg [5:0] CR_IP_7_2;
reg [1:0] CR_IP_1_0;
reg [4 :0] CR_Excode;
reg count_step;
reg exe_delay_slot;
reg exe_MUL_r;
reg div_or_prod;
reg exe_ERET_r;
reg exe_HL_en_r;
reg [1:0]exe_RW_HL_r;
reg exe_TLBP_r, exe_TLBR_r, exe_TLBWI_r;
wire exe_TLBR, exe_TLBP;


assign exe_HL_en = (~exception) &~(inst_wait| block) &exe_HL_en_r;
assign exe_RW_HL = (~exception) &~(inst_wait| block) &exe_RW_HL_r;
assign exe_div_or_prod = div_or_prod;
always@(posedge clk)
begin
  
  //exe_PC_src <= (rst)? 2'b0 : de_out_PC_src;
  //exe_Write_dest <= (rst)? 2'b0 : de_out_Write_dest;
  div_or_prod <= (rst)? 1'b0: (inst_wait|block)? div_or_prod : (suspend)? 1'b0: de_MUL|de_DIV;
  exe_Reg_write <= (rst)? 1'b0 : (inst_wait | block) ? exe_Reg_write : (suspend)? 1'b0: de_out_Reg_write;
  //exe_ALU_srcA <= (rst)? 1'b0 : de_out_ALU_srcA;
  //exe_ALU_srcB <= (rst)? 1'b0 : de_out_ALU_srcB;
  exe_Mem_write <= (rst)? 1'b0 : (inst_wait | block)? exe_Mem_write : (suspend)? 1'b0 : de_out_Mem_write;
  exe_ALU_op <= (rst)? 4'b0 : (inst_wait| block)? exe_ALU_op : (suspend)? 4'b0: de_out_ALU_op;
  //exe_Branch <= (rst)? 1'b0 : de_out_Branch;
  exe_Data_src <= (rst)? 2'b0 : (inst_wait| block)?exe_Data_src : (suspend)? 2'b0: de_out_Data_src;
  //exe_Jump_src <= (rst)? 1'b0 : de_out_Jump_src;
  exe_out_Mem_read <= (rst)? 1'b0: (inst_wait| block)? exe_out_Mem_read : (suspend)? 1'b0: de_out_Mem_read; 

  exe_A <= (rst)? 32'b0 : (block | inst_wait)? exe_A: (suspend)? 32'b0:de_out_A ;
  exe_B <= (rst)? 32'b0 :(block | inst_wait)? exe_B: (suspend)? 32'b0:de_out_B ;
  exe_write_reg <= (rst)? 5'b0: (inst_wait| block)? exe_write_reg : (suspend)? 5'b0: de_out_write_reg;
  exe_pc_plus_8 <= (rst)? 32'b0: (inst_wait| block)? exe_pc_plus_8 : (suspend)? 32'b0: de_out_pc_plus_8;
  exe_read_data_2 <= (rst)? 32'b0: (inst_wait| block)? exe_read_data_2 :(suspend)? 32'b0: de_out_read_data_2;
  debug_pc_exe_out <= (rst)? 32'b0 :(inst_wait| block)? debug_pc_exe_out: (suspend)? 32'b0: debug_pc_de_out;  

  exe_RW_HL_r <= (rst)? 2'b0: (inst_wait| block)? exe_RW_HL_r : (suspend)? 2'b0: de_RW_HL;
  exe_HL_en_r <= (rst)? 1'b0: (inst_wait| block)? exe_HL_en_r : (suspend)? 1'b0:de_HL_en;
  Sign <= (block | inst_wait)? Sign : de_Sign;

  exe_MUL_r  <= (rst)? 1'b0 : (inst_wait)? exe_MUL_r : (suspend)? 1'b0: de_MUL;
  DIV_valid <= (rst)? 1'b0: ( inst_wait)? DIV_valid: (suspend)? 1'b0 : de_DIV;
  exe_Unalign_s <= (rst)? 3'b0: (inst_wait| block)? exe_Unalign_s : (suspend)? 3'b0: de_to_exe_Unalign_s;
  exe_to_mem_Unalign_l <= (rst)? 3'b0: (inst_wait| block)? exe_to_mem_Unalign_l: (suspend)? 3'b0: de_to_exe_Unalign_l;

  exe_jorbran  <= (rst)?1'b0 :(inst_wait| block)? exe_jorbran: (suspend)? 1'b0: de_jorbran;
  de_exbit_r <= (rst)? `EXCEPTION_NUM'b0: (inst_wait| block)? de_exbit_r : (suspend)? `EXCEPTION_NUM'b0 : de_exbit;
  Overflow_en_r <= (rst)? 1'b0: (inst_wait| block)? Overflow_en_r: (suspend)? 1'b0: de_Overflow_en;

//cp0_wen_r <= (rst)? 1'b0 : (inst_wait)? cp0_wen_r : (suspend)? 1'b0 :de_cp0_wen; 
  exe_TLBP_r <= (rst)? 1'b0: (inst_wait| block)? exe_TLBP_r: (suspend)? 1'b0: de_to_exe_TLBP;
  exe_TLBR_r <= (rst)? 1'b0: (inst_wait| block)? exe_TLBR_r: (suspend)? 1'b0: de_to_exe_TLBR;
  exe_TLBWI_r <= (rst)? 1'b0: (inst_wait| block)? exe_TLBWI_r: (suspend)? 1'b0: de_to_exe_TLBWI;
  exe_inst_tlb_miss <= (rst)? 1'b0: (inst_wait| block)? exe_inst_tlb_miss : (suspend)? 1'b0:  de_tlb_miss;
  exe_inst_tlb_invalid <=(rst)? 1'b0: (inst_wait| block)? exe_inst_tlb_invalid : (suspend)? 1'b0:  de_tlb_invalid;
  
end


alu alu
      (
         .A(exe_A),
         .B(exe_B),
         .ALUop(exe_ALU_op),
         .Overflow(Overflow),
         .CarryOut(CarryOut),
         .Zero(Zero),
         .Result(exe_ALU_out) 
      );

      assign exe_out_Reg_write=exe_Reg_write;
      assign exe_out_Data_src=exe_Data_src;
      //assign exe_out_Jump_src=exe_Jump_src;
      assign exe_bpdata = (exe_Data_src == 2'd2)? exe_pc_plus_8:exe_ALU_out;

//MUL and DIV
assign exe_ERET = exe_ERET_r;
assign exe_MUL = exe_MUL_r;
//when addr fault, can not issue mem_access signal (data_req) 
/*WARNING: mem_access could be issued during block state, however, when
 there is exception in the instruction(not issued yet), we should hold up 
 the mem_access signal !!!(especially for STORE instruction)

*/
assign mem_access = (rst| (|exe_exbit))? 1'b0: exe_out_Mem_read | exe_Mem_write;
assign extended_A = (Sign)? {{8{exe_A[31]}}, exe_A[31:0]}
                          : {8'b0,exe_A[31:0]};
assign extended_B = (Sign)? {{8{exe_B[31]}}, exe_B[31:0]}
                          : {8'b0,exe_B[31:0]};

assign SB = exe_Unalign_s == 3'b100;
assign SH = exe_Unalign_s == 3'b101;
assign SWL = exe_Unalign_s == 3'b110;
assign SWR = exe_Unalign_s == 3'b111;
assign SW = exe_Unalign_s == 3'b000 && exe_Mem_write;
assign sram_waddr = exe_ALU_out;
assign LW = exe_to_mem_Unalign_l == 3'b000 && exe_out_Mem_read;

assign waddr_00 = sram_waddr[1:0] == 2'b00;
assign waddr_01 = sram_waddr[1:0] == 2'b01;
assign waddr_10 = sram_waddr[1:0] == 2'b10;
assign waddr_11 = sram_waddr[1:0] == 2'b11;


assign SB_wen = {4{(waddr_00)}} & (4'b0001)
               |{4{(waddr_01)}} & (4'b0010)
               |{4{(waddr_10)}} & (4'b0100)
               |{4{(waddr_11)}} & (4'b1000);

assign SH_wen = {4{(waddr_00)}} & (4'b0011)
               |{4{(waddr_10)}} & (4'b1100);

assign SWL_wen = {4{(waddr_00)}} & (4'b0001)
               |{4{(waddr_01)}} & (4'b0011)
               |{4{(waddr_10)}} & (4'b0111)
               |{4{(waddr_11)}} & (4'b1111);

assign SWR_wen = {4{(waddr_00)}} & (4'b1111)
               |{4{(waddr_01)}} & (4'b1110)
               |{4{(waddr_10)}} & (4'b1100)
               |{4{(waddr_11)}} & (4'b1000);


assign SB_wdata = {32{waddr_00}} & (exe_read_data_2)
                 |{32{waddr_01}} & (exe_read_data_2<<8)
                 |{32{waddr_10}} & (exe_read_data_2<<16)
                 |{32{waddr_11}} & (exe_read_data_2<<24);

assign SH_wdata = {32{waddr_00}} & (exe_read_data_2)
                 |{32{waddr_10}} & (exe_read_data_2<<16);

assign SWL_wdata = {32{waddr_00}} & (exe_read_data_2>>24)
                 |{32{waddr_01}} & (exe_read_data_2>>16)
                 |{32{waddr_10}} & (exe_read_data_2>>8)
                 |{32{waddr_11}} & (exe_read_data_2);

assign SWR_wdata = SB_wdata; 

assign exe_out_Mem_en = (rst|exception |exe_out_Mem_read)? 4'b0: //when exception signal is valid, mem_wen should be disabled
                        {4{SB}} & SB_wen
                       |{4{SH}} & SH_wen
                       |{4{SWL}}& SWL_wen
                       |{4{SWR}}& SWR_wen
                       |{4{SW}};
assign align_mem_address  =  {exe_ALU_out[31:2],2'b0};      

assign exe_sram_wdata = {32{SW}} & (exe_read_data_2) //4-byte aligned
                       |{32{SB}} & (SB_wdata)  //SB
                       |{32{SH}} & (SH_wdata)  //SH
                       |{32{SWL}} & (SWL_wdata)  //SWL
                       |{32{SWR}} & (SWR_wdata);  //SWR

assign div_signed = Sign;

assign exe_TLBP = exe_TLBP_r & ~(inst_wait|block);
assign exe_TLBR = exe_TLBR_r & ~(inst_wait | block);
assign exe_TLBWI = exe_TLBWI_r & ~(inst_wait | block);


//reg [`EXCEPTION_NUM-1:0] exe_exbit_r;
wire [7:0] int_after_mask;
//wire [7:0] interrupt;
wire time_int;
//reg time_int_r;
//reg [5:0] hw_int_r;

//handle exception
//assign sw_int = 2'b0;// NOTE: no software interrupt
//assign interrupt[7] = hw_int[5] | time_int | hw_int_r[5];
//assign interrupt[6:2] = hw_int[4:0]|hw_int_r[4:0];
//assign interrupt[1:0] =  CR_IP_1_0[1:0];
//Warning: time_int only holds for one cycle!!
assign time_int = (cp0_register[`CP0_COUNT] == cp0_register[`CP0_COMPARE]);
//When inst_wait, exception is masked


assign exception =  (~inst_wait) & ~SR_EXL & (|exe_exbit);
assign int_after_mask = {CR_IP_7_2[5:0] ,CR_IP_1_0[1:0]}& SR_IM;

assign exe_Abortion = exception;

wire ad4_unalign;
wire ad2_unalign;
wire [`EXCEPTION_NUM-1:0]total_exbit;
wire exe_tlb_exception;
assign ad4_unalign = (exe_ALU_out[1:0] != 2'b0);
assign ad2_unalign = exe_ALU_out[0]; 
//NOTE :we mask interrupts outside of the exe stage
assign exe_exbit[`EX_INTR] = SR_IE & |int_after_mask;
assign exe_exbit[`EX_INST_READ] = de_exbit_r[`EX_INST_READ];
assign exe_exbit[`EX_RI] = de_exbit_r[`EX_RI];
assign exe_exbit[`EX_OVER] = Overflow & Overflow_en_r;
assign exe_exbit[`EX_BREAK] = de_exbit_r[`EX_BREAK];
assign exe_exbit[`EX_SYS] = de_exbit_r[`EX_SYS];
assign exe_exbit[`EX_DATA_WRITE] = exe_Unalign_s == 3'b101 && ad2_unalign //SH
                                || SW && ad4_unalign; //SW
assign exe_exbit[`EX_DATA_READ]  = (exe_to_mem_Unalign_l == 3'b011 && ad2_unalign)//LH
                                || (exe_to_mem_Unalign_l == 3'b100 && ad2_unalign)//LHU
                                || (LW && ad4_unalign); //LW
assign exe_exbit[`EX_INST_TLBL] = de_exbit_r[`EX_INST_TLBL];
assign exe_exbit[`EX_DATA_TLBL] = (tlb_data_miss | tlb_data_invalid) & (exe_out_Mem_read);
assign exe_exbit[`EX_DATA_TLBS] = (tlb_data_miss | tlb_data_invalid) & (exe_Mem_write);
assign exe_exbit[`EX_TLB_MOD]   = tlb_modified & exe_Mem_write;                      
//Warning: interruput should be considered separately 
// since interrupt can be masked separately


assign Excode = exe_exbit[`EX_INST_TLBL]? 5'h2:
                exe_exbit[`EX_DATA_TLBL]? 5'h2:
                exe_exbit[`EX_DATA_TLBS]? 5'h3:
                exe_exbit[`EX_TLB_MOD]? 5'h01:
                exe_exbit[`EX_INTR]? 5'h0:
                exe_exbit[`EX_INST_READ]? 5'h4:
                exe_exbit[`EX_RI]? 5'ha:
                exe_exbit[`EX_OVER]? 5'hc:
                exe_exbit[`EX_BREAK]? 5'h9:
                exe_exbit[`EX_SYS]? 5'h8:
                exe_exbit[`EX_DATA_READ]? 5'h4:
                exe_exbit[`EX_DATA_WRITE]? 5'h5 : 5'h0;



assign invalid_addr =  (exe_exbit[`EX_INST_READ]|exe_exbit[`EX_INST_TLBL])? debug_pc_exe_out:exe_ALU_out;
assign ex_invalid_ad = exe_exbit[`EX_INST_READ]
                      |exe_exbit[`EX_DATA_READ]
                      |exe_exbit[`EX_DATA_WRITE]
                      |exe_exbit[`EX_INST_TLBL]
                      |exe_exbit[`EX_DATA_TLBL]
                      |exe_exbit[`EX_DATA_TLBS]
                      |exe_exbit[`EX_TLB_MOD];




//cp0 registers

reg [31:0] cp0_wdata; 
wire Count_wen, Compare_wen;
reg [31:0] cp0_rdata;
reg [11:0] PMASK_MASK;
reg [18:0] HI_VPN2;
reg [7:0]  HI_ASID;
reg IDX_P;
reg [4:0] IDX_index;


assign exe_tlb_exception = exe_exbit[`EX_INST_TLBL] | exe_exbit[`EX_DATA_TLBL] 
                          |exe_exbit[`EX_DATA_TLBS] | exe_exbit[`EX_TLB_MOD];
assign pcmux_tlbref = exception &
                      ((exe_exbit[`EX_INST_TLBL] & exe_inst_tlb_miss)
                      | (exe_exbit[`EX_DATA_TLBL]& tlb_data_miss)
                      | (exe_exbit[`EX_DATA_TLBS]& tlb_data_miss));

assign de_cp0_rdata = cp0_rdata;
assign Count_wen = (exe_cp0_wen && cp0_waddr_r == `CP0_COUNT);
assign Compare_wen  = (exe_cp0_wen && cp0_waddr_r == `CP0_COMPARE);
assign Status_wen =  (exe_cp0_wen && cp0_waddr_r == `CP0_STATUS);
assign Cause_wen = (exe_cp0_wen && cp0_waddr_r == `CP0_CAUSE);
assign exe_cp0_wen = cp0_wen_r & ~(inst_wait|block);
//assign Index_wen = (exe_cp0_wen && cp0_waddr_r == `CP0_CAUSE) || (exe_TLBP && TLBP_hit);

//*****
//*****WARNING: If we bypass the cp0(especially concerned with TLB) in cp0_xxxxx , there will be combitional timing loop 
//*****We can only bypass the cp0s to cp0_rdata!!!!!!
//*****
assign cp0_epc =  (exe_cp0_wen && cp0_waddr_r == `CP0_EPC)? cp0_wdata_r : cp0_register[`CP0_EPC];
/*
assign cp0_index[31] = (exe_TLBP && ~TLBP_hit)? 1'b1:IDX_P;
assign cp0_index[30:5] = 26'b0;
assign cp0_index[4:0] = (exe_TLBP && TLBP_hit)? TLBP_index[4:0]:(exe_cp0_wen && cp0_waddr_r == `CP0_INDEX)? cp0_wdata_r[4:0]:IDX_index;
*/
assign cp0_index = {IDX_P, 26'b0, IDX_index[4:0]};
/*
assign cp0_entrylo0[31:26] = 6'b0;                
assign cp0_entrylo0[25: 0] = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYLO0)? cp0_wdata_r[25:0] : (exe_TLBR)? TLB_entrylo0[25:0] :  cp0_register[`CP0_ENTRYLO0][25:0];
assign cp0_entrylo1[31:26] = 6'b0;
assign cp0_entrylo1[25: 0] = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYLO1)? cp0_wdata_r[25:0] : (exe_TLBR)? TLB_entrylo1[25:0] :  cp0_register[`CP0_ENTRYLO1][25:0];
*/
assign cp0_entrylo0 = {6'b0,cp0_register[`CP0_ENTRYLO0][25:0]};
assign cp0_entrylo1 = {6'b0,cp0_register[`CP0_ENTRYLO1][25:0]};

/*
assign cp0_entryhi[31:13]  = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r[31:13] : (exe_TLBR)? TLB_entryhi[31:13] :  HI_VPN2;
assign cp0_entryhi[12: 8]  = 5'b0;
assign cp0_entryhi[ 7: 0]  = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r[ 7: 0] : (exe_TLBR)? TLB_entryhi[ 7: 0] :  HI_ASID;
*/
assign cp0_entryhi = {HI_VPN2[18:0], 5'b0, HI_ASID[7:0]};
/*
assign cp0_pagemask[24:13] = (exe_cp0_wen && cp0_waddr_r == `CP0_PAGEMASK)? cp0_wdata_r[23:13] : (exe_TLBR)? TLB_pagemask[23:13] :  PMASK_MASK;
assign cp0_pagemask[31:25] = 7'b0;
assign cp0_pagemask[12: 0] = 13'b0;
*/
assign cp0_pagemask = {7'b0, PMASK_MASK[11:0], 13'b0};

//assign  ex_cause_BD = exe_jorbran; // when jump or branch in exe stage, delay slot in fetch stage
//TODO : finish cp0_rdata
always @(*)
begin
  case (de_cp0_raddr)
    `CP0_STATUS:
    begin
    cp0_rdata = (exe_cp0_wen && cp0_waddr_r == de_cp0_raddr)?
                {16'b0000_0000_0100_0000, cp0_wdata_r[15:8], 6'b0, cp0_wdata_r[1:0]}:
                {16'b0000_0000_0100_0000, SR_IM[7:0], 6'b0, SR_EXL, SR_IE};
    end
    `CP0_CAUSE:
    begin
    cp0_rdata = (exe_cp0_wen && cp0_waddr_r == de_cp0_raddr)?
                {CR_BD, CR_TI, 14'b0, CR_IP_7_2[5:0], cp0_wdata_r[9:8], 1'b0, CR_Excode[4:0], 2'b0}:
                {CR_BD, CR_TI, 14'b0, CR_IP_7_2[5:0], CR_IP_1_0[1:0], 1'b0, CR_Excode[4:0],2'b0 };
    end
    `CP0_INDEX:
    
    begin
    cp0_rdata[31] = (exe_TLBP && ~TLBP_hit)? 1'b1:IDX_P;
    cp0_rdata[30:5] = 26'b0;
    cp0_rdata[4:0] = (exe_TLBP && TLBP_hit)? TLBP_index[4:0]:(exe_cp0_wen && cp0_waddr_r == `CP0_INDEX)? cp0_wdata_r[4:0]:IDX_index;
    end
    `CP0_ENTRYLO0:

    begin
    cp0_rdata[31:26] = 6'b0;                
    cp0_rdata[25: 0] = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYLO0)? cp0_wdata_r[25:0] :(exe_TLBR)? TLB_entrylo0[25:0] : cp0_register[`CP0_ENTRYLO0][25:0];

    end

    `CP0_ENTRYLO1:
    begin
    cp0_rdata[31:26] = 6'b0;                
    cp0_rdata[25: 0] = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYLO1)? cp0_wdata_r[25:0] : (exe_TLBR)? TLB_entrylo1[25:0] : cp0_register[`CP0_ENTRYLO1][25:0];

    end

    `CP0_ENTRYHI:
    begin
    cp0_rdata[31:13]  = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r[31:13] : (exe_TLBR)? TLB_entryhi[31:13] :  HI_VPN2;
    cp0_rdata[12: 8]  = 5'b0;
    cp0_rdata[ 7: 0]  = (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r[ 7: 0] : (exe_TLBR)? TLB_entryhi[ 7: 0] :  HI_ASID;   
    end 

    `CP0_PAGEMASK:
    begin
    cp0_rdata[24:13] = (exe_cp0_wen && cp0_waddr_r == `CP0_PAGEMASK)? cp0_wdata_r[23:13] : (exe_TLBR)? TLB_pagemask[23:13] :  PMASK_MASK;
    cp0_rdata[31:25] = 7'b0;
    cp0_rdata[12: 0] = 13'b0;
    end

    default: 
    cp0_rdata = (exe_cp0_wen && cp0_waddr_r == de_cp0_raddr)? cp0_wdata_r : cp0_register[de_cp0_raddr];
  endcase
end



always @(posedge clk)
begin
  cp0_wen_r <= (rst)? 1'b0 : (inst_wait | block)? cp0_wen_r : (suspend)? 1'b0 :de_cp0_wen; 
  cp0_wdata_r <= (rst)? 32'b0 : (inst_wait| block)? cp0_wdata_r : (suspend)? 32'b0 : de_cp0_wdata;
  cp0_waddr_r <= (rst)? 32'b0: (inst_wait| block)? cp0_waddr_r : (suspend)? 32'b0: de_cp0_waddr;
  count_step <= (rst ||  Count_wen)? 1'b0: ~count_step;
  //NOTE:not reset this signal ???
  exe_delay_slot <= (rst)? 1'b0: (inst_wait)? exe_delay_slot :(suspend)? 1'b0: exe_jorbran;
  exe_ERET_r <= (rst)? 1'b0 :(inst_wait)? exe_ERET : (suspend)? 1'b0 : de_ERET;
end





always @(posedge clk)
begin
	//cp0_register[`CP0_INDEX] <= (TLBP_hit && ~(inst_wait | block))? TLBP_index : (exe_cp0_wen && cp0_waddr_r == `CP0_INDEX)? cp0_wdata_r : cp0_register[0];
 	IDX_P <= (rst)? 1'b0 : (exe_TLBP)? ~TLBP_hit : IDX_P; 
    IDX_index <= (exe_TLBP && TLBP_hit)? TLBP_index[4:0 ] :(exe_cp0_wen && cp0_waddr_r == `CP0_INDEX)? cp0_wdata_r[4:0] :  IDX_index;

  cp0_register[1] <= (exe_cp0_wen && cp0_waddr_r == 1)? cp0_wdata_r : cp0_register[1];
	cp0_register[`CP0_ENTRYLO0][25:0] <= exe_TLBR? TLB_entrylo0[25:0] : 
  (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYLO0)? cp0_wdata_r[25:0] : cp0_register[`CP0_ENTRYLO0][25:0];
	
  cp0_register[`CP0_ENTRYLO1][25:0] <= exe_TLBR? TLB_entrylo1[25:0] :
  (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYLO1)? cp0_wdata_r[25:0] : cp0_register[`CP0_ENTRYLO1][25:0];
	
  cp0_register[4] <= (exe_cp0_wen && cp0_waddr_r == 4)? cp0_wdata_r : cp0_register[4];
	//cp0_register[`CP0_PAGEMASK] <= exe_TLBR? TLB_pagemask : (exe_cp0_wen && cp0_waddr_r == `CP0_PAGEMASK)? cp0_wdata_r : cp0_register[5];
	PMASK_MASK <= exe_TLBR? TLB_pagemask[24:13] : (exe_cp0_wen && cp0_waddr_r == `CP0_PAGEMASK)? cp0_wdata_r[24:13] : PMASK_MASK;
  cp0_register[6] <= (exe_cp0_wen && cp0_waddr_r == 6)? cp0_wdata_r : cp0_register[6];
	cp0_register[7] <= (exe_cp0_wen && cp0_waddr_r == 7)? cp0_wdata_r : cp0_register[7];
	cp0_register[`CP0_BADVADDR] <=(ex_invalid_ad && exception)? invalid_addr: 
                                (exe_cp0_wen && cp0_waddr_r == `CP0_BADVADDR)? cp0_wdata_r : cp0_register[`CP0_BADVADDR];
	cp0_register[`CP0_COUNT] <= (rst)? 32'b0 : (Count_wen)? cp0_wdata_r : (count_step)? cp0_register[`CP0_COUNT]+32'b1  :cp0_register[`CP0_COUNT];
	//cp0_register[`CP0_ENTRYHI] <= exe_TLBR? TLB_entryhi : (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r : cp0_register[`CP0_COUNT];
	HI_VPN2 <= (exception && exe_tlb_exception)? invalid_addr[31:13]:
            exe_TLBR? TLB_entryhi[31:13] : (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r[31:13] : HI_VPN2;
  HI_ASID <= exe_TLBR? TLB_entryhi[ 7: 0] : (exe_cp0_wen && cp0_waddr_r == `CP0_ENTRYHI)? cp0_wdata_r[ 7: 0] : HI_ASID;
  cp0_register[`CP0_COMPARE] <= (rst)? 32'b0 :(exe_cp0_wen && cp0_waddr_r == `CP0_COMPARE)? cp0_wdata_r : cp0_register[11];
	
  //cp0_status register
  //SR_31_16 <= 16'0000_0000_0100_0000;
  SR_IM <= (rst )? 8'b0000_0000 :  Status_wen?  cp0_wdata_r[15:8] :SR_IM ;
  //SR_7_2 <= 6'b000000;
  SR_EXL <= (rst | exe_ERET)? 1'b0 : (exception)? 1'b1: 
            Status_wen ? cp0_wdata_r[1] : SR_EXL; 
  SR_IE <= (rst)? 1'b0: 
          Status_wen ?cp0_wdata_r[0] : SR_IE;
  
  
  //cp0_status end 
  //cp0_register[`CP0_STATUS] <= (ex_Write_cp0)? ex_status_data :
  //                            (cp0_wen_r && cp0_waddr_r == `CP0_STATUS)? cp0_wdata_r : cp0_register[`CP0_STATUS];
	//cp0_register[`CP0_CAUSE] <= (ex_Write_cp0)? ex_cause_data :
  //                              (cp0_wen_r && cp0_waddr_r == `CP0_CAUSE)? cp0_wdata_r : cp0_register[`CP0_CAUSE];
	
  
  //cp0_cause register
  CR_BD <= (rst)? 1'b0 : (exception)? exe_delay_slot: CR_BD;
  CR_TI <= (rst)? 1'b0 :  (time_int & SR_IM[7])? 1'b1 :(exe_ERET|~inst_wait)?1'b0: CR_TI;
  CR_IP_7_2[5] <= (rst)? 1'b0 : (exe_ERET|~inst_wait)? 1'b0: (hw_int[5] | time_int)? 1'b1:CR_IP_7_2[5] ;
  CR_IP_7_2[4] <= (rst)? 1'b0 : (exe_ERET|~inst_wait)? 1'b0 :(hw_int[4])? 1'b1: CR_IP_7_2[4];
  CR_IP_7_2[3] <= (rst)? 1'b0 : (exe_ERET|~inst_wait)? 1'b0 :(hw_int[3])? 1'b1: CR_IP_7_2[3];
  CR_IP_7_2[2] <= (rst)? 1'b0 : (exe_ERET|~inst_wait)? 1'b0 :(hw_int[2])? 1'b1: CR_IP_7_2[2];
  CR_IP_7_2[1] <= (rst)? 1'b0 : (exe_ERET|~inst_wait)? 1'b0 :(hw_int[1])? 1'b1: CR_IP_7_2[1];
  CR_IP_7_2[0] <= (rst)? 1'b0 : (exe_ERET|~inst_wait)? 1'b0 :(hw_int[0])? 1'b1: CR_IP_7_2[0];
  CR_IP_1_0 <= (rst)? 2'b0 : (Cause_wen)? cp0_wdata_r[9:8] : CR_IP_1_0;
  CR_Excode <= (rst)? 5'b0 : (exception)? Excode : CR_Excode;

  //cp0_cause end
  if(exception)
  begin
    cp0_register[`CP0_EPC] <= (exe_delay_slot)? (debug_pc_exe_out - 32'd4) : debug_pc_exe_out;
  end
  else 
  begin
    cp0_register[`CP0_EPC] <= (exe_cp0_wen && cp0_waddr_r == `CP0_EPC)? cp0_wdata_r : cp0_register[`CP0_EPC];
  end
	cp0_register[15] <= (exe_cp0_wen && cp0_waddr_r == 15)? cp0_wdata_r : cp0_register[15];
	cp0_register[16] <= (exe_cp0_wen && cp0_waddr_r == 16)? cp0_wdata_r : cp0_register[16];
	cp0_register[17] <= (exe_cp0_wen && cp0_waddr_r == 17)? cp0_wdata_r : cp0_register[17];
	cp0_register[18] <= (exe_cp0_wen && cp0_waddr_r == 18)? cp0_wdata_r : cp0_register[18];
	cp0_register[19] <= (exe_cp0_wen && cp0_waddr_r == 19)? cp0_wdata_r : cp0_register[19];
	cp0_register[20] <= (exe_cp0_wen && cp0_waddr_r == 20)? cp0_wdata_r : cp0_register[20];
	cp0_register[21] <= (exe_cp0_wen && cp0_waddr_r == 21)? cp0_wdata_r : cp0_register[21];
	cp0_register[22] <= (exe_cp0_wen && cp0_waddr_r == 22)? cp0_wdata_r : cp0_register[22];
	cp0_register[23] <= (exe_cp0_wen && cp0_waddr_r == 23)? cp0_wdata_r : cp0_register[23];
	cp0_register[24] <= (exe_cp0_wen && cp0_waddr_r == 24)? cp0_wdata_r : cp0_register[24];
	cp0_register[25] <= (exe_cp0_wen && cp0_waddr_r == 25)? cp0_wdata_r : cp0_register[25];
	cp0_register[26] <= (exe_cp0_wen && cp0_waddr_r == 26)? cp0_wdata_r : cp0_register[26];
	cp0_register[27] <= (exe_cp0_wen && cp0_waddr_r == 27)? cp0_wdata_r : cp0_register[27];
	cp0_register[28] <= (exe_cp0_wen && cp0_waddr_r == 28)? cp0_wdata_r : cp0_register[28];
	cp0_register[29] <= (exe_cp0_wen && cp0_waddr_r == 29)? cp0_wdata_r : cp0_register[29];
	cp0_register[30] <= (exe_cp0_wen && cp0_waddr_r == 30)? cp0_wdata_r : cp0_register[30];
	cp0_register[31] <= (exe_cp0_wen && cp0_waddr_r == 31)? cp0_wdata_r : cp0_register[31];
end




//handle exception end
endmodule