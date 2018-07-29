module cpu_axi_interface
(
    input         clk,
    input         resetn, 

    //inst sram-like 
    input         inst_req     ,
    input         inst_wr      ,    //1 write
    input  [1 :0] inst_size    ,    //0-1byte 1-2 2-4
    input  [31:0] inst_addr    ,
    input  [31:0] inst_wdata   ,
    input  [3:0]  inst_able    ,
    output [31:0] inst_rdata   ,
    output        inst_addr_ok ,
    output        inst_data_ok ,
    
    //data sram-like 
    input         data_req     ,
    input         data_wr      ,
    input  [1 :0] data_size    ,
    input  [31:0] data_addr    ,
    input  [31:0] data_wdata   ,
    input  [3:0]  data_able    ,
    output [31:0] data_rdata   ,
    output        data_addr_ok ,
    output        data_data_ok ,

    //axi
    //ar
    output [3 :0] arid         ,
    output [31:0] araddr       ,    //read address
    output [7 :0] arlen        ,
    output [2 :0] arsize       ,
    output [1 :0] arburst      ,
    output [1 :0] arlock        ,
    output [3 :0] arcache      ,
    output [2 :0] arprot       ,
    output        arvalid      ,
    input         arready      ,
    //r           
    input  [3 :0] rid          ,
    input  [31:0] rdata        ,
    input  [1 :0] rresp        ,
    input         rlast        ,
    input         rvalid       ,
    output        rready       ,
    //aw          
    output [3 :0] awid         ,
    output [31:0] awaddr       ,
    output [7 :0] awlen        ,
    output [2 :0] awsize       ,
    output [1 :0] awburst      ,
    output [1 :0] awlock       ,
    output [3 :0] awcache      ,
    output [2 :0] awprot       ,
    output        awvalid      ,
    input         awready      ,
    //w          
    output [3 :0] wid          ,
    output [31:0] wdata        ,
    output [3 :0] wstrb        ,
    output        wlast        ,
    output        wvalid       ,
    input         wready       ,
    //b           
    input  [3 :0] bid          ,
    input  [1 :0] bresp        ,
    input         bvalid       ,
    output        bready       
);

reg data_req_doing;
reg data_req_wr;
reg [1:0] data_req_size;
reg [31:0] data_req_addr;
reg [31:0] data_req_wdata;
reg [3:0]  data_req_able;

reg inst_req_doing;
reg inst_req_wr;
reg [1:0] inst_req_size;
reg [31:0] inst_req_addr;
reg [31:0] inst_req_wdata;
reg [3:0]  inst_req_able;




assign data_addr_ok = !data_req_doing&&data_req&&!inst_req_doing;
assign inst_addr_ok = !inst_req_doing&&inst_req&&!data_req_doing;

assign inst_rdata = rdata;
assign data_rdata = rdata;




//-------------------------------------------------------------
//  steady signal
assign arid = 4'b0;
assign arlen = 8'b0;
assign arburst = 2'b01;
assign arlock = 2'b0;
assign arcache = 4'b0;
assign arprot = 3'b0;

assign rid = 4'b0;
assign rresp = 2'b0;
assign rlast = 1'b0;

assign awid = 4'b0;
assign awlen = 8'b0;
assign awburst = 2'b01;
assign awlock = 2'b0;
assign awcache = 4'b0;
assign awprot = 3'b0;


assign wid = 4'b0;
assign wlast = 1'b1;

assign bid = 4'b0;
assign bresp = 2'b0;
//--------------------------------------------------------------
//states
reg read_addr_received;
reg write_addr_received;
reg write_wdata_received;

wire read_done;
wire data_req_done;
wire write_done;
wire inst_req_done;
assign read_done = read_addr_received&&(rvalid&&rready);
assign write_done = write_addr_received&&(bvalid&&bready);

//assign data_req_done = (~inst_req_doing||inst_req_wr)&&data_req_doing&&((read_done&&!data_req_wr)||(write_done&&data_req_wr));
assign data_req_done = data_req_doing&&((read_done&&!data_req_wr)||(write_done&&data_req_wr));
assign inst_req_done = (~data_req_doing||data_req_wr)&&inst_req_doing&&((read_done&&!inst_req_wr)||(write_done&&inst_req_wr));

always@(posedge clk)
begin
  read_addr_received <= ~resetn? 1'b0:
                        (arvalid&&arready)? 1'b1:
                        read_done? 1'b0:read_addr_received;
  write_addr_received <= ~resetn? 1'b0:
                         (awvalid&&awready)? 1'b1:
                         write_done? 1'b0: write_addr_received;
  write_wdata_received <= ~resetn? 1'b0:
                          (wvalid&&wready)? 1'b1:
                          write_done? 1'b0:
                          write_wdata_received;
end

//--------------------------------------------------------
//other signals
wire [2:0] req_size;
wire [31:0] req_addr;
wire req_doing;
wire req_wr;

wire [31:0] modify_data_addr;
wire [31:0] modify_inst_addr;
wire [1:0] modify_data_size;
wire [1:0] modify_inst_size;

