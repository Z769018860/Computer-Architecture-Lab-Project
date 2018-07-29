`ifdef PRJ1_FPGA_IMPL
//	 the board does not have enough GPIO, so we implement a 4-bit ALU
    `define DATA_WIDTH 4
`else
    `define DATA_WIDTH 32
`endif
//testbench ��Ҫ��alu�ļ�ע��Ϊ4λ��ʹ��
`ifdef PRJ1_FPGA_IMPL
//	 the board does not have enough GPIO, so we implement a 4-bit ALU
    `define ADD_ZERO 3//��0�����ź�λ���ĳ���
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
wire EXtendedsign;//��¼�޷��Ž�λ�ĸ���λ

assign Result =  {`DATA_WIDTH{~ALUop[3]&~ALUop[2]&~ALUop[1]&~ALUop[0]}} & And//ALUop=000,&����
                |{`DATA_WIDTH{~ALUop[3]&~ALUop[2]&~ALUop[1]& ALUop[0]}} & Or//ALUop = 001, |����
                |{`DATA_WIDTH{~ALUop[3]&~ALUop[2]& ALUop[1]&~ALUop[0]}} & Sum//ALUop = 010,+����
                |{`DATA_WIDTH{~ALUop[3]& ALUop[2]& ALUop[1]&~ALUop[0]}} & Sum//ALUop = 110,-����
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

assign And = A&B;//&����
assign Or = A|B;//|����
assign B_temp = B^{`DATA_WIDTH{ALUop[2]}};//B��ԭ�����
assign {EXtendedsign, Sum}= {1'b0,A[`DATA_WIDTH-1:0]} + {1'b0,B_temp[`DATA_WIDTH-1:0]} +  {`DATA_WIDTH'b0,ALUop[2]};//ԭ��ӷ��������
assign CarryOut = EXtendedsign ^ ALUop[2]; //Carryout����
assign Overflow = A[`DATA_WIDTH-1]&B_temp[`DATA_WIDTH-1]&~Sum[`DATA_WIDTH-1]|~A[`DATA_WIDTH-1]&~B_temp[`DATA_WIDTH-1]&Sum[`DATA_WIDTH-1];//�̲���Overflow���� 
assign Slt = {`ADD_ZERO'b0,Sum[`DATA_WIDTH-1] ^ Overflow};//С�ڣ���������λ1��δ��������������λ0�������
assign Zero = ~|Result;//�ж�Result�Ƿ���0
assign SLTU = {`ADD_ZERO'b0,CarryOut};//�޷���SLT
assign LUI = {B[15:0], 16'b0};
assign NOR = ~Or;
assign XOR = A^B;

assign SLL = B<<A[10:6];//����������
assign SLLV = B<<A[4:0];//���ƼĴ���
assign SRL = B>>A[10:6];//����������
assign SRLV = B>>A[4:0];//���ƼĴ���

assign SRA = (A[10:6] == 5'b0)? B : SRL  | ({32{B[31]}}<<(6'd32-A[10:6])) ;//��������������
assign SRAV =(A[4:0] == 5'b0)?  B: SRLV  | ({32{B[31]}}<<(6'd32-A[4:0]));//�������ƼĴ���
endmodule