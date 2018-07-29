`ifdef PRJ1_FPGA_IMPL
	// the board does not have enough GPIO, so we implement 4 4-bit registers
    `define DATA_WIDTH 4
	`define ADDR_WIDTH 2
`else
   `define DATA_WIDTH 32
	`define ADDR_WIDTH 5
`endif

module reg_file(
	input clk,
	input rst,
	input [`ADDR_WIDTH - 1:0] waddr,
	input [`ADDR_WIDTH - 1:0] raddr1,
	input [`ADDR_WIDTH - 1:0] raddr2,
	input wen,
	input [`DATA_WIDTH - 1:0] wdata,
	output [`DATA_WIDTH - 1:0] rdata1,
	output [`DATA_WIDTH - 1:0] rdata2
);

reg [`DATA_WIDTH-1:0]  register [0:2**`ADDR_WIDTH - 1];
assign rdata1 = (wen && waddr == raddr1)? wdata : register[raddr1];//经过修改 同时取回和写数时，读wdata

assign rdata2 = (wen && waddr == raddr2)? wdata : register[raddr2];//经过修改 同时取回和写数时，读wdata


always @(posedge clk)
begin
	if(wen && |waddr ) register[waddr] <= wdata;//写锟斤拷锟斤拷锟斤拷
    register[0] <= `DATA_WIDTH'b0;//锟斤拷址为0锟侥寄达拷锟斤拷锟斤拷为0
end
endmodule