assign modify_data_addr = (data_req_able==4'b0001)?data_req_addr+32'b0:
                          (data_req_able==4'b0010)?data_req_addr+32'b1:
                          (data_req_able==4'b0100)?data_req_addr+32'd2:
                          (data_req_able==4'b1000)?data_req_addr+32'd3:
                          (data_req_able==4'b0011)?data_req_addr+32'b0:
                          (data_req_able==4'b1100)?data_req_addr+32'd2:
                          (data_req_able==4'b0111)?data_req_addr+32'b0:
                          (data_req_able==4'b1110)?data_req_addr+32'b1:
                          (data_req_able==4'b1111)?data_req_addr+32'b0:
                          data_req_addr;
assign modify_inst_addr = (inst_req_able==4'b0001)?inst_req_addr+32'b0:
                          (inst_req_able==4'b0010)?inst_req_addr+32'b1:
                          (inst_req_able==4'b0100)?inst_req_addr+32'd2:
                          (inst_req_able==4'b1000)?inst_req_addr+32'd3:
                          (inst_req_able==4'b0011)?inst_req_addr+32'b0:
                          (inst_req_able==4'b1100)?inst_req_addr+32'd2:
                          (inst_req_able==4'b0111)?inst_req_addr+32'b0:
                          (inst_req_able==4'b1110)?inst_req_addr+32'b1:
                          (inst_req_able==4'b1111)?inst_req_addr+32'b0:
                          inst_req_addr;

assign modify_data_size = (data_req_able==4'b0001)?2'b0:
                          (data_req_able==4'b0010)?2'b0:
                          (data_req_able==4'b0100)?2'b0:
                          (data_req_able==4'b1000)?2'b0:
                          (data_req_able==4'b0011)?2'b1:
                          (data_req_able==4'b1100)?2'b1:
                          (data_req_able==4'b0111)?2'b10:
                          (data_req_able==4'b1110)?2'b10:
                          (data_req_able==4'b1111)?2'b10:
                          2'b10;


assign modify_inst_size = (inst_req_able==4'b0001)?2'b0:
                          (inst_req_able==4'b0010)?2'b0:
                          (inst_req_able==4'b0100)?2'b0:
                          (inst_req_able==4'b1000)?2'b0:
                          (inst_req_able==4'b0011)?2'b1:
                          (inst_req_able==4'b1100)?2'b1:
                          (inst_req_able==4'b0111)?2'b10:
                          (inst_req_able==4'b1110)?2'b10:
                          (inst_req_able==4'b1111)?2'b10:
                          2'b10;



assign araddr = (data_req_doing&&!data_req_wr)? modify_data_addr:modify_inst_addr;
assign arsize = (data_req_doing&&!data_req_wr)? modify_data_size:modify_inst_size;
assign arvalid = ((data_req_doing&&!data_req_wr)||(inst_req_doing&&!inst_req_wr))
                 &&!read_addr_received;

assign rready = 1'b1;

assign awaddr = (data_req_doing&&data_req_wr)? modify_data_addr:modify_inst_addr;
assign awsize = (data_req_doing&&data_req_wr)? modify_data_size:modify_inst_size;
assign awvalid = ((data_req_doing&&data_req_wr)||(inst_req_doing&&inst_req_wr))
                 &&!write_addr_received;
assign wdata = (data_req_doing&&data_req_wr)? data_req_wdata:inst_req_wdata;


assign req_size = awsize;
assign req_addr = awaddr;
//assign wstrb = (req_size==2'b0)? 4'b0001<<req_addr[1:0]:
  //             (req_size==2'b1)? 4'b0011<<req_addr[1:0]:
    //           4'b1111;
assign wstrb = (data_req_doing&&data_req_wr)?data_req_able:inst_req_able;
assign wvalid = ((data_req_doing&&data_req_wr)||(inst_req_doing&&inst_req_wr))
                &&!write_wdata_received;

assign bready = 1'b1;

assign data_data_ok = data_req_doing&&data_req_done;
assign inst_data_ok = inst_req_doing&&inst_req_done;

always@(posedge clk)
begin
  data_req_doing <=~resetn? 1'b0:
                   (data_req&&!data_req_doing&&!inst_req_doing)? 1'b1:
                   data_req_done? 1'b0:data_req_doing;
  data_req_wr <= ~resetn? 1'b0:
                 (data_req&&data_addr_ok)?data_wr:
                 data_req_wr;
  data_req_size <= ~resetn? 2'b0:
                   (data_req&&data_addr_ok)? data_size:
                   data_req_size;
  data_req_addr <= ~resetn? 32'b0:
                   (data_req&&data_addr_ok)? data_addr:
                   data_req_addr;
  data_req_wdata <= ~resetn? 32'b0:
                   (data_req&&data_addr_ok)? data_wdata:
                   data_req_wdata;
  data_req_able <= ~resetn? 4'b0:
                   (data_req&&data_addr_ok)? data_able:
                   data_req_able;
end 

wire debug;
assign debug = (~resetn)? 1'b0:
                   (inst_req&&!inst_req_doing&&!data_req_doing)? 1'b1:
                   inst_req_done? 1'b0:inst_req_doing;
always@(posedge clk)
begin
  inst_req_doing <=(~resetn)? 1'b0:
                   (inst_req&&!inst_req_doing&&!data_req_doing)? 1'b1:
                   inst_req_done? 1'b0:inst_req_doing;
  inst_req_wr <= ~resetn? 1'b0:
                 (inst_req&&inst_addr_ok)?inst_wr:
                 inst_req_wr;
  inst_req_size <= ~resetn? 2'b0:
                   (inst_req&&inst_addr_ok)? inst_size:
                   inst_req_size;
  inst_req_addr <= ~resetn? 32'b0:
                   (inst_req&&inst_addr_ok)? inst_addr:
                   inst_req_addr;
  inst_req_wdata <= ~resetn? 32'b0:
                   (inst_req&&inst_addr_ok)? inst_wdata:
                   inst_req_wdata;
  inst_req_able <= ~resetn? 4'b0:
                   (inst_req&&inst_addr_ok)?inst_able:
                   inst_req_able;
end
endmodule










