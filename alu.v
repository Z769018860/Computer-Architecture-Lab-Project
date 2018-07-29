`ifdef PRJ1_FPGA_IMPL
//	 the board does not have enough GPIO, so we implement a 4-bit ALU
    `define DATA_WIDTH 4
`else
    `define DATA_WIDTH 32
`endif
//testbench 需要将alu文件注释为4位后使用
`ifdef PRJ1_FPGA_IMPL
//	 the board does not have enough GPIO, so we implement a 4-bit ALU
    `define ADD_ZERO 3//用0补齐信号位数的长度
`else
    `define ADD_ZERO 31
`endif

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [3:0] ALUop,
	output  Overflow,
	output  CarryOut,
	output  Zero,
	output  [`DATA_WIDTH - 1:0] Result
);

wire [`DATA_WIDTH-1:0]Sum, And, Or, Slt, B_temp, SLL, SLTU, LUI, NOR, XOR;
wire [`DATA_WIDTH-1:0]SLLV, SRL, SRLV, SRA, SRAV;
wire EXtendedsign;//记录无符号进位的附加位

assign Result =  {`DATA_WIDTH{~ALUop[3]&~ALUop[2]&~ALUop[1]&~ALUop[0]}} & And//ALUop=000,&运算
                |{`DATA_WIDTH{~ALUop[3]&~ALUop[2]&~ALUop[1]& ALUop[0]}} & Or//ALUop = 001, |运算
                |{`DATA_WIDTH{~ALUop[3]&~ALUop[2]& ALUop[1]&~ALUop[0]}} & Sum//ALUop = 010,+运算
                |{`DATA_WIDTH{~ALUop[3]& ALUop[2]& ALUop[1]&~ALUop[0]}} & Sum//ALUop = 110,-运算
                |{`DATA_WIDTH{~ALUop[3]& ALUop[2]& ALUop[1]& ALUop[0]}} & Slt//ALUop = 111,SLT 
                |{`DATA_WIDTH{~ALUop[3]&~ALUop[2]& ALUop[1]& ALUop[0]}} & SLL//ALUop = 011,SLL
                |{`DATA_WIDTH{~ALUop[3]& ALUop[2]&~ALUop[1]&~ALUop[0]}} & SLTU//ALUop = 100, SLTU
                |{`DATA_WIDTH{~ALUop[3]& ALUop[2]&~ALUop[1]& ALUop[0]}} & LUI //ALUop = 101, LUI
                |{`DATA_WIDTH{ ALUop[3]&~ALUop[2]&~ALUop[1]&~ALUop[0]}} & NOR//ALUop = 1000, NOR
                |{`DATA_WIDTH{ ALUop[3]&~ALUop[2]&~ALUop[1]& ALUop[0]}} & XOR//ALUop = 1001, XOR
                |{`DATA_WIDTH{ ALUop[3]&~ALUop[2]& ALUop[1]&~ALUop[0]}} & SLLV//ALUop = 1010, SLLV
                |{`DATA_WIDTH{ ALUop[3]&~ALUop[2]& ALUop[1]& ALUop[0]}} & SRL//ALUop = 1011, SRL
                |{`DATA_WIDTH{ ALUop[3]& ALUop[2]&~ALUop[1]&~ALUop[0]}} & SRLV//ALUop = 1100, SRLV
                |{`DATA_WIDTH{ ALUop[3]& ALUop[2]&~ALUop[1]& ALUop[0]}} & SRA//ALUop = 1101, SRA
                |{`DATA_WIDTH{ ALUop[3]& ALUop[2]& ALUop[1]&~ALUop[0]}} & SRAV;//ALUop = 1110, SRAV

assign And = A&B;//&运算
assign Or = A|B;//|运算
assign B_temp = B^{`DATA_WIDTH{ALUop[2]}};//B的原码或反码
assign {EXtendedsign, Sum}= {1'b0,A[`DATA_WIDTH-1:0]} + {1'b0,B_temp[`DATA_WIDTH-1:0]} +  {`DATA_WIDTH'b0,ALUop[2]};//原码加法或补码减法
assign CarryOut = EXtendedsign ^ ALUop[2]; //Carryout定义
assign Overflow = A[`DATA_WIDTH-1]&B_temp[`DATA_WIDTH-1]&~Sum[`DATA_WIDTH-1]|~A[`DATA_WIDTH-1]&~B_temp[`DATA_WIDTH-1]&Sum[`DATA_WIDTH-1];//教材上Overflow定义 
assign Slt = {`ADD_ZERO'b0,Sum[`DATA_WIDTH-1] ^ Overflow};//小于：减法符号位1，未溢出；或减法符号位0但是溢出
assign Zero = ~|Result;//判断Result是否是0
assign SLTU = {`ADD_ZERO'b0,CarryOut};//无符号SLT
assign LUI = {B[15:0], 16'b0};
assign NOR = ~Or;
assign XOR = A^B;

assign SLL = B<<A[10:6];//左移立即数
assign SLLV = B<<A[4:0];//左移寄存器
assign SRL = B>>A[10:6];//右移立即数
assign SRLV = B>>A[4:0];//右移寄存器

assign SRA = (A[10:6] == 5'b0)? B : SRL  | ({32{B[31]}}<<(6'd32-A[10:6])) ;//算术右移立即数
assign SRAV =(A[4:0] == 5'b0)?  B: SRLV  | ({32{B[31]}}<<(6'd32-A[4:0]));//算术右移寄存器
endmodule