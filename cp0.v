`define DATA_WIDTH 32
`define ADDR_WIDTH 5

module cp0_rf(
	input clk,
	input rst,
	input [4:0] waddr,
	input [4:0] raddr1,
	//input [4:0] raddr2,
    input [2:0] sel,
	input wen,
	input [31:0] wdata,
	output [31:0] rdata1,
	//output [31:0] rdata2
	intput 
);

reg [31:0]  register [0:31];
assign rdata1 = (wen && waddr == raddr1)? wdata : register[raddr1];

//assign rdata2 = (wen && waddr == raddr2)? wdata : register[raddr2];


always @(posedge clk)
begin
	if(wen && |waddr ) register[waddr] <= wdata;
    register[0] <= `DATA_WIDTH'b0;
end
endmodule
