module mul(
    input clk,
    //input resetn,
    //input mul_signed,
    input [32:0] x,
    input [32:0] y,

    output reg [65:0] result_test
);


//assign x=(mul_signed)?{x_test[31],x_test[31:0]}:{1'b0,x_test[31:0]};
//assign y=(mul_signed)?{y_test[31],y_test[31:0]}:{1'b0,y_test[31:0]};
wire [65:0] result;
always@(posedge clk)
begin
  result_test <=result[65:0];
end



wire [33:0] x_extend;
wire [33:0] y_extend;

assign x_extend={x[32],x};
assign y_extend={y[32],y};

    wire [67:0] P_16;
    wire [67:0] P_15;
    wire [67:0] P_14;
    wire [67:0] P_13;
    wire [67:0] P_12;
    wire [67:0] P_11;
    wire [67:0] P_10;
    wire [67:0] P_9;
    wire [67:0] P_8;
    wire [67:0] P_7;
    wire [67:0] P_6;
    wire [67:0] P_5;
    wire [67:0] P_4;
    wire [67:0] P_3;
    wire [67:0] P_2;
    wire [67:0] P_1;
    wire [67:0] P_0;

    wire c_16;
    wire c_15;
    wire c_14;
    wire c_13;
    wire c_12;
    wire c_11;
    wire c_10;
    wire c_9;
    wire c_8;
    wire c_7;
    wire c_6;
    wire c_5;
    wire c_4;
    wire c_3;
    wire c_2;
    wire c_1;
    wire c_0;

