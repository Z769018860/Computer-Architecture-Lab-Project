module mycpu_top(
    input resetn,
    input clk,
    input [5:0] hw_int,

    output [3:0]  cpu_arid         ,
    output [31:0] cpu_araddr       ,    //read address
    output [7 :0] cpu_arlen        ,
    output [2 :0] cpu_arsize       ,
    output [1 :0] cpu_arburst      ,
    output [1 :0] cpu_arlock       ,
    output [3 :0] cpu_arcache      ,
    output [2 :0] cpu_arprot       ,
    output        cpu_arvalid      ,
    input         cpu_arready      ,
    //r           
    input  [3 :0] cpu_rid          ,
    input  [31:0] cpu_rdata        ,
    input  [1 :0] cpu_rresp        ,
    input         cpu_rlast        ,
    input         cpu_rvalid       ,
    output        cpu_rready       ,
    //aw          
    output [3 :0] cpu_awid         ,
    output [31:0] cpu_awaddr       ,
    output [7 :0] cpu_awlen        ,
    output [2 :0] cpu_awsize       ,
    output [1 :0] cpu_awburst      ,
    output [1 :0] cpu_awlock       ,
    output [3 :0] cpu_awcache      ,
    output [2 :0] cpu_awprot       ,
    output        cpu_awvalid      ,
    input         cpu_awready      ,
    //w          
    output [3 :0] cpu_wid          ,
    output [31:0] cpu_wdata        ,
    output [3 :0] cpu_wstrb        ,
    output        cpu_wlast        ,
    output        cpu_wvalid       ,
    input         cpu_wready       ,
    //b           
    input  [3 :0] cpu_bid          ,
    input  [1 :0] cpu_bresp        ,
    input         cpu_bvalid       ,
    output        cpu_bready       ,

  (*mark_debug = "true"*)   output [31:0] debug_wb_pc      ,
  (*mark_debug = "true"*)   output [3:0]  debug_wb_rf_wen  ,
  (*mark_debug = "true"*)   output [4:0]  debug_wb_rf_wnum ,
  (*mark_debug = "true"*)   output [31:0] debug_wb_rf_wdata
);

(*mark_debug = "true"*) wire inst_req;
(*mark_debug = "true"*) wire inst_wr;
//wire [1:0] inst_size;
(*mark_debug = "true"*) wire [31:0] inst_addr;
(*mark_debug = "true"*) wire [31:0] inst_wdata;
(*mark_debug = "true"*) wire [3:0]  inst_able;
(*mark_debug = "true"*) wire [31:0] inst_rdata;
(*mark_debug = "true"*) wire inst_addr_ok;
(*mark_debug = "true"*) wire inst_data_ok;


wire data_req;
wire data_wr;
//wire [1:0] data_size;
wire [31:0] data_addr;
wire [31:0] data_wdata;
wire [3:0]  data_able;
wire [31:0] data_rdata;
wire data_addr_ok;
wire data_data_ok;

reg resetn_r;


always @(posedge clk)
begin
resetn_r <= resetn;

end


mips_cpu cpu_core
(
    .resetn(resetn_r),
    .clk(clk),
    .hw_int(hw_int),

    .inst_req(inst_req),
    .inst_sram_wr(inst_wr),
    .inst_sram_wen(inst_able),
    .inst_sram_addr(inst_addr),
    .inst_sram_wdata(inst_wdata),
    .inst_sram_rdata(inst_rdata),
    .inst_addr_ok(inst_addr_ok),
    .inst_data_ok(inst_data_ok),

    .data_req(data_req),
    .data_sram_wr(data_wr),
    .data_sram_wen(data_able),
    .data_sram_addr(data_addr),
    .data_sram_wdata(data_wdata),
    .data_sram_rdata(data_rdata),
    .data_addr_ok(data_addr_ok),
    .data_data_ok(data_data_ok),


    .debug_wb_pc(debug_wb_pc),
    .debug_wb_rf_wen(debug_wb_rf_wen),
    .debug_wb_rf_wnum(debug_wb_rf_wnum),
    .debug_wb_rf_wdata(debug_wb_rf_wdata)

);

cpu_axi_interface myinterface(
    .clk(clk),
    .resetn(resetn),

    .inst_req(inst_req)         ,
    .inst_wr(inst_wr)           ,    //1 write
    .inst_size(2'b0)            ,    //0-1byte 1-2 2-4
    .inst_addr(inst_addr)       ,
    .inst_wdata(inst_wdata)     ,
    .inst_able(inst_able)       ,
    .inst_rdata(inst_rdata)     ,
    .inst_addr_ok(inst_addr_ok) ,
    .inst_data_ok(inst_data_ok) ,
    
    //data sram-like 
    .data_req(data_req)         ,
    .data_wr(data_wr)           ,    //1 write
    .data_size(2'b0)            ,    //0-1byte 1-2 2-4
    .data_addr(data_addr)       ,
    .data_wdata(data_wdata)     ,
    .data_able(data_able)       ,
    .data_rdata(data_rdata)     ,
    .data_addr_ok(data_addr_ok) ,
    .data_data_ok(data_data_ok) ,

    //axi
    //ar
    .arid(cpu_arid)             ,
    .araddr(cpu_araddr)         ,    //read address
    .arlen(cpu_arlen)           ,
    .arsize(cpu_arsize)         ,
    .arburst(cpu_arburst)       ,
    .arlock(cpu_arlock)         ,
    .arcache(cpu_arcache)       ,
    .arprot(cpu_arprot)         ,
    .arvalid(cpu_arvalid)       ,
    .arready(cpu_arready)       ,
    //r           
    .rid(cpu_rid)               ,
    .rdata(cpu_rdata)           ,
    .rresp(cpu_rresp)           ,
    .rlast(cpu_rlast)           ,
    .rvalid(cpu_rvalid)         ,
    .rready(cpu_rready)         ,
    //aw          
    .awid(cpu_awid)             ,
    .awaddr(cpu_awaddr)         ,
    .awlen(cpu_awlen)           ,
    .awsize(cpu_awsize)         ,
    .awburst(cpu_awburst)       ,
    .awlock(cpu_awlock)         ,
    .awcache(cpu_awcache)       ,
    .awprot(cpu_awprot)         ,
    .awvalid(cpu_awvalid)       ,
    .awready(cpu_awready)       ,
    //w          
    .wid(cpu_wid)               ,
    .wdata(cpu_wdata)           ,
    .wstrb(cpu_wstrb)           ,
    .wlast(cpu_wlast)           ,
    .wvalid(cpu_wvalid)         ,
    .wready(cpu_wready)         ,
    //b           
    .bid(cpu_bid)               ,
    .bresp(cpu_bresp)           ,
    .bvalid(cpu_bvalid)         ,
    .bready(cpu_bready)       
);


endmodule