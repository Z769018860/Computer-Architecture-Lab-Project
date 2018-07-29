module wallace(

    input [16:0] switch_to_wall,

    input [14:0] cin,
    output[14:0] cout, 


  /*  input A_16,
    input B_15,
    input C_14,
    input A_13,
    input B_12,
    input C_11,
    input A_10,
    input B_9,
    input C_8,
    input A_7,
    input B_6,
    input C_5,
    input A_4,
    input B_3,
    input C_2,
    input O_1,
    input O_0,*/

    /*input cin_0,
    input cin_1,
    input cin_2,
    input cin_3,
    input cin_4,
    input cin_5,
    input cin_6,
    input cin_7,
    input cin_8,
    input cin_9,
    input cin_10,
    input cin_11,
    input cin_12,
    input cin_13,*/

    output C,
    output S

   /* output cout_0,
    output cout_1,
    output cout_2,
    output cout_3,
    output cout_4,
    output cout_5,
    output cout_6,
    output cout_7,
    output cout_8,
    output cout_9,
    output cout_10,
    output cout_11,
    output cout_12,
    output cout_13,*/

);

wire A_16;
wire B_15;
wire C_14;
wire A_13;
wire B_12;
wire C_11;
wire A_10;
wire B_9;
wire C_8;
wire A_7;
wire B_6;
wire C_5;
wire A_4;
wire B_3;
wire C_2;
wire O_1;
wire O_0;

//wire O_for_17;

assign A_16=switch_to_wall[16];
assign B_15=switch_to_wall[15];
assign C_14=switch_to_wall[14];
assign A_13=switch_to_wall[13];
assign B_12=switch_to_wall[12];
assign C_11=switch_to_wall[11];
assign A_10=switch_to_wall[10];
assign B_9=switch_to_wall[9];
assign C_8=switch_to_wall[8];
assign A_7=switch_to_wall[7];
assign B_6=switch_to_wall[6];
assign C_5=switch_to_wall[5];
assign A_4=switch_to_wall[4];
assign B_3=switch_to_wall[3];
assign C_2=switch_to_wall[2];
assign O_1=switch_to_wall[1];
assign O_0=switch_to_wall[0];

//assign O_for_17=cin[0];

wire cin_0;
wire cin_1;
wire cin_2;
wire cin_3;
wire cin_4;
wire cin_5;
wire cin_6;
wire cin_7;
wire cin_8;
wire cin_9;
wire cin_10;
wire cin_11;
wire cin_12;
wire cin_13;
wire cin_14;

assign cin_0 = cin[0];
assign cin_1 = cin[1];
assign cin_2 = cin[2];
assign cin_3 = cin[3];
assign cin_4 = cin[4];
assign cin_5 = cin[5];
assign cin_6 = cin[6];
assign cin_7 = cin[7];
assign cin_8 = cin[8];
assign cin_9 = cin[9];
assign cin_10 = cin[10];
assign cin_11 = cin[11];
assign cin_12 = cin[12];
assign cin_13 = cin[13];
assign cin_14 = cin[14];


wire cout_0;
wire cout_1;
wire cout_2;
wire cout_3;
wire cout_4;
wire cout_5;
wire cout_6;
wire cout_7;
wire cout_8;
wire cout_9;
wire cout_10;
wire cout_11;
wire cout_12;
wire cout_13;
wire cout_14;
wire S_ban;
assign cout_0=O_0&O_1;
assign S_ban=O_0^O_1;


/*assign cout_0 = cout[0];
assign cout_1 = cout[1];
assign cout_2 = cout[2];
assign cout_3 = cout[3];
assign cout_4 = cout[4];
assign cout_5 = cout[5];
assign cout_6 = cout[6];
assign cout_7 = cout[7];
assign cout_8 = cout[8];
assign cout_9 = cout[9];
assign cout_10 = cout[10];
assign cout_11 = cout[11];
assign cout_12 = cout[12];
assign cout_13 = cout[13];*/






wire S_A_1_1;

add add_1_1(
    .A(A_16),
    .B(B_15),
    .Cin(C_14),

    .S(S_A_1_1),
    .Cout(cout_5) 
);

wire S_B_1_2;
add add_1_2(
    .A(A_13),
    .B(B_12),
    .Cin(C_11),

    .S(S_B_1_2),
    .Cout(cout_4) 
);

wire S_C_1_3;

add add_1_3(
    .A(A_10),
    .B(B_9),
    .Cin(C_8),

    .S(S_C_1_3),
    .Cout(cout_3) 
);

wire S_A_1_4;
add add_1_4(
    .A(A_7),
    .B(B_6),
    .Cin(C_5),

    .S(S_A_1_4),
    .Cout(cout_2) 
);
wire S_B_1_5;
add add_1_5(
    .A(A_4),
    .B(B_3),
    .Cin(C_2),

    .S(S_B_1_5),
    .Cout(cout_1) 
);

wire S_A_2_1;
add add_2_1(
    .A(S_A_1_1),
    .B(S_B_1_2),
    .Cin(S_C_1_3),

    .S(S_A_2_1),
    .Cout(cout_9) 
);


wire S_B_2_2;
add add_2_2(
    .A(S_A_1_4),
    .B(S_B_1_5),
    .Cin(S_ban),

    .S(S_B_2_2),
    .Cout(cout_8) 
);

wire S_C_2_3;
add add_2_3(
    .A(cin_5),
    .B(cin_4),
    .Cin(cin_3),

    .S(S_C_2_3),
    .Cout(cout_7) 
);


wire S_A_2_4;
add add_2_4(
    .A(cin_2),
    .B(cin_1),
    .Cin(cin_0),

    .S(S_A_2_4),
    .Cout(cout_6) 
);


wire S_A_3_1;
add add_3_1(
    .A(S_A_2_1),
    .B(S_B_2_2),
    .Cin(S_C_2_3),

    .S(S_A_3_1),
    .Cout(cout_11) 
);

wire S_B_3_2;
add add_3_2(
    .A(S_A_2_4),
    .B(cin_7),
    .Cin(cin_6),

    .S(S_B_3_2),
    .Cout(cout_10) 
);

wire S_A_4_1;
add add_4_1(
    .A(S_A_3_1),
    .B(S_B_3_2),
    .Cin(cin_11),

    .S(S_A_4_1),
    .Cout(cout_13) 
);


wire S_B_4_2;
add add_4_2(
    .A(cin_10),
    .B(cin_9),
    .Cin(cin_8),

    .S(S_B_4_2),
    .Cout(cout_12) 
);
wire S_A_5_1;
add add_5_1(
    .A(S_A_4_1),
    .B(S_B_4_2),
    .Cin(cin_12),

    .S(S_A_5_1),
    .Cout(cout_14) 
);


add add_6_1(
    .A(S_A_5_1),
    .B(cin_14),
    .Cin(cin_13),

    .S(S),
    .Cout(C) 
);


assign cout={cout_14,cout_13,cout_12,cout_11,cout_10,cout_9,cout_8,cout_7,cout_6,cout_5,cout_4,cout_3,cout_2,cout_1,cout_0};

endmodule