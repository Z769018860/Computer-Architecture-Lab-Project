`define CP0_BADVADDR 5'd8
`define CP0_COUNT 5'd9
`define CP0_COMPARE 5'd11
`define CP0_STATUS 5'd12
`define CP0_CAUSE 5'd13
`ifndef CP0_EPC
    `define CP0_EPC 5'd14
`endif
    
`define EXCEPTION_ENTRY 32'hbfc00380

`define EXCEPTION_NUM 12

    module mips_cpu(
    input  resetn,
    input  clk,
    input  [5:0] hw_int,

    output inst_req,
    output inst_sram_wr,
    output [3:0] inst_sram_wen,
    output [31:0] inst_sram_addr,
    output [31:0] inst_sram_wdata,
    input [31:0] inst_sram_rdata,
    input inst_addr_ok,
    input inst_data_ok,
    //
    output data_req,
    output data_sram_wr,
    output [3:0] data_sram_wen,
    output [31:0] data_sram_addr,
    output [31:0] data_sram_wdata,
    input [31:0] data_sram_rdata,
    input data_addr_ok,
    input data_data_ok,
    //
    output [31:0] debug_wb_pc,
    output [3:0] debug_wb_rf_wen,
    output [4:0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
);

//����
//wire [31:0] fe_to_de_PC;
//wire [31:0] PC_branch;
//wire [31:0] PC_jump;
//wire [1:0]  PC_src;

wire de_to_exe_Reg_write;
wire de_to_exe_Mem_write;
wire [3:0]  de_to_exe_ALU_op;
wire [1:0]  de_to_exe_Data_src;
wire [31:0] de_to_exe_debug_pc;
wire [31:0] de_to_exe_srcA_value;
wire [31:0] de_to_exe_srcB_value;
wire [31:0] de_to_exe_read_data_2;
wire [4:0]  de_to_exe_reg_dest;
wire [31:0] de_to_exe_pc_plus_8;
wire de_to_exe_Mem_read;
wire de_HL_en;
wire de_to_exe_MUL;
wire de_to_exe_DIV;
wire de_to_exe_Sign;
wire [1:0] de_RW_HL;
wire de_cp0_wen;
wire de_Abortion;
wire [`EXCEPTION_NUM-1:0] de_exbit;
wire de_Overflow_en;
wire de_ERET;
wire de_to_exe_TLBP, de_to_exe_TLBR, de_to_exe_TLBWI;
wire de_tlb_miss, de_tlb_invalid;
wire exe_inst_tlb_miss, exe_inst_tlb_invalid;



wire exe_to_mem_Reg_write;
//wire [3:0]  exe_to_mem_mem_en;
wire [1:0]  exe_to_mem_Data_src;
wire [31:0] exe_to_mem_debug_pc;
//wire [31:0] exe_to_mem_mem_addr;
//wire [31:0] exe_to_mem_mem_data;
wire [4:0]  exe_to_mem_reg_dest;
wire [31:0] exe_to_mem_pc_plus_8;
wire [31:0] exe_to_mem_rdata2;
wire exe_to_mem_Mem_read;

wire exe_to_mem_MUL;
wire [1:0] exe_RW_HL;
wire exe_HL_en;
wire exe_Abortion;
wire exe_to_mem_Mem_write;
wire exe_div_or_prod;
wire [31:0] exe_ALU_out;
wire [39:0] extended_A;
wire [39:0] extended_B;
wire [65:0] mul_res;
//wire [79:0] div_res;
wire div_complete;
wire [31:0] cp0_index, cp0_entrylo0, cp0_entrylo1, cp0_entryhi, cp0_pagemask;
wire exe_TLBWI;


wire mem_to_wb_Reg_write;
wire [31:0] mem_to_wb_debug_pc;
wire [4:0]  mem_to_wb_reg_dest;
wire [31:0] mem_to_wb_reg_value;
wire mem_to_wb_MUL;
wire [1:0] mem_RW_HL;
wire mem_HL_en;
wire mem_invalid;

wire [4:0]  reg_raddr1;
wire [4:0]  reg_raddr2;
wire [31:0] reg_rdata1;
wire [31:0] reg_rdata2;
wire [31:0] reg_rdata1_afterBP;//regfile read data after bypass
wire [31:0] reg_rdata2_afterBP;
wire    wb_to_reg_wen;
wire [4:0]  wb_to_reg_waddr;
wire [31:0] wb_to_reg_wdata;
//wire wb_MUL;
wire [1:0] wb_RW_HL;
wire wb_HL_en;
//Data correlation
wire Data_block;


wire Exe_to_rf1_bp;
wire Exe_to_rf2_bp;
wire Mem_to_rf1_bp;
wire Mem_to_rf2_bp;

wire [31:0] mem_bpdata;
wire [31:0] exe_bpdata;

//wire MUL_block;
//Data correlation end



//DIV control 
reg div_pipe_count;
wire div_wait;
wire div_ready;
wire div_valid;
wire div_signed;
wire [31:0] div_rem;
wire [31:0] div_quo;
//DIV control end
reg new_div;
wire real_div_valid;
reg div_block;

///wire [31:0]PC_mux; 
wire [31:0]next_pc;
//wire [31:0]PC_plus_4;


reg [31:0]HI;
reg [31:0]LO;
wire [31:0] HL_to_de_rdata;
wire HI_wen, LO_wen;
wire [31:0] HI_rdata,  LO_rdata;
wire [31:0] HI_rdata_afterbp, LO_rdata_afterbp;
wire [31:0] HI_wdata, LO_wdata;

//Unaligned data
wire [2:0] de_to_exe_Unalign_l;
wire [2:0] de_to_exe_Unalign_s;
wire [2:0] exe_to_mem_Unalign_l;

//cp0
reg [31:0]  cp0_register [0:31];

wire [31:0] de_cp0_rdata, de_cp0_wdata;
wire [4:0] de_cp0_raddr, de_cp0_waddr;
wire de_CP0_write;

//wire [4:0]  cp0_raddr;
//wire [31:0] cp0_rdata;
//reg  [4:0]  cp0_waddr;
//reg  [31:0] cp0_wdata;
//reg         cp0_wen;
//exception
//wire de_syscall;
 wire exception;
wire de_jorbran;

//wire [31:0] ex_status_data;
//wire [31:0] ex_cause_data;
//wire [31:0] ex_epc_data;

//wire ex_cause_TI;
//wire [7:0] ex_cause_IP;
//wire [4:0] ex_cause_Excode;
//wire ex_cause_BD;
wire cause_Sys;
wire exe_ERET;
wire [31:0]cp0_epc;




wire inst_wait;
reg data_wait;
reg inst_wait_r;


wire mul_complete;
wire mul_wait;
reg [2:0] mul_cnt;
reg new_mul;

//TLB 
wire [31:0] inst_paddr, inst_vaddr;
wire [31:0] data_paddr, data_vaddr;
wire [31:0] tlb_inst_paddr, tlb_data_paddr;
wire  tlb_inst_hit, tlb_data_hit;
wire [31:0] tlb_entryhi, tlb_entrylo0, tlb_entrylo1, tlb_pagemask; 
wire tlb_inst_v, tlb_inst_d;
wire tlb_data_v, tlb_data_d;
wire [2:0] tlb_inst_c, tlb_data_c; 

wire [31:0] TLBP_index;
wire TLBP_hit;
wire [1:0] inst_tlb_exception, data_tlb_exception;
wire inst_tlb_miss, inst_tlb_invalid;
wire data_tlb_miss, data_tlb_invalid, data_tlb_mod;
wire pcmux_tlbref;



//TLB









//wire [31:0] context_pc;
// ��ģ������ 
//assign debug_wb_rf_wen = {4{wb_to_reg_wen}};
assign debug_wb_rf_wnum = wb_to_reg_waddr;
assign debug_wb_rf_wdata = wb_to_reg_wdata;
//assign inst_sram_en = 1'b1;
//assign data_sram_en = 1'b1;

//bypass control  and data
assign Exe_to_rf1_bp = (exe_to_mem_Reg_write & ~exe_to_mem_Mem_read)
                        && reg_raddr1 == exe_to_mem_reg_dest;
assign Exe_to_rf2_bp = (exe_to_mem_Reg_write & ~exe_to_mem_Mem_read)
                        && reg_raddr2 == exe_to_mem_reg_dest;
assign Mem_to_rf1_bp = (mem_to_wb_Reg_write)
                        && reg_raddr1 == mem_to_wb_reg_dest;
assign Mem_to_rf2_bp = (mem_to_wb_Reg_write)
                        && reg_raddr2 == mem_to_wb_reg_dest;

assign Data_block = (exception | exe_ERET)? 1'b0:(exe_to_mem_Reg_write & exe_to_mem_Mem_read)
               && (reg_raddr1 == exe_to_mem_reg_dest
               ||  reg_raddr2 == exe_to_mem_reg_dest);
//assign MUL_block = (exception | exe_ERET)? 1'b0:(~de_RW_HL[1] & de_HL_en)
//                   && (exe_to_mem_MUL | mem_to_wb_MUL);
assign reg_rdata1_afterBP = (Exe_to_rf1_bp)? exe_bpdata:
                            (Mem_to_rf1_bp)? mem_bpdata:
                            reg_rdata1;
assign reg_rdata2_afterBP = (Exe_to_rf2_bp)? exe_bpdata:
                            (Mem_to_rf2_bp)? mem_bpdata:
                            reg_rdata2;

assign mem_bpdata = mem_to_wb_reg_value;

    

/*
fetch_stage fe_stage(
    .clk(clk),//input
    .rst(~resetn),//input
    .block(Data_block | div_wait | MUL_block),
    // .PC_src(de_to_fe_PC_src), //input
    // .jump_PC(de_to_fe_jump),//input
    // .branch_PC(de_to_fe_branch),//input
    .PC_plus_4(PC_plus_4),
    .next_pc(inst_sram_addr),
    .fe_pc(fe_to_de_PC)        //fetch_stage pc
);
*/

/*
//instruction 
reg [31:0] first_pc_cache;
wire inst_empty;
wire inst_buf_invalid;
reg [7:0] cache_tail;
wire inst_buf_valid;
reg inst_buf_valid_r;
//NOTE: when inst_flush_buf is valid, we think the buffer becomes empty instantly 
assign inst_empty = cache_tail[0] == 1'b0;
assign inst_req = inst_req_r;
assign inst_sram_wen = 4'b0000;
assign inst_sram_wdata = 32'b0;

assign inst_sram_addr = (exception)? `EXCEPTION_ENTRY : exe_ERET? cp0_epc : next_pc;

//NOTE:when pc differs from what have been loaded, the buffer is invalid
assign inst_buf_invalid = ~(first_pc_cache == inst_sram_addr);
//NOTE: the key of this design is that when instructions is loaded, inst_load becomes low 
assign inst_load = inst_empty | inst_buf_invalid;



always @(posedge clk)
begin
    if(inst_data_ok)
    begin
        {inst_cache[0][0:31], inst_cache[1][0:31],
        inst_cache[2][0:31], inst_cache[3][0:31],
        inst_cache[4][0:31], inst_cache[5][0:31],
        inst_cache[6][0:31], inst_cache[7][0:31]} <= 

        inst_sram_rdata;
    end
    else if(inst_flow) // NOTE: consider how to make sure that inst flows into pipe
    begin
        inst_cache[0] <= inst_cache[1];
        inst_cache[1] <= inst_cache[2];
        inst_cache[2] <= inst_cache[3];
        inst_cache[3] <= inst_cache[4];
        inst_cache[4] <= inst_cache[5];
        inst_cache[5] <= inst_cache[6];
        inst_cache[6] <= inst_cache[7];
        inst_cache[7] <= 32'b0;
    end
end


always @(posedge clk)
begin
//NOTE first_pc_cache is for the comparison of desired pc and already loaded pc
    first_pc_cache <= (inst_data_ok)? next_pc : (inst_flow)? first_pc_cache + 32'd4 : first_pc_cache;
    cache_tail <= (~resetn)? 8'b0000_0000 : (inst_load)? 8'b1111_1111 : (inst_flow)? cache_tail>>1 : cache_tail;
    inst_req_r <= (~resetn)? 1'b0: (inst_addr_ok)? 1'b0: ((~inst_wait) & inst_load)? 1'b1: inst_req_r; 
    inst_wait <= (~resetn)? 1'b0 : (inst_data_ok)? 1'b0 : (inst_load)? 1'b1 :inst_wait ; 
end


//inst_sram fetch block  pre_fetch 
//reg [31:0]  pc_wait_q[0:7];
//reg [2:0]   inst_queue_tail;
//wire        inst_sram_wait;



//inst_sram fetch block end





//instruction cache end

*/
 reg inst_req_r;
 reg [31:0]inst_r;
 reg inst_valid;
 reg new_fetch;
//reg inst_wait_mask;
wire inst_fetch;
//reg exception_r;
reg eret_r;
always @(posedge clk)
begin
    inst_req_r <= (~resetn)? 1'b0: (inst_addr_ok)? 1'b0:(new_fetch & ~inst_valid)?1'b1: inst_req_r;
    inst_r <= (~resetn)? 32'b0 : (inst_data_ok)? inst_sram_rdata : inst_r;
    //For the close of inst_req_r
    new_fetch <= (~resetn)?1'b1 : (exception)? 1'b1: (inst_addr_ok)? 1'b0:(inst_fetch)? 1'b1: new_fetch;
    inst_valid <= (~resetn)?1'b0: (exception)? 1'b0: (inst_data_ok)? 1'b1:(inst_fetch)? 1'b0:inst_valid;
    //exception_r <= (~resetn)? 1'b0: (exception)?1'b1:1'b0;
    //eret_r <= (~resetn)? 1'b0 : (exe_ERET)? 1'b1:1'b0;
end

assign inst_req = resetn & (inst_req_r | (new_fetch & ~inst_valid));
assign inst_sram_wen = 4'b0000;
assign inst_sram_wdata = 32'b0;
//assign inst_sram_addr = next_pc;
assign inst_vaddr = next_pc;
assign inst_sram_wr = 1'b0;
assign inst_wait = (~inst_valid);


decode_stage de_stage(
    .clk(clk),//input
    .rst(~resetn),//input
    .block(Data_block | div_wait |mul_wait | inst_wait |data_wait),
    .inst_in(inst_r),//input
    //.fe_PC_in(fe_to_de_PC),//input
    .de_rf_raddr1(reg_raddr1),
    .de_rf_rdata1(reg_rdata1_afterBP),//input
    .de_rf_raddr2(reg_raddr2),
    .de_rf_rdata2(reg_rdata2_afterBP),//input
    .HL_rdata(HL_to_de_rdata),

    //.pc_plus_4(PC_plus_4),

    .de_write_reg_dest(de_to_exe_reg_dest),         //reg num of dest operand(), zero if no dest
    .de_srcA_value(de_to_exe_srcA_value),        //value of source operand 1
    .de_srcB_value(de_to_exe_srcB_value),        //value of source operand 2
    .de_st_value(de_to_exe_read_data_2),      //value stored to memory
    .de_PC_plus_8(de_to_exe_pc_plus_8),
    .de_out_debug_PC(de_to_exe_debug_pc),
    .next_pc(next_pc),

    .de_Reg_write(de_to_exe_Reg_write),

    .de_Mem_write(de_to_exe_Mem_write), // SRAM enable 4-bit
    .de_ALU_op(de_to_exe_ALU_op),
    //.de_Branch(),
    .de_Data_src(de_to_exe_Data_src),

    .de_Mem_read(de_to_exe_Mem_read),
    .de_RW_HL(de_RW_HL),
    .de_HL_en(de_HL_en),
    .de_MUL(de_to_exe_MUL),
    .de_DIV(de_to_exe_DIV),
    .de_Sign(de_to_exe_Sign),
    .de_Unalign_l(de_to_exe_Unalign_l),
    .de_Unalign_s(de_to_exe_Unalign_s),
    //CP0 ports
    .de_cp0_raddr(de_cp0_raddr),
    .de_cp0_rdata(de_cp0_rdata),
    .de_cp0_waddr(de_cp0_waddr),
    .de_cp0_wdata(de_cp0_wdata),
    .de_cp0_wen(de_cp0_wen), 

    //exception
    //.inst_sram_addr(next_pc),
    .exception(exception), // Warning: exe_ERET eqauls exception in decode stage
    .exe_ERET(exe_ERET),
    .cp0_epc(cp0_epc),
    .de_jorbran(de_jorbran),
    .de_Abortion(de_Abortion),
    .de_exbit(de_exbit),
    .de_Overflow_en(de_Overflow_en),
    .de_ERET(de_ERET),
    .de_inst_fetch(inst_fetch),
    .de_TLBP(de_to_exe_TLBP),
    .de_TLBR(de_to_exe_TLBR),
    .de_TLBWI(de_to_exe_TLBWI),

    .fe_tlb_miss(inst_tlb_miss),
    .fe_tlb_invalid(inst_tlb_invalid),
    .pcmux_tlbref(pcmux_tlbref),

    .de_tlb_miss(de_tlb_miss),
    .de_tlb_invalid(de_tlb_invalid)
);

/*
//inst_sram fetch block  pre_fetch 
//reg [31:0]  pc_wait_q[0:7];
//reg [2:0]   inst_queue_tail;
//wire        inst_sram_wait;
reg inst_wait;
reg inst_req_r;
wire inst_block;
// NOTE: when the data returned in the second cycle, no blocking
assign inst_block = inst_wait & ~inst_data_ok;
assign inst_req = inst_req_r;
always @(posedge clk)
begin
    inst_wait <= (~resetn)? 1'b0 : (inst_data_ok?) 1'b0 : (inst_req)? 1'b1 :inst_wait ; 
    inst_req_r <= (~resetn)? 1'b1: (inst_data_ok)? 1'b1: (inst_addr_ok)? 1'b0 : ;
end

//inst_sram fetch block end
*/
wire data_access;
execute_stage exe_stage(
    .clk(clk),//input
    .rst(~resetn),//input
    .block(div_block | div_wait|mul_wait ),
    //.de_Abortion(), //Warning: when there is no cp0, abortion equals rst,
    //however, when dealing with cp0, abortion should be treated separately
    .suspend(de_Abortion| Data_block),//��������Ӧ������suspend�ź�
    .inst_wait(inst_wait|data_wait),
    .de_out_Reg_write(de_to_exe_Reg_write),//input
    .de_out_Mem_write(de_to_exe_Mem_write),//input
    .de_out_ALU_op(de_to_exe_ALU_op),//input
    .de_out_Data_src(de_to_exe_Data_src),//input
    .de_out_Mem_read(de_to_exe_Mem_read),

    .de_RW_HL(de_RW_HL),
    .de_HL_en(de_HL_en),
    .de_MUL(de_to_exe_MUL),
    .de_DIV(de_to_exe_DIV),
    .de_Sign(de_to_exe_Sign),


    .debug_pc_de_out(de_to_exe_debug_pc),//debug//input

    .de_out_A(de_to_exe_srcA_value),//input
    .de_out_B(de_to_exe_srcB_value),//input
    .de_out_read_data_2(de_to_exe_read_data_2),//input
    .de_out_write_reg(de_to_exe_reg_dest),//input
    .de_out_pc_plus_8(de_to_exe_pc_plus_8),//input

    .Div_ready(div_ready),
   //.Div_block(div_block | div_wait),
    .DIV_valid(div_valid),

    .exe_write_reg(exe_to_mem_reg_dest),
    .exe_pc_plus_8(exe_to_mem_pc_plus_8),

    .exe_ALU_out(exe_ALU_out),
    .debug_pc_exe_out(exe_to_mem_debug_pc),
    .exe_bpdata(exe_bpdata),

    .exe_out_Reg_write(exe_to_mem_Reg_write),
    //.exe_out_Mem_en(data_sram_wen),
    .exe_out_Data_src(exe_to_mem_Data_src),
    .exe_out_Mem_read(exe_to_mem_Mem_read),
    .exe_Mem_write(exe_to_mem_Mem_write),
    .exe_RW_HL(exe_RW_HL),
    .exe_HL_en(exe_HL_en),
    .exe_MUL(exe_to_mem_MUL),

    .extended_A(extended_A),
    .extended_B(extended_B),

    .de_to_exe_Unalign_l(de_to_exe_Unalign_l),
    .de_to_exe_Unalign_s(de_to_exe_Unalign_s),
    .exe_to_mem_Unalign_l(exe_to_mem_Unalign_l),
    .exe_read_data_2(exe_to_mem_rdata2),
    .div_signed(div_signed),
    //data_sram
    .exe_sram_wdata(data_sram_wdata),
    .align_mem_address(data_vaddr),
    .exe_out_Mem_en(data_sram_wen),
    
    //data_sram 


    .exe_Abortion(exe_Abortion),
    .de_jorbran(de_jorbran),
    //.exe_jorbran(ex_cause_BD),
    .de_exbit(de_exbit),
    .hw_int(hw_int),
    .exception(exception),//output 
    .de_Overflow_en(de_Overflow_en),
    //.mem_jorbran(mem_jorbran),
    //cp0 registers ports
    .de_cp0_raddr(de_cp0_raddr),
    .de_cp0_rdata(de_cp0_rdata),
    .de_cp0_waddr(de_cp0_waddr),
    .de_cp0_wdata(de_cp0_wdata),
    .de_cp0_wen(de_cp0_wen),
    .de_ERET(de_ERET),
    .exe_ERET(exe_ERET),
    .cp0_epc(cp0_epc),
    .mem_access(data_access),
    .exe_div_or_prod(exe_div_or_prod),
    //cp0 registers ports
    //tlb ports 
    
    .TLB_entrylo0(tlb_entrylo0),
    .TLB_entrylo1(tlb_entrylo1),
    .TLB_entryhi(tlb_entryhi),
    .TLB_pagemask(tlb_pagemask),
    .TLBP_hit(TLBP_hit),
    .TLBP_index(TLBP_index),

    .de_to_exe_TLBP(de_to_exe_TLBP),
    .de_to_exe_TLBR(de_to_exe_TLBR),
    .de_to_exe_TLBWI(de_to_exe_TLBWI),
    .cp0_index(cp0_index),
    .cp0_entrylo0(cp0_entrylo0),
    .cp0_entrylo1(cp0_entrylo1),
    .cp0_entryhi(cp0_entryhi),
    .cp0_pagemask(cp0_pagemask),
    .exe_TLBWI(exe_TLBWI),
    //.exe_TLBP(exe_TLBP)
    //tlb ports
    .de_tlb_miss(de_tlb_miss),
    .de_tlb_invalid(de_tlb_invalid),
    .tlb_data_miss(data_tlb_miss),
    .tlb_data_invalid(data_tlb_invalid),
    .tlb_modified(data_tlb_mod),

    .exe_inst_tlb_miss(exe_inst_tlb_miss),
    .exe_inst_tlb_invalid(exe_inst_tlb_invalid),
    .pcmux_tlbref(pcmux_tlbref)
);
reg [31:0] data_r;
reg data_req_r;
reg new_access;





assign div_wait = div_block | (div_valid && new_div);// �ȴ�����complete
assign data_req = data_req_r;



assign real_div_valid = (new_div & div_valid);
always @(posedge clk)
begin
    div_block <= (~resetn)? 1'b0 : (div_complete)? 1'b0 : (div_valid && new_div)? 1'b1 : div_block; 
    new_div<=(~resetn)?1'b1: (inst_fetch)? 1'b1: (div_ready& div_valid)? 1'b0: new_div;
end




always @(posedge clk)
begin
    data_req_r <= (~resetn)? 1'b0: (data_addr_ok)? 1'b0: (~data_wait & data_access & new_access)? 1'b1: data_req_r;
    data_r <= (~resetn)? 32'b0 : (data_data_ok)? data_sram_rdata : data_r;
    data_wait <= (~resetn)? 1'b0: (data_data_ok)?1'b0:(~data_wait & data_access & new_access)? 1'b1: data_wait;
    new_access <= (~resetn)? 1'b1: (data_addr_ok)? 1'b0: (inst_fetch)? 1'b1: new_access;
end
assign data_sram_wr = |data_sram_wen;

//exe end
memory_stage mem_stage(
    .clk(clk),//input
    .rst(~resetn),//input
    //.mul_div(exe_to_mem_MUL | ),
    .exe_Abortion(exe_Abortion| exe_ERET),
    .inst_wait(inst_wait |data_wait),
    .exe_out_Reg_write(exe_to_mem_Reg_write),//input
    //.exe_out_Mem_en(exe_to_mem_mem_en),//input
    .exe_out_Data_src(exe_to_mem_Data_src),//input
    .exe_out_Mem_read(exe_to_mem_Mem_read),
    //.exe_out_Mem_write(exe_to_mem_Mem_write),
    .exe_out_MUL(exe_to_mem_MUL),
    .debug_pc_exe_out(exe_to_mem_debug_pc),//debug//input

    .exe_ALU_out(exe_ALU_out),//input
    //.exe_out_mem_data(exe_to_mem_mem_data),//input
    .exe_to_mem_rdata2(exe_to_mem_rdata2),//input 
    .exe_out_write_reg(exe_to_mem_reg_dest),//input
    .exe_out_pc_plus_8(exe_to_mem_pc_plus_8),//input
    .exe_RW_HL(exe_RW_HL),
    .exe_HL_en(exe_HL_en),
    .mem_in_data(data_r),//data ram��������//input

    //.align_mem_address(data_sram_addr),//data ram ������ַ
    //.mem_data(data_sram_wdata),//data ram д������
    //.out_Mem_en(data_sram_wen),//data ram дʹ��
    .mem_write_reg(mem_to_wb_reg_dest),
    .mem_out_data_write_back(mem_to_wb_reg_value),

    .debug_pc_mem_out(mem_to_wb_debug_pc),

    .mem_out_Reg_write(mem_to_wb_Reg_write),
    //.mem_out_MUL(mem_to_wb_MUL),
    .mem_RW_HL(mem_RW_HL),
    .mem_HL_en(mem_HL_en),
    .exe_to_mem_Unalign_l(exe_to_mem_Unalign_l),
    //.mem_access(data_access),
    .mem_invalid(mem_invalid)
    //.exception(exception),
    //.exe_Abortion(exe_Abortion)
    //.mem_jorbran(mem_jorbran)
);





//data sram end


writeback_stage wb_stage(
    .clk(clk),//input
    .rst(~resetn),//input
    //.mul_div()
    .inst_wait(inst_wait |data_wait),
    .mem_invalid(mem_invalid),
    .wb_block(Data_block | div_wait |mul_wait | inst_wait |data_wait),
    .mem_out_Reg_write(mem_to_wb_Reg_write),//input
    //.mem_out_MUL(mem_to_wb_MUL),
    .debug_pc_mem_out(mem_to_wb_debug_pc),//input
    //.mem_RW_HL(mem_RW_HL),
    //.mem_HL_en(mem_HL_en),
    .mem_dest(mem_to_wb_reg_dest),//input
    .mem_value(mem_to_wb_reg_value),//input

    .wb_rf_wen(wb_to_reg_wen),
    .wb_rf_waddr(wb_to_reg_waddr),
    .wb_rf_wdata(wb_to_reg_wdata),

    .debug_pc_wb_out(debug_wb_pc),
    //.wb_MUL(wb_MUL),
    //.wb_RW_HL(wb_RW_HL),
    //.wb_HL_en(wb_HL_en),
    .debug_Reg_write(debug_wb_rf_wen)
);
//registers 
reg_file regs(
    .clk(clk),//input
    .rst(~resetn),//input
	.waddr(wb_to_reg_waddr),//input
	.raddr1(reg_raddr1),//input
	.raddr2(reg_raddr2),//input
	.wen(wb_to_reg_wen),//input
	.wdata(wb_to_reg_wdata),//input
	.rdata1(reg_rdata1),
	.rdata2(reg_rdata2)
);

//registers end
//cp0 start




//cp0 end


always @(posedge clk)
begin
    if(HI_wen) HI <= HI_wdata;
    if(LO_wen) LO <= LO_wdata;
    mul_cnt <=(exception | exe_ERET | ~resetn)? 3'b0 : (exe_to_mem_MUL && new_mul)? 3'b1 : (mul_wait)? (mul_cnt <<1) :  mul_cnt;
    new_mul <= (~resetn)? 1'b1: (inst_fetch)? 1'b1: (exe_to_mem_MUL)? 1'b0: new_mul;
end
assign mul_wait = (~resetn)? 1'b0: ((exe_to_mem_MUL & new_mul )| (|mul_cnt));
assign mul_complete = mul_cnt[2] == 1'b1;
assign HI_wen = div_complete | mul_complete | (exe_RW_HL == 2'b10);
assign LO_wen = div_complete | mul_complete | (exe_RW_HL == 2'b11);

assign HI_rdata = (HI_wen)? HI_wdata:HI;
assign LO_rdata = (LO_wen)? LO_wdata:LO;
//ע�� HI��LO����·������LW�����??????? ���Բ��ÿ�������
/*
assign HI_rdata_afterbp = (exe_RW_HL == 2'b10)? exe_bpdata:
                            (!exe_div_or_prod &&  mem_RW_HL == 2'b10)? mem_bpdata:
                            HI_rdata;
assign LO_rdata_afterbp = (exe_RW_HL == 2'b11)? exe_bpdata: 
                            (!exe_div_or_prod && mem_RW_HL == 2'b11)? mem_bpdata:
                            LO_rdata;

assign HI_wdata = ({32{div_complete}}) & div_rem
                    | ({32{mul_complete}}) & mul_res[63:32]
                    | ({32{wb_RW_HL == 2'b10}}) & wb_to_reg_wdata;

assign LO_wdata = ({32{div_complete}}) & div_quo
                    | ({32{mul_complete}}) & mul_res[31:0]
                    | ({32{wb_RW_HL == 2'b11}}) & wb_to_reg_wdata;
*/
assign HI_rdata_afterbp = HI_rdata;
assign LO_rdata_afterbp = LO_rdata;
assign HL_to_de_rdata = (de_RW_HL[0] == 1'b0)? HI_rdata_afterbp:LO_rdata_afterbp;
assign HI_wdata = ({32{div_complete}}) & div_rem
                    | ({32{mul_complete}}) & mul_res[63:32]
                    | ({32{exe_RW_HL == 2'b10}}) & exe_ALU_out;

assign LO_wdata = ({32{div_complete}}) & div_quo
                    | ({32{mul_complete}}) & mul_res[31:0]
                    | ({32{exe_RW_HL == 2'b11}}) & exe_ALU_out;
//registers end
/*Multiplier mul(
    .A(extended_A[32:0]),
    .B(extended_B[32:0]),
    .CLK(clk),
    .P(mul_res)
);*/
mul mul(
    .clk(clk),
    .x(extended_A[32:0]),
    .y(extended_B[32:0]),
    .result_test(mul_res)
);
/*
Divider div(
    .s_axis_divisor_tdata(extended_B),
    .s_axis_divisor_tready(divisor_ready),
    .s_axis_divisor_tvalid(div_valid),
    .s_axis_dividend_tdata(extended_A),
    .s_axis_dividend_tready(dividend_ready),
    .s_axis_dividend_tvalid(div_valid),
    .aclk(clk),
    .m_axis_dout_tdata(div_res),
    .m_axis_dout_tvalid(div_complete)
);
*/



My_divider div(
    .divisor(extended_B[31:0]),
    .dividend(extended_A[31:0]),
    .div_ready(div_ready),
    .div_valid(div_valid),
    .div_signed(div_signed),
    .div_clk(clk),
    .div_resetn(resetn),
    .div_rem(div_rem),
    .div_quo(div_quo),
    .div_complete(div_complete)
    );
    
//assign div_ready = divisor_ready & dividend_ready;



// //interruput
// wire [5:0] hw_int;
// wire [5:0] real_hw_int;
// assign real_hw_int = hw_int & int_mask;


//interruput end




//MMU start
wire  tlb_except;
wire  vaddr_mapped;

assign tlb_except = (inst_tlb_miss | inst_tlb_invalid)
                    |(de_tlb_miss | de_tlb_invalid)
                    |(exe_inst_tlb_miss | exe_inst_tlb_invalid);

assign inst_paddr =(tlb_except)? 32'hbfc00000 : (inst_vaddr[31] )? inst_vaddr : tlb_inst_paddr;
assign data_paddr = (data_vaddr[31] )? data_vaddr : tlb_data_paddr;
assign data_sram_addr = data_paddr;
//MMU end
assign inst_sram_addr = inst_paddr;
assign vaddr_mapped = ~inst_vaddr[31];

//TLB module 



assign inst_tlb_miss = inst_tlb_exception == 2'b01 && inst_vaddr[31] == 1'b0;
assign inst_tlb_invalid = inst_tlb_exception == 2'b10&& inst_vaddr[31] == 1'b0;
assign data_tlb_miss = data_tlb_exception == 2'b01&& data_vaddr[31] == 1'b0 ;
assign data_tlb_invalid = data_tlb_exception == 2'b10&& data_vaddr[31] == 1'b0;
assign data_tlb_mod = data_tlb_exception == 2'b11 &&data_vaddr[31] == 1'b0 ;


TLB TLB_instance(
    .clk(clk), //input 
    .rst(~resetn), //input 
    .inst_vaddr(inst_vaddr), //input 
    .data_vaddr(data_vaddr), //input 
    .EntryHi(cp0_entryhi), //input 
    .PageMask(cp0_pagemask), //input 
    .EntryLo0(cp0_entrylo0), //input 
    .EntryLo1(cp0_entrylo1), //input 
    .Index(cp0_index), //input 
    .wen(exe_TLBWI), //input 

    .inst_paddr(tlb_inst_paddr),
    .data_paddr(tlb_data_paddr),
    .inst_hit(tlb_inst_hit),
    .data_hit(tlb_data_hit),
    //.inst_pfn(),
    .inst_v(tlb_inst_v),
    .inst_c(tlb_inst_c),
    .inst_d(tlb_inst_d),

    //.data_pfn(),
    .data_v(tlb_data_v),
    .data_c(tlb_data_c),
    .data_d(tlb_data_d),

    .read_EntryHi(tlb_entryhi),
    .read_PageMask(tlb_pagemask),
    .read_EntryLo0(tlb_entrylo0),
    .read_EntryLo1(tlb_entrylo1),
    .PIndex(TLBP_index[4:0]),
    .p_hit(TLBP_hit),
    .inst_tlb_exception(inst_tlb_exception),   //01--refill;10--invalid;11--modify;00--nothing
    .data_tlb_exception(data_tlb_exception)
);




//TLB end

endmodule