booth_2bit booth_0(
    .y_2(y_extend[1]),
    .y_1(y_extend[0]),
    .y_0(1'b0),
    .x(x_extend),

    .P(P_0),
    .c(c_0) 
);

booth_2bit booth_1(
    .y_2(y_extend[3]),
    .y_1(y_extend[2]),
    .y_0(y_extend[1]),
    .x(x_extend),

    .P(P_1),
    .c(c_1) 
);

booth_2bit booth_2(
    .y_2(y_extend[5]),
    .y_1(y_extend[4]),
    .y_0(y_extend[3]),
    .x(x_extend),

    .P(P_2),
    .c(c_2) 
);
booth_2bit booth_3(
    .y_2(y_extend[7]),
    .y_1(y_extend[6]),
    .y_0(y_extend[5]),
    .x(x_extend),

    .P(P_3),
    .c(c_3) 
);
booth_2bit booth_4(
    .y_2(y_extend[9]),
    .y_1(y_extend[8]),
    .y_0(y_extend[7]),
    .x(x_extend),

    .P(P_4),
    .c(c_4) 
);
booth_2bit booth_5(
    .y_2(y_extend[11]),
    .y_1(y_extend[10]),
    .y_0(y_extend[9]),
    .x(x_extend),

    .P(P_5),
    .c(c_5) 
);
booth_2bit booth_6(
    .y_2(y_extend[13]),
    .y_1(y_extend[12]),
    .y_0(y_extend[11]),
    .x(x_extend),

    .P(P_6),
    .c(c_6) 
);
booth_2bit booth_7(
    .y_2(y_extend[15]),
    .y_1(y_extend[14]),
    .y_0(y_extend[13]),
    .x(x_extend),

    .P(P_7),
    .c(c_7) //////////////////////////
);
booth_2bit booth_8(
    .y_2(y_extend[17]),
    .y_1(y_extend[16]),
    .y_0(y_extend[15]),
    .x(x_extend),

    .P(P_8),
    .c(c_8) 
);
booth_2bit booth_9(
    .y_2(y_extend[19]),
    .y_1(y_extend[18]),
    .y_0(y_extend[17]),
    .x(x_extend),

    .P(P_9),
    .c(c_9) 
);
booth_2bit booth_10(
    .y_2(y_extend[21]),
    .y_1(y_extend[20]),
    .y_0(y_extend[19]),
    .x(x_extend),

    .P(P_10),
    .c(c_10) 
);
booth_2bit booth_11(
    .y_2(y_extend[23]),
    .y_1(y_extend[22]),
    .y_0(y_extend[21]),
    .x(x_extend),

    .P(P_11),
    .c(c_11) 
);
booth_2bit booth_12(
    .y_2(y_extend[25]),
    .y_1(y_extend[24]),
    .y_0(y_extend[23]),
    .x(x_extend),

    .P(P_12),
    .c(c_12) 
);
booth_2bit booth_13(
    .y_2(y_extend[27]),
    .y_1(y_extend[26]),
    .y_0(y_extend[25]),
    .x(x_extend),

    .P(P_13),
    .c(c_13) 
);
booth_2bit booth_14(
    .y_2(y_extend[29]),
    .y_1(y_extend[28]),
    .y_0(y_extend[27]),
    .x(x_extend),

    .P(P_14),
    .c(c_14) 
);
booth_2bit booth_15(
    .y_2(y_extend[31]),
    .y_1(y_extend[30]),
    .y_0(y_extend[29]),
    .x(x_extend),

    .P(P_15),
    .c(c_15) 
);

booth_2bit booth_16(
    .y_2(y_extend[33]),
    .y_1(y_extend[32]),
    .y_0(y_extend[31]),
    .x(x_extend),

    .P(P_16),
    .c(c_16) 
);

    wire [16:0] c;
    wire [16:0] In_wallace_0;
    wire [16:0] In_wallace_1;
    wire [16:0] In_wallace_2;
    wire [16:0] In_wallace_3;
    wire [16:0] In_wallace_4;
    wire [16:0] In_wallace_5;
    wire [16:0] In_wallace_6;
    wire [16:0] In_wallace_7;
    wire [16:0] In_wallace_8;
    wire [16:0] In_wallace_9;
    wire [16:0] In_wallace_10;
    wire [16:0] In_wallace_11;
    wire [16:0] In_wallace_12;
    wire [16:0] In_wallace_13;
    wire [16:0] In_wallace_14;
    wire [16:0] In_wallace_15;
    wire [16:0] In_wallace_16;
    wire [16:0] In_wallace_17;
    wire [16:0] In_wallace_18;
    wire [16:0] In_wallace_19;
    wire [16:0] In_wallace_20;
    wire [16:0] In_wallace_21;
    wire [16:0] In_wallace_22;
    wire [16:0] In_wallace_23;
    wire [16:0] In_wallace_24;
    wire [16:0] In_wallace_25;
    wire [16:0] In_wallace_26;
    wire [16:0] In_wallace_27;
    wire [16:0] In_wallace_28;
    wire [16:0] In_wallace_29;
    wire [16:0] In_wallace_30;
    wire [16:0] In_wallace_31;
    wire [16:0] In_wallace_32;
    wire [16:0] In_wallace_33;
    wire [16:0] In_wallace_34;
    wire [16:0] In_wallace_35;
    wire [16:0] In_wallace_36;
    wire [16:0] In_wallace_37;
    wire [16:0] In_wallace_38;
    wire [16:0] In_wallace_39;
    wire [16:0] In_wallace_40;
    wire [16:0] In_wallace_41;
    wire [16:0] In_wallace_42;
    wire [16:0] In_wallace_43;
    wire [16:0] In_wallace_44;
    wire [16:0] In_wallace_45;
    wire [16:0] In_wallace_46;
    wire [16:0] In_wallace_47;
    wire [16:0] In_wallace_48;
    wire [16:0] In_wallace_49;
    wire [16:0] In_wallace_50;
    wire [16:0] In_wallace_51;
    wire [16:0] In_wallace_52;
    wire [16:0] In_wallace_53;
    wire [16:0] In_wallace_54;
    wire [16:0] In_wallace_55;
    wire [16:0] In_wallace_56;
    wire [16:0] In_wallace_57;
    wire [16:0] In_wallace_58;
    wire [16:0] In_wallace_59;
    wire [16:0] In_wallace_60;
    wire [16:0] In_wallace_61;
    wire [16:0] In_wallace_62;
    wire [16:0] In_wallace_63;
    wire [16:0] In_wallace_64;
    wire [16:0] In_wallace_65;
    wire [16:0] In_wallace_66;
    wire [16:0] In_wallace_67;

    wire [67:0] P_16_left;
    wire [67:0] P_15_left;
    wire [67:0] P_14_left;
    wire [67:0] P_13_left;
    wire [67:0] P_12_left;
    wire [67:0] P_11_left;
    wire [67:0] P_10_left;
    wire [67:0] P_9_left;
    wire [67:0] P_8_left;
    wire [67:0] P_7_left;
    wire [67:0] P_6_left;
    wire [67:0] P_5_left;
    wire [67:0] P_4_left;
    wire [67:0] P_3_left;
    wire [67:0] P_2_left;
    wire [67:0] P_1_left;
    wire [67:0] P_0_left;

    assign P_16_left=P_16<<32;
    assign P_15_left=P_15<<30;
    assign P_14_left=P_14<<28;
    assign P_13_left=P_13<<26;
    assign P_12_left=P_12<<24;
    assign P_11_left=P_11<<22;
    assign P_10_left=P_10<<20;
    assign P_9_left=P_9<<18;
    assign P_8_left=P_8<<16;
    assign P_7_left=P_7<<14;
    assign P_6_left=P_6<<12;
    assign P_5_left=P_5<<10;
    assign P_4_left=P_4<<8;
    assign P_3_left=P_3<<6;
    assign P_2_left=P_2<<4;
    assign P_1_left=P_1<<2;
    assign P_0_left=P_0;

switch switch_module(
    .clk(clk),

    .P_16(P_16_left),
    .P_15(P_15_left),
    .P_14(P_14_left),
    .P_13(P_13_left),
    .P_12(P_12_left),
    .P_11(P_11_left),
    .P_10(P_10_left),
    .P_9(P_9_left),
    .P_8(P_8_left),
    .P_7(P_7_left),
    .P_6(P_6_left),
    .P_5(P_5_left),
    .P_4(P_4_left),
    .P_3(P_3_left),
    .P_2(P_2_left),
    .P_1(P_1_left),
    .P_0(P_0_left),

    .c_16(c_16),
    .c_15(c_15),
    .c_14(c_14),
    .c_13(c_13),
    .c_12(c_12),
    .c_11(c_11),
    .c_10(c_10),
    .c_9(c_9),
    .c_8(c_8),
    .c_7(c_7),
    .c_6(c_6),
    .c_5(c_5),
    .c_4(c_4),
    .c_3(c_3),
    .c_2(c_2),
    .c_1(c_1),
    .c_0(c_0),

    .c(c),


    .In_wallace_0(In_wallace_0),
    .In_wallace_1(In_wallace_1),
    .In_wallace_2(In_wallace_2),
    .In_wallace_3(In_wallace_3),
    .In_wallace_4(In_wallace_4),
    .In_wallace_5(In_wallace_5),
    .In_wallace_6(In_wallace_6),
    .In_wallace_7(In_wallace_7),
    .In_wallace_8(In_wallace_8),
    .In_wallace_9(In_wallace_9),
    .In_wallace_10(In_wallace_10),
    .In_wallace_11(In_wallace_11),
    .In_wallace_12(In_wallace_12),
    .In_wallace_13(In_wallace_13),
    .In_wallace_14(In_wallace_14),
    .In_wallace_15(In_wallace_15),
    .In_wallace_16(In_wallace_16),
    .In_wallace_17(In_wallace_17),
    .In_wallace_18(In_wallace_18),
    .In_wallace_19(In_wallace_19),
    .In_wallace_20(In_wallace_20),
    .In_wallace_21(In_wallace_21),
    .In_wallace_22(In_wallace_22),
    .In_wallace_23(In_wallace_23),
    .In_wallace_24(In_wallace_24),
    .In_wallace_25(In_wallace_25),
    .In_wallace_26(In_wallace_26),
    .In_wallace_27(In_wallace_27),
    .In_wallace_28(In_wallace_28),
    .In_wallace_29(In_wallace_29),
    .In_wallace_30(In_wallace_30),
    .In_wallace_31(In_wallace_31),
    .In_wallace_32(In_wallace_32),
    .In_wallace_33(In_wallace_33),
    .In_wallace_34(In_wallace_34),
    .In_wallace_35(In_wallace_35),
    .In_wallace_36(In_wallace_36),
    .In_wallace_37(In_wallace_37),
    .In_wallace_38(In_wallace_38),
    .In_wallace_39(In_wallace_39),
    .In_wallace_40(In_wallace_40),
    .In_wallace_41(In_wallace_41),
    .In_wallace_42(In_wallace_42),
    .In_wallace_43(In_wallace_43),
    .In_wallace_44(In_wallace_44),
    .In_wallace_45(In_wallace_45),
    .In_wallace_46(In_wallace_46),
    .In_wallace_47(In_wallace_47),
    .In_wallace_48(In_wallace_48),
    .In_wallace_49(In_wallace_49),
    .In_wallace_50(In_wallace_50),
    .In_wallace_51(In_wallace_51),
    .In_wallace_52(In_wallace_52),
    .In_wallace_53(In_wallace_53),
    .In_wallace_54(In_wallace_54),
    .In_wallace_55(In_wallace_55),
    .In_wallace_56(In_wallace_56),
    .In_wallace_57(In_wallace_57),
    .In_wallace_58(In_wallace_58),
    .In_wallace_59(In_wallace_59),
    .In_wallace_60(In_wallace_60),
    .In_wallace_61(In_wallace_61),
    .In_wallace_62(In_wallace_62),
    .In_wallace_63(In_wallace_63),
    .In_wallace_64(In_wallace_64),
    .In_wallace_65(In_wallace_65),
    .In_wallace_66(In_wallace_66),
    .In_wallace_67(In_wallace_67)

);

wire C_0,C_1,C_2,C_3,C_4,C_5,C_6,C_7,C_8,C_9,C_10,C_11,C_12,C_13,C_14,C_15,C_16,C_17,C_18,C_19,C_20,C_21,C_22,C_23,C_24,C_25,C_26,C_27,C_28,C_29,C_30,C_31,C_32,C_33,C_34,C_35,C_36,C_37,C_38,C_39,C_40,C_41,C_42,C_43,C_44,C_45,C_46,C_47,C_48,C_49,C_50,C_51,C_52,C_53,C_54,C_55,C_56,C_57,C_58,C_59,C_60,C_61,C_62,C_63,C_64,C_65,C_66,C_67;
wire S_0,S_1,S_2,S_3,S_4,S_5,S_6,S_7,S_8,S_9,S_10,S_11,S_12,S_13,S_14,S_15,S_16,S_17,S_18,S_19,S_20,S_21,S_22,S_23,S_24,S_25,S_26,S_27,S_28,S_29,S_30,S_31,S_32,S_33,S_34,S_35,S_36,S_37,S_38,S_39,S_40,S_41,S_42,S_43,S_44,S_45,S_46,S_47,S_48,S_49,S_50,S_51,S_52,S_53,S_54,S_55,S_56,S_57,S_58,S_59,S_60,S_61,S_62,S_63,S_64,S_65,S_66,S_67;
wire [16:0] wall_0_out,wall_1_out,wall_2_out,wall_3_out,wall_4_out,wall_5_out,wall_6_out,wall_7_out,wall_8_out,wall_9_out,wall_10_out,wall_11_out,wall_12_out,wall_13_out,wall_14_out,wall_15_out,wall_16_out,wall_17_out,wall_18_out,wall_19_out,wall_20_out,wall_21_out,wall_22_out,wall_23_out,wall_24_out,wall_25_out,wall_26_out,wall_27_out,wall_28_out,wall_29_out,wall_30_out,wall_31_out,wall_32_out,wall_33_out,wall_34_out,wall_35_out,wall_36_out,wall_37_out,wall_38_out,wall_39_out,wall_40_out,wall_41_out,wall_42_out,wall_43_out,wall_44_out,wall_45_out,wall_46_out,wall_47_out,wall_48_out,wall_49_out,wall_50_out,wall_51_out,wall_52_out,wall_53_out,wall_54_out,wall_55_out,wall_56_out,wall_57_out,wall_58_out,wall_59_out,wall_60_out,wall_61_out,wall_62_out,wall_63_out,wall_64_out,wall_65_out,wall_66_out,wall_67_out;
wire [14:0] wall_c_0,wall_c_1,wall_c_2,wall_c_3,wall_c_4,wall_c_5,wall_c_6,wall_c_7,wall_c_8,wall_c_9,wall_c_10,wall_c_11,wall_c_12,wall_c_13,wall_c_14,wall_c_15,wall_c_16,wall_1c_7,wall_1c_8,wall_1c_9,wall_2c_0,wall_2c_1,wall_2c_2,wall_2c_3,wall_2c_4,wall_2c_5,wall_2c_6,wall_2c_7,wall_2c_8,wall_2c_9,wall_3c_0,wall_3c_1,wall_3c_2,wall_3c_3,wall_3c_4,wall_3c_5,wall_3c_6,wall_3c_7,wall_3c_8,wall_3c_9,wall_4c_0,wall_4c_1,wall_4c_2,wall_4c_3,wall_4c_4,wall_4c_5,wall_4c_6,wall_4c_7,wall_4c_8,wall_4c_9,wall_5c_0,wall_5c_1,wall_5c_2,wall_5c_3,wall_5c_4,wall_5c_5,wall_5c_6,wall_5c_7,wall_5c_8,wall_5c_9,wall_6c_0,wall_6c_1,wall_6c_2,wall_6c_3,wall_6c_4,wall_6c_5,wall_6c_6,wall_6c_7,wall_6c_8;

//assign wall_c_0=c[14:0];
assign wall_c_0=15'b0;

wallace wal_0(

    .switch_to_wall(In_wallace_0),

    .cin(wall_c_0),
    .cout(wall_c_1), 

    .C(C_0),
    .S(S_0)
);

wallace wal_1(

    .switch_to_wall(In_wallace_1),

    .cin(wall_c_1),
    .cout(wall_c_2), 

    .C(C_1),
    .S(S_1)
);

wallace wal_2(

    .switch_to_wall(In_wallace_2),

    .cin(wall_c_2),
    .cout(wall_c_3), 

    .C(C_2),
    .S(S_2)
);

wallace wal_3(

    .switch_to_wall(In_wallace_3),

    .cin(wall_c_3),
    .cout(wall_c_4), 

    .C(C_3),
    .S(S_3)
);

wallace wal_4(

    .switch_to_wall(In_wallace_4),

    .cin(wall_c_4),
    .cout(wall_c_5), 

    .C(C_4),
    .S(S_4)
);

wallace wal_5(

    .switch_to_wall(In_wallace_5),

    .cin(wall_c_5),
    .cout(wall_c_6), 

    .C(C_5),
    .S(S_5)
);

wallace wal_6(

    .switch_to_wall(In_wallace_6),

    .cin(wall_c_6),
    .cout(wall_c_7), 

    .C(C_6),
    .S(S_6)
);

wallace wal_7(

    .switch_to_wall(In_wallace_7),

    .cin(wall_c_7),
    .cout(wall_c_8), 

    .C(C_7),
    .S(S_7)
);

wallace wal_8(

        .switch_to_wall(In_wallace_8),

        .cin(wall_c_8),
        .cout(wall_c_9),

        .C(C_8),
        .S(S_8)
        );
    

    wallace wal_9(

        .switch_to_wall(In_wallace_9),

        .cin(wall_c_9),
        .cout(wall_c_10),

        .C(C_9),
        .S(S_9)
        );
    

    wallace wal_10(

        .switch_to_wall(In_wallace_10),

        .cin(wall_c_10),
        .cout(wall_c_11),

        .C(C_10),
        .S(S_10)
        );
    

    wallace wal_11(

        .switch_to_wall(In_wallace_11),

        .cin(wall_c_11),
        .cout(wall_c_12),

        .C(C_11),
        .S(S_11)
        );
    

    wallace wal_12(

        .switch_to_wall(In_wallace_12),

        .cin(wall_c_12),
        .cout(wall_c_13),

        .C(C_12),
        .S(S_12)
        );
    

    wallace wal_13(

        .switch_to_wall(In_wallace_13),

        .cin(wall_c_13),
        .cout(wall_c_14),

        .C(C_13),
        .S(S_13)
        );
    

    wallace wal_14(

        .switch_to_wall(In_wallace_14),

        .cin(wall_c_14),
        .cout(wall_c_15),

        .C(C_14),
        .S(S_14)
        );
    

    wallace wal_15(

        .switch_to_wall(In_wallace_15),

        .cin(wall_c_15),
        .cout(wall_c_16),

        .C(C_15),
        .S(S_15)
        );
    

    wallace wal_16(

        .switch_to_wall(In_wallace_16),

        .cin(wall_c_16),
        .cout(wall_1c_7),

        .C(C_16),
        .S(S_16)
        );
    

    wallace wal_17(

        .switch_to_wall(In_wallace_17),

        .cin(wall_1c_7),
        .cout(wall_1c_8),

        .C(C_17),
        .S(S_17)
        );
    

    wallace wal_18(

        .switch_to_wall(In_wallace_18),

        .cin(wall_1c_8),
        .cout(wall_1c_9),

        .C(C_18),
        .S(S_18)
        );
    

    wallace wal_19(

        .switch_to_wall(In_wallace_19),

        .cin(wall_1c_9),
        .cout(wall_2c_0),

        .C(C_19),
        .S(S_19)
        );
    

    wallace wal_20(

        .switch_to_wall(In_wallace_20),

        .cin(wall_2c_0),
        .cout(wall_2c_1),

        .C(C_20),
        .S(S_20)
        );
    

    wallace wal_21(

        .switch_to_wall(In_wallace_21),

        .cin(wall_2c_1),
        .cout(wall_2c_2),

        .C(C_21),
        .S(S_21)
        );
    

    wallace wal_22(

        .switch_to_wall(In_wallace_22),

        .cin(wall_2c_2),
        .cout(wall_2c_3),

        .C(C_22),
        .S(S_22)
        );
    

    wallace wal_23(

        .switch_to_wall(In_wallace_23),

        .cin(wall_2c_3),
        .cout(wall_2c_4),

        .C(C_23),
        .S(S_23)
        );
    

    wallace wal_24(

        .switch_to_wall(In_wallace_24),

        .cin(wall_2c_4),
        .cout(wall_2c_5),

        .C(C_24),
        .S(S_24)
        );
    

    wallace wal_25(

        .switch_to_wall(In_wallace_25),

        .cin(wall_2c_5),
        .cout(wall_2c_6),

        .C(C_25),
        .S(S_25)
        );
    

    wallace wal_26(

        .switch_to_wall(In_wallace_26),

        .cin(wall_2c_6),
        .cout(wall_2c_7),

        .C(C_26),
        .S(S_26)
        );
    

    wallace wal_27(

        .switch_to_wall(In_wallace_27),

        .cin(wall_2c_7),
        .cout(wall_2c_8),

        .C(C_27),
        .S(S_27)
        );
    

    wallace wal_28(

        .switch_to_wall(In_wallace_28),

        .cin(wall_2c_8),
        .cout(wall_2c_9),

        .C(C_28),
        .S(S_28)
        );
    

    wallace wal_29(

        .switch_to_wall(In_wallace_29),

        .cin(wall_2c_9),
        .cout(wall_3c_0),

        .C(C_29),
        .S(S_29)
        );
    

    wallace wal_30(

        .switch_to_wall(In_wallace_30),

        .cin(wall_3c_0),
        .cout(wall_3c_1),

        .C(C_30),
        .S(S_30)
        );
    

    wallace wal_31(

        .switch_to_wall(In_wallace_31),

        .cin(wall_3c_1),
        .cout(wall_3c_2),

        .C(C_31),
        .S(S_31)
        );
    

    wallace wal_32(

        .switch_to_wall(In_wallace_32),

        .cin(wall_3c_2),
        .cout(wall_3c_3),

        .C(C_32),
        .S(S_32)
        );
    

    wallace wal_33(

        .switch_to_wall(In_wallace_33),

        .cin(wall_3c_3),
        .cout(wall_3c_4),

        .C(C_33),
        .S(S_33)
        );
    

    wallace wal_34(

        .switch_to_wall(In_wallace_34),

        .cin(wall_3c_4),
        .cout(wall_3c_5),

        .C(C_34),
        .S(S_34)
        );
    

    wallace wal_35(

        .switch_to_wall(In_wallace_35),

        .cin(wall_3c_5),
        .cout(wall_3c_6),

        .C(C_35),
        .S(S_35)
        );
    

    wallace wal_36(

        .switch_to_wall(In_wallace_36),

        .cin(wall_3c_6),
        .cout(wall_3c_7),

        .C(C_36),
        .S(S_36)
        );
    

    wallace wal_37(

        .switch_to_wall(In_wallace_37),

        .cin(wall_3c_7),
        .cout(wall_3c_8),

        .C(C_37),
        .S(S_37)
        );
    

    wallace wal_38(

        .switch_to_wall(In_wallace_38),

        .cin(wall_3c_8),
        .cout(wall_3c_9),

        .C(C_38),
        .S(S_38)
        );
    

    wallace wal_39(

        .switch_to_wall(In_wallace_39),

        .cin(wall_3c_9),
        .cout(wall_4c_0),

        .C(C_39),
        .S(S_39)
        );
    

    wallace wal_40(

        .switch_to_wall(In_wallace_40),

        .cin(wall_4c_0),
        .cout(wall_4c_1),

        .C(C_40),
        .S(S_40)
        );
    

    wallace wal_41(

        .switch_to_wall(In_wallace_41),

        .cin(wall_4c_1),
        .cout(wall_4c_2),

        .C(C_41),
        .S(S_41)
        );
    

    wallace wal_42(

        .switch_to_wall(In_wallace_42),

        .cin(wall_4c_2),
        .cout(wall_4c_3),

        .C(C_42),
        .S(S_42)
        );
    

    wallace wal_43(

        .switch_to_wall(In_wallace_43),

        .cin(wall_4c_3),
        .cout(wall_4c_4),

        .C(C_43),
        .S(S_43)
        );
    

    wallace wal_44(

        .switch_to_wall(In_wallace_44),

        .cin(wall_4c_4),
        .cout(wall_4c_5),

        .C(C_44),
        .S(S_44)
        );
    

    wallace wal_45(

        .switch_to_wall(In_wallace_45),

        .cin(wall_4c_5),
        .cout(wall_4c_6),

        .C(C_45),
        .S(S_45)
        );
    

    wallace wal_46(

        .switch_to_wall(In_wallace_46),

        .cin(wall_4c_6),
        .cout(wall_4c_7),

        .C(C_46),
        .S(S_46)
        );
    

    wallace wal_47(

        .switch_to_wall(In_wallace_47),

        .cin(wall_4c_7),
        .cout(wall_4c_8),

        .C(C_47),
        .S(S_47)
        );
    

    wallace wal_48(

        .switch_to_wall(In_wallace_48),

        .cin(wall_4c_8),
        .cout(wall_4c_9),

        .C(C_48),
        .S(S_48)
        );
    

    wallace wal_49(

        .switch_to_wall(In_wallace_49),

        .cin(wall_4c_9),
        .cout(wall_5c_0),

        .C(C_49),
        .S(S_49)
        );
    

    wallace wal_50(

        .switch_to_wall(In_wallace_50),

        .cin(wall_5c_0),
        .cout(wall_5c_1),

        .C(C_50),
        .S(S_50)
        );
    

    wallace wal_51(

        .switch_to_wall(In_wallace_51),

        .cin(wall_5c_1),
        .cout(wall_5c_2),

        .C(C_51),
        .S(S_51)
        );
    

    wallace wal_52(

        .switch_to_wall(In_wallace_52),

        .cin(wall_5c_2),
        .cout(wall_5c_3),

        .C(C_52),
        .S(S_52)
        );
    

    wallace wal_53(

        .switch_to_wall(In_wallace_53),

        .cin(wall_5c_3),
        .cout(wall_5c_4),

        .C(C_53),
        .S(S_53)
        );
    

    wallace wal_54(

        .switch_to_wall(In_wallace_54),

        .cin(wall_5c_4),
        .cout(wall_5c_5),

        .C(C_54),
        .S(S_54)
        );
    

    wallace wal_55(

        .switch_to_wall(In_wallace_55),

        .cin(wall_5c_5),
        .cout(wall_5c_6),

        .C(C_55),
        .S(S_55)
        );
    

    wallace wal_56(

        .switch_to_wall(In_wallace_56),

        .cin(wall_5c_6),
        .cout(wall_5c_7),

        .C(C_56),
        .S(S_56)
        );
    

    wallace wal_57(

        .switch_to_wall(In_wallace_57),

        .cin(wall_5c_7),
        .cout(wall_5c_8),

        .C(C_57),
        .S(S_57)
        );
    

    wallace wal_58(

        .switch_to_wall(In_wallace_58),

        .cin(wall_5c_8),
        .cout(wall_5c_9),

        .C(C_58),
        .S(S_58)
        );
    

    wallace wal_59(

        .switch_to_wall(In_wallace_59),

        .cin(wall_5c_9),
        .cout(wall_6c_0),

        .C(C_59),
        .S(S_59)
        );
    

    wallace wal_60(

        .switch_to_wall(In_wallace_60),

        .cin(wall_6c_0),
        .cout(wall_6c_1),

        .C(C_60),
        .S(S_60)
        );
    

    wallace wal_61(

        .switch_to_wall(In_wallace_61),

        .cin(wall_6c_1),
        .cout(wall_6c_2),

        .C(C_61),
        .S(S_61)
        );
    

    wallace wal_62(

        .switch_to_wall(In_wallace_62),

        .cin(wall_6c_2),
        .cout(wall_6c_3),

        .C(C_62),
        .S(S_62)
        );
    

    wallace wal_63(

        .switch_to_wall(In_wallace_63),

        .cin(wall_6c_3),
        .cout(wall_6c_4),

        .C(C_63),
        .S(S_63)
        );
    

    wallace wal_64(

        .switch_to_wall(In_wallace_64),

        .cin(wall_6c_4),
        .cout(wall_6c_5),

        .C(C_64),
        .S(S_64)
        );
    

    wallace wal_65(

        .switch_to_wall(In_wallace_65),

        .cin(wall_6c_5),
        .cout(wall_6c_6),

        .C(C_65),
        .S(S_65)
        );
    

    wallace wal_66(

        .switch_to_wall(In_wallace_66),

        .cin(wall_6c_6),
        .cout(wall_6c_7),

        .C(C_66),
        .S(S_66)
        );
    

    wallace wal_67(

        .switch_to_wall(In_wallace_67),

        .cin(wall_6c_7),
        .cout(wall_6c_8),

        .C(C_67),
        .S(S_67)
        );


wire [67:0] add_6C_8;
wire [67:0] add_6S_8;

assign add_6C_8={C_66,C_65,C_64,C_63,C_62,C_61,C_60,C_59,C_58,C_57,C_56,C_55,C_54,C_53,C_52,C_51,C_50,C_49,C_48,C_47,C_46,C_45,C_44,C_43,C_42,C_41,C_40,C_39,C_38,C_37,C_36,C_35,C_34,C_33,C_32,C_31,C_30,C_29,C_28,C_27,C_26,C_25,C_24,C_23,C_22,C_21,C_20,C_19,C_18,C_17,C_16,C_15,C_14,C_13,C_12,C_11,C_10,C_9,C_8,C_7,C_6,C_5,C_4,C_3,C_2,C_1,C_0,c[15]};
assign add_6S_8={S_67,S_66,S_65,S_64,S_63,S_62,S_61,S_60,S_59,S_58,S_57,S_56,S_55,S_54,S_53,S_52,S_51,S_50,S_49,S_48,S_47,S_46,S_45,S_44,S_43,S_42,S_41,S_40,S_39,S_38,S_37,S_36,S_35,S_34,S_33,S_32,S_31,S_30,S_29,S_28,S_27,S_26,S_25,S_24,S_23,S_22,S_21,S_20,S_19,S_18,S_17,S_16,S_15,S_14,S_13,S_12,S_11,S_10,S_9,S_8,S_7,S_6,S_5,S_4,S_3,S_2,S_1,S_0};



wire [68:0] add_68_result;

assign add_68_result=add_6C_8+add_6S_8+c[16];
assign result=add_68_result[65:0];





endmodule