`define DATA_WIDTH 32
`define ADDR_WIDTH 5
module TLB(
    input clk,
    input rst,
    input [`DATA_WIDTH-1:0] inst_vaddr,
    input [`DATA_WIDTH-1:0] data_vaddr,
    input [`DATA_WIDTH-1:0] EntryHi,
    input [`DATA_WIDTH-1:0] PageMask,
    input [`DATA_WIDTH-1:0] EntryLo0,
    input [`DATA_WIDTH-1:0] EntryLo1,
    input [`DATA_WIDTH-1:0] Index,
    input wen,

    output [`DATA_WIDTH-1:0] inst_paddr,
    output [`DATA_WIDTH-1:0] data_paddr,
    output inst_hit,
    output data_hit,
    output [19:0] inst_pfn,
    output inst_v,
    output [2:0] inst_c,
    output inst_d,

    output [19:0] data_pfn,
    output data_v,
    output [2:0] data_c,
    output data_d,

    output [`DATA_WIDTH-1:0] read_EntryHi,
    output [`DATA_WIDTH-1:0] read_PageMask,
    output [`DATA_WIDTH-1:0] read_EntryLo0,
    output [`DATA_WIDTH-1:0] read_EntryLo1,
    output [4:0] PIndex,
    output p_hit,
    output [1:0] inst_tlb_exception,   //01--refill;10--invalid;11--modify;00--nothing
    output [1:0] data_tlb_exception

);
    reg [18:0] VPN2[`DATA_WIDTH-1:0];
    reg [7:0]  ASID[`DATA_WIDTH-1:0];
    reg [11:0] PMask[`DATA_WIDTH-1:0];
    reg G [`DATA_WIDTH-1:0];
   // reg [19:0] PFN0[`DATA_WIDTH-1:0];
   // reg [19:0] PFN1[`DATA_WIDTH-1:0];
   // reg [2:0] Lo_0_C[`DATA_WIDTH-1:0];
   // reg [2:0] Lo_1_C[`DATA_WIDTH-1:0];

   // reg Lo_0_D[`DATA_WIDTH-1:0];
   // reg Lo_1_D[`DATA_WIDTH-1:0];        
   // reg Lo_0_V[`DATA_WIDTH-1:0];
   // reg Lo_1_V[`DATA_WIDTH-1:0];    


    reg [`DATA_WIDTH-1:0]Lo_0[`DATA_WIDTH-1:0];
    reg [`DATA_WIDTH-1:0]Lo_1[`DATA_WIDTH-1:0];

    wire [`DATA_WIDTH-1:0]inst_entryhit;
    wire [18:0] mask_inst_addr[`DATA_WIDTH-1:0];

    wire [`DATA_WIDTH-1:0]data_entryhit;
    wire [18:0] mask_data_addr[`DATA_WIDTH-1:0];

    wire [18:0] mask_vpn2[`DATA_WIDTH-1:0];
    //assign mask_inst_addr[0]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[0])};
    //assign mask_inst_vpn2[0]={VPN2[0][18:12],VPN2[0][11:0]&(~PMask[0])};
    //assign inst_entryhit[0]=((mask_inst_addr[0]==mask_inst_vpn2[0])&&(G[0]||ASID[0]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[0]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[0])};
    assign mask_vpn2[0]={VPN2[0][18:12],VPN2[0][11:0]&(~PMask[0])};
    assign inst_entryhit[0]=((mask_inst_addr[0]==mask_vpn2[0])&&(G[0]||ASID[0]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[1]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[1])};
    assign mask_vpn2[1]={VPN2[1][18:12],VPN2[1][11:0]&(~PMask[1])};
    assign inst_entryhit[1]=((mask_inst_addr[1]==mask_vpn2[1])&&(G[1]||ASID[1]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[2]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[2])};
    assign mask_vpn2[2]={VPN2[2][18:12],VPN2[2][11:0]&(~PMask[2])};
    assign inst_entryhit[2]=((mask_inst_addr[2]==mask_vpn2[2])&&(G[2]||ASID[2]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[3]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[3])};
    assign mask_vpn2[3]={VPN2[3][18:12],VPN2[3][11:0]&(~PMask[3])};
    assign inst_entryhit[3]=((mask_inst_addr[3]==mask_vpn2[3])&&(G[3]||ASID[3]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[4]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[4])};
    assign mask_vpn2[4]={VPN2[4][18:12],VPN2[4][11:0]&(~PMask[4])};
    assign inst_entryhit[4]=((mask_inst_addr[4]==mask_vpn2[4])&&(G[4]||ASID[4]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[5]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[5])};
    assign mask_vpn2[5]={VPN2[5][18:12],VPN2[5][11:0]&(~PMask[5])};
    assign inst_entryhit[5]=((mask_inst_addr[5]==mask_vpn2[5])&&(G[5]||ASID[5]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[6]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[6])};
    assign mask_vpn2[6]={VPN2[6][18:12],VPN2[6][11:0]&(~PMask[6])};
    assign inst_entryhit[6]=((mask_inst_addr[6]==mask_vpn2[6])&&(G[6]||ASID[6]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[7]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[7])};
    assign mask_vpn2[7]={VPN2[7][18:12],VPN2[7][11:0]&(~PMask[7])};
    assign inst_entryhit[7]=((mask_inst_addr[7]==mask_vpn2[7])&&(G[7]||ASID[7]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[8]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[8])};
    assign mask_vpn2[8]={VPN2[8][18:12],VPN2[8][11:0]&(~PMask[8])};
    assign inst_entryhit[8]=((mask_inst_addr[8]==mask_vpn2[8])&&(G[8]||ASID[8]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[9]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[9])};
    assign mask_vpn2[9]={VPN2[9][18:12],VPN2[9][11:0]&(~PMask[9])};
    assign inst_entryhit[9]=((mask_inst_addr[9]==mask_vpn2[9])&&(G[9]||ASID[9]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[10]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[10])};
    assign mask_vpn2[10]={VPN2[10][18:12],VPN2[10][11:0]&(~PMask[10])};
    assign inst_entryhit[10]=((mask_inst_addr[10]==mask_vpn2[10])&&(G[10]||ASID[10]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[11]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[11])};
    assign mask_vpn2[11]={VPN2[11][18:12],VPN2[11][11:0]&(~PMask[11])};
    assign inst_entryhit[11]=((mask_inst_addr[11]==mask_vpn2[11])&&(G[11]||ASID[11]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[12]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[12])};
    assign mask_vpn2[12]={VPN2[12][18:12],VPN2[12][11:0]&(~PMask[12])};
    assign inst_entryhit[12]=((mask_inst_addr[12]==mask_vpn2[12])&&(G[12]||ASID[12]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[13]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[13])};
    assign mask_vpn2[13]={VPN2[13][18:12],VPN2[13][11:0]&(~PMask[13])};
    assign inst_entryhit[13]=((mask_inst_addr[13]==mask_vpn2[13])&&(G[13]||ASID[13]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[14]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[14])};
    assign mask_vpn2[14]={VPN2[14][18:12],VPN2[14][11:0]&(~PMask[14])};
    assign inst_entryhit[14]=((mask_inst_addr[14]==mask_vpn2[14])&&(G[14]||ASID[14]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[15]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[15])};
    assign mask_vpn2[15]={VPN2[15][18:12],VPN2[15][11:0]&(~PMask[15])};
    assign inst_entryhit[15]=((mask_inst_addr[15]==mask_vpn2[15])&&(G[15]||ASID[15]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[16]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[16])};
    assign mask_vpn2[16]={VPN2[16][18:12],VPN2[16][11:0]&(~PMask[16])};
    assign inst_entryhit[16]=((mask_inst_addr[16]==mask_vpn2[16])&&(G[16]||ASID[16]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[17]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[17])};
    assign mask_vpn2[17]={VPN2[17][18:12],VPN2[17][11:0]&(~PMask[17])};
    assign inst_entryhit[17]=((mask_inst_addr[17]==mask_vpn2[17])&&(G[17]||ASID[17]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[18]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[18])};
    assign mask_vpn2[18]={VPN2[18][18:12],VPN2[18][11:0]&(~PMask[18])};
    assign inst_entryhit[18]=((mask_inst_addr[18]==mask_vpn2[18])&&(G[18]||ASID[18]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[19]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[19])};
    assign mask_vpn2[19]={VPN2[19][18:12],VPN2[19][11:0]&(~PMask[19])};
    assign inst_entryhit[19]=((mask_inst_addr[19]==mask_vpn2[19])&&(G[19]||ASID[19]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[20]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[20])};
    assign mask_vpn2[20]={VPN2[20][18:12],VPN2[20][11:0]&(~PMask[20])};
    assign inst_entryhit[20]=((mask_inst_addr[20]==mask_vpn2[20])&&(G[20]||ASID[20]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[21]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[21])};
    assign mask_vpn2[21]={VPN2[21][18:12],VPN2[21][11:0]&(~PMask[21])};
    assign inst_entryhit[21]=((mask_inst_addr[21]==mask_vpn2[21])&&(G[21]||ASID[21]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[22]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[22])};
    assign mask_vpn2[22]={VPN2[22][18:12],VPN2[22][11:0]&(~PMask[22])};
    assign inst_entryhit[22]=((mask_inst_addr[22]==mask_vpn2[22])&&(G[22]||ASID[22]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[23]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[23])};
    assign mask_vpn2[23]={VPN2[23][18:12],VPN2[23][11:0]&(~PMask[23])};
    assign inst_entryhit[23]=((mask_inst_addr[23]==mask_vpn2[23])&&(G[23]||ASID[23]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[24]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[24])};
    assign mask_vpn2[24]={VPN2[24][18:12],VPN2[24][11:0]&(~PMask[24])};
    assign inst_entryhit[24]=((mask_inst_addr[24]==mask_vpn2[24])&&(G[24]||ASID[24]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[25]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[25])};
    assign mask_vpn2[25]={VPN2[25][18:12],VPN2[25][11:0]&(~PMask[25])};
    assign inst_entryhit[25]=((mask_inst_addr[25]==mask_vpn2[25])&&(G[25]||ASID[25]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[26]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[26])};
    assign mask_vpn2[26]={VPN2[26][18:12],VPN2[26][11:0]&(~PMask[26])};
    assign inst_entryhit[26]=((mask_inst_addr[26]==mask_vpn2[26])&&(G[26]||ASID[26]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[27]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[27])};
    assign mask_vpn2[27]={VPN2[27][18:12],VPN2[27][11:0]&(~PMask[27])};
    assign inst_entryhit[27]=((mask_inst_addr[27]==mask_vpn2[27])&&(G[27]||ASID[27]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[28]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[28])};
    assign mask_vpn2[28]={VPN2[28][18:12],VPN2[28][11:0]&(~PMask[28])};
    assign inst_entryhit[28]=((mask_inst_addr[28]==mask_vpn2[28])&&(G[28]||ASID[28]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[29]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[29])};
    assign mask_vpn2[29]={VPN2[29][18:12],VPN2[29][11:0]&(~PMask[29])};
    assign inst_entryhit[29]=((mask_inst_addr[29]==mask_vpn2[29])&&(G[29]||ASID[29]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[30]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[30])};
    assign mask_vpn2[30]={VPN2[30][18:12],VPN2[30][11:0]&(~PMask[30])};
    assign inst_entryhit[30]=((mask_inst_addr[30]==mask_vpn2[30])&&(G[30]||ASID[30]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_inst_addr[31]={inst_vaddr[31:25],inst_vaddr[24:13]&(~PMask[31])};
    assign mask_vpn2[31]={VPN2[31][18:12],VPN2[31][11:0]&(~PMask[31])};
    assign inst_entryhit[31]=((mask_inst_addr[31]==mask_vpn2[31])&&(G[31]||ASID[31]==EntryHi[7:0]))?1'b1:1'b0;

    //-----------------------------------------------------------------------------------------------------------
    assign mask_data_addr[0]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[0])};
    assign data_entryhit[0]=((mask_data_addr[0]==mask_vpn2[0])&&(G[0]||ASID[0]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[1]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[1])};
    assign data_entryhit[1]=((mask_data_addr[1]==mask_vpn2[1])&&(G[1]||ASID[1]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[2]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[2])};
    assign data_entryhit[2]=((mask_data_addr[2]==mask_vpn2[2])&&(G[2]||ASID[2]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[3]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[3])};
    assign data_entryhit[3]=((mask_data_addr[3]==mask_vpn2[3])&&(G[3]||ASID[3]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[4]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[4])};
    assign data_entryhit[4]=((mask_data_addr[4]==mask_vpn2[4])&&(G[4]||ASID[4]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[5]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[5])};
    assign data_entryhit[5]=((mask_data_addr[5]==mask_vpn2[5])&&(G[5]||ASID[5]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[6]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[6])};
    assign data_entryhit[6]=((mask_data_addr[6]==mask_vpn2[6])&&(G[6]||ASID[6]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[7]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[7])};
    assign data_entryhit[7]=((mask_data_addr[7]==mask_vpn2[7])&&(G[7]||ASID[7]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[8]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[8])};
    assign data_entryhit[8]=((mask_data_addr[8]==mask_vpn2[8])&&(G[8]||ASID[8]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[9]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[9])};
    assign data_entryhit[9]=((mask_data_addr[9]==mask_vpn2[9])&&(G[9]||ASID[9]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[10]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[10])};
    assign data_entryhit[10]=((mask_data_addr[10]==mask_vpn2[10])&&(G[10]||ASID[10]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[11]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[11])};
    assign data_entryhit[11]=((mask_data_addr[11]==mask_vpn2[11])&&(G[11]||ASID[11]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[12]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[12])};
    assign data_entryhit[12]=((mask_data_addr[12]==mask_vpn2[12])&&(G[12]||ASID[12]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[13]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[13])};
    assign data_entryhit[13]=((mask_data_addr[13]==mask_vpn2[13])&&(G[13]||ASID[13]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[14]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[14])};
    assign data_entryhit[14]=((mask_data_addr[14]==mask_vpn2[14])&&(G[14]||ASID[14]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[15]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[15])};
    assign data_entryhit[15]=((mask_data_addr[15]==mask_vpn2[15])&&(G[15]||ASID[15]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[16]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[16])};
    assign data_entryhit[16]=((mask_data_addr[16]==mask_vpn2[16])&&(G[16]||ASID[16]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[17]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[17])};
    assign data_entryhit[17]=((mask_data_addr[17]==mask_vpn2[17])&&(G[17]||ASID[17]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[18]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[18])};
    assign data_entryhit[18]=((mask_data_addr[18]==mask_vpn2[18])&&(G[18]||ASID[18]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[19]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[19])};
    assign data_entryhit[19]=((mask_data_addr[19]==mask_vpn2[19])&&(G[19]||ASID[19]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[20]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[20])};
    assign data_entryhit[20]=((mask_data_addr[20]==mask_vpn2[20])&&(G[20]||ASID[20]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[21]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[21])};
    assign data_entryhit[21]=((mask_data_addr[21]==mask_vpn2[21])&&(G[21]||ASID[21]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[22]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[22])};
    assign data_entryhit[22]=((mask_data_addr[22]==mask_vpn2[22])&&(G[22]||ASID[22]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[23]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[23])};
    assign data_entryhit[23]=((mask_data_addr[23]==mask_vpn2[23])&&(G[23]||ASID[23]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[24]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[24])};
    assign data_entryhit[24]=((mask_data_addr[24]==mask_vpn2[24])&&(G[24]||ASID[24]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[25]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[25])};
    assign data_entryhit[25]=((mask_data_addr[25]==mask_vpn2[25])&&(G[25]||ASID[25]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[26]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[26])};
    assign data_entryhit[26]=((mask_data_addr[26]==mask_vpn2[26])&&(G[26]||ASID[26]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[27]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[27])};
    assign data_entryhit[27]=((mask_data_addr[27]==mask_vpn2[27])&&(G[27]||ASID[27]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[28]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[28])};
    assign data_entryhit[28]=((mask_data_addr[28]==mask_vpn2[28])&&(G[28]||ASID[28]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[29]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[29])};
    assign data_entryhit[29]=((mask_data_addr[29]==mask_vpn2[29])&&(G[29]||ASID[29]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[30]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[30])};
    assign data_entryhit[30]=((mask_data_addr[30]==mask_vpn2[30])&&(G[30]||ASID[30]==EntryHi[7:0]))?1'b1:1'b0;
    
    assign mask_data_addr[31]={data_vaddr[31:25],data_vaddr[24:13]&(~PMask[31])};
    assign data_entryhit[31]=((mask_data_addr[31]==mask_vpn2[31])&&(G[31]||ASID[31]==EntryHi[7:0]))?1'b1:1'b0;
    
    
    assign inst_hit=|(inst_entryhit);
    assign data_hit=|(data_entryhit);

    wire [4:0] inst_num;
    wire [4:0] data_num;
    assign inst_paddr=//{32{inst_entryhit[0]}}&{({20{~inst_vaddr[12]}}&Lo_0[0][25:6]|{20{inst_vaddr[12]}}&Lo_1[0][25:6]),inst_vaddr[11:0]}
                      //|{32{inst_entryhit[1]}}&{({20{~inst_vaddr[12]}}&Lo_0[1][25:6]|{20{inst_vaddr[12]}}&Lo_1[1][25:6]),inst_vaddr[11:0]}
                      {32{inst_entryhit[0]}}&{({20{~inst_vaddr[12]}}&Lo_0[0][25:6]|{20{inst_vaddr[12]}}&Lo_1[0][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[1]}}&{({20{~inst_vaddr[12]}}&Lo_0[1][25:6]|{20{inst_vaddr[12]}}&Lo_1[1][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[2]}}&{({20{~inst_vaddr[12]}}&Lo_0[2][25:6]|{20{inst_vaddr[12]}}&Lo_1[2][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[3]}}&{({20{~inst_vaddr[12]}}&Lo_0[3][25:6]|{20{inst_vaddr[12]}}&Lo_1[3][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[4]}}&{({20{~inst_vaddr[12]}}&Lo_0[4][25:6]|{20{inst_vaddr[12]}}&Lo_1[4][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[5]}}&{({20{~inst_vaddr[12]}}&Lo_0[5][25:6]|{20{inst_vaddr[12]}}&Lo_1[5][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[6]}}&{({20{~inst_vaddr[12]}}&Lo_0[6][25:6]|{20{inst_vaddr[12]}}&Lo_1[6][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[7]}}&{({20{~inst_vaddr[12]}}&Lo_0[7][25:6]|{20{inst_vaddr[12]}}&Lo_1[7][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[8]}}&{({20{~inst_vaddr[12]}}&Lo_0[8][25:6]|{20{inst_vaddr[12]}}&Lo_1[8][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[9]}}&{({20{~inst_vaddr[12]}}&Lo_0[9][25:6]|{20{inst_vaddr[12]}}&Lo_1[9][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[10]}}&{({20{~inst_vaddr[12]}}&Lo_0[10][25:6]|{20{inst_vaddr[12]}}&Lo_1[10][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[11]}}&{({20{~inst_vaddr[12]}}&Lo_0[11][25:6]|{20{inst_vaddr[12]}}&Lo_1[11][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[12]}}&{({20{~inst_vaddr[12]}}&Lo_0[12][25:6]|{20{inst_vaddr[12]}}&Lo_1[12][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[13]}}&{({20{~inst_vaddr[12]}}&Lo_0[13][25:6]|{20{inst_vaddr[12]}}&Lo_1[13][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[14]}}&{({20{~inst_vaddr[12]}}&Lo_0[14][25:6]|{20{inst_vaddr[12]}}&Lo_1[14][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[15]}}&{({20{~inst_vaddr[12]}}&Lo_0[15][25:6]|{20{inst_vaddr[12]}}&Lo_1[15][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[16]}}&{({20{~inst_vaddr[12]}}&Lo_0[16][25:6]|{20{inst_vaddr[12]}}&Lo_1[16][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[17]}}&{({20{~inst_vaddr[12]}}&Lo_0[17][25:6]|{20{inst_vaddr[12]}}&Lo_1[17][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[18]}}&{({20{~inst_vaddr[12]}}&Lo_0[18][25:6]|{20{inst_vaddr[12]}}&Lo_1[18][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[19]}}&{({20{~inst_vaddr[12]}}&Lo_0[19][25:6]|{20{inst_vaddr[12]}}&Lo_1[19][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[20]}}&{({20{~inst_vaddr[12]}}&Lo_0[20][25:6]|{20{inst_vaddr[12]}}&Lo_1[20][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[21]}}&{({20{~inst_vaddr[12]}}&Lo_0[21][25:6]|{20{inst_vaddr[12]}}&Lo_1[21][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[22]}}&{({20{~inst_vaddr[12]}}&Lo_0[22][25:6]|{20{inst_vaddr[12]}}&Lo_1[22][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[23]}}&{({20{~inst_vaddr[12]}}&Lo_0[23][25:6]|{20{inst_vaddr[12]}}&Lo_1[23][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[24]}}&{({20{~inst_vaddr[12]}}&Lo_0[24][25:6]|{20{inst_vaddr[12]}}&Lo_1[24][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[25]}}&{({20{~inst_vaddr[12]}}&Lo_0[25][25:6]|{20{inst_vaddr[12]}}&Lo_1[25][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[26]}}&{({20{~inst_vaddr[12]}}&Lo_0[26][25:6]|{20{inst_vaddr[12]}}&Lo_1[26][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[27]}}&{({20{~inst_vaddr[12]}}&Lo_0[27][25:6]|{20{inst_vaddr[12]}}&Lo_1[27][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[28]}}&{({20{~inst_vaddr[12]}}&Lo_0[28][25:6]|{20{inst_vaddr[12]}}&Lo_1[28][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[29]}}&{({20{~inst_vaddr[12]}}&Lo_0[29][25:6]|{20{inst_vaddr[12]}}&Lo_1[29][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[30]}}&{({20{~inst_vaddr[12]}}&Lo_0[30][25:6]|{20{inst_vaddr[12]}}&Lo_1[30][25:6]),inst_vaddr[11:0]}
                      |{32{inst_entryhit[31]}}&{({20{~inst_vaddr[12]}}&Lo_0[31][25:6]|{20{inst_vaddr[12]}}&Lo_1[31][25:6]),inst_vaddr[11:0]};
    assign data_paddr = {32{data_entryhit[0]}}&{({20{~data_vaddr[12]}}&Lo_0[0][25:6]|{20{data_vaddr[12]}}&Lo_1[0][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[1]}}&{({20{~data_vaddr[12]}}&Lo_0[1][25:6]|{20{data_vaddr[12]}}&Lo_1[1][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[2]}}&{({20{~data_vaddr[12]}}&Lo_0[2][25:6]|{20{data_vaddr[12]}}&Lo_1[2][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[3]}}&{({20{~data_vaddr[12]}}&Lo_0[3][25:6]|{20{data_vaddr[12]}}&Lo_1[3][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[4]}}&{({20{~data_vaddr[12]}}&Lo_0[4][25:6]|{20{data_vaddr[12]}}&Lo_1[4][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[5]}}&{({20{~data_vaddr[12]}}&Lo_0[5][25:6]|{20{data_vaddr[12]}}&Lo_1[5][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[6]}}&{({20{~data_vaddr[12]}}&Lo_0[6][25:6]|{20{data_vaddr[12]}}&Lo_1[6][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[7]}}&{({20{~data_vaddr[12]}}&Lo_0[7][25:6]|{20{data_vaddr[12]}}&Lo_1[7][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[8]}}&{({20{~data_vaddr[12]}}&Lo_0[8][25:6]|{20{data_vaddr[12]}}&Lo_1[8][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[9]}}&{({20{~data_vaddr[12]}}&Lo_0[9][25:6]|{20{data_vaddr[12]}}&Lo_1[9][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[10]}}&{({20{~data_vaddr[12]}}&Lo_0[10][25:6]|{20{data_vaddr[12]}}&Lo_1[10][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[11]}}&{({20{~data_vaddr[12]}}&Lo_0[11][25:6]|{20{data_vaddr[12]}}&Lo_1[11][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[12]}}&{({20{~data_vaddr[12]}}&Lo_0[12][25:6]|{20{data_vaddr[12]}}&Lo_1[12][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[13]}}&{({20{~data_vaddr[12]}}&Lo_0[13][25:6]|{20{data_vaddr[12]}}&Lo_1[13][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[14]}}&{({20{~data_vaddr[12]}}&Lo_0[14][25:6]|{20{data_vaddr[12]}}&Lo_1[14][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[15]}}&{({20{~data_vaddr[12]}}&Lo_0[15][25:6]|{20{data_vaddr[12]}}&Lo_1[15][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[16]}}&{({20{~data_vaddr[12]}}&Lo_0[16][25:6]|{20{data_vaddr[12]}}&Lo_1[16][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[17]}}&{({20{~data_vaddr[12]}}&Lo_0[17][25:6]|{20{data_vaddr[12]}}&Lo_1[17][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[18]}}&{({20{~data_vaddr[12]}}&Lo_0[18][25:6]|{20{data_vaddr[12]}}&Lo_1[18][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[19]}}&{({20{~data_vaddr[12]}}&Lo_0[19][25:6]|{20{data_vaddr[12]}}&Lo_1[19][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[20]}}&{({20{~data_vaddr[12]}}&Lo_0[20][25:6]|{20{data_vaddr[12]}}&Lo_1[20][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[21]}}&{({20{~data_vaddr[12]}}&Lo_0[21][25:6]|{20{data_vaddr[12]}}&Lo_1[21][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[22]}}&{({20{~data_vaddr[12]}}&Lo_0[22][25:6]|{20{data_vaddr[12]}}&Lo_1[22][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[23]}}&{({20{~data_vaddr[12]}}&Lo_0[23][25:6]|{20{data_vaddr[12]}}&Lo_1[23][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[24]}}&{({20{~data_vaddr[12]}}&Lo_0[24][25:6]|{20{data_vaddr[12]}}&Lo_1[24][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[25]}}&{({20{~data_vaddr[12]}}&Lo_0[25][25:6]|{20{data_vaddr[12]}}&Lo_1[25][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[26]}}&{({20{~data_vaddr[12]}}&Lo_0[26][25:6]|{20{data_vaddr[12]}}&Lo_1[26][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[27]}}&{({20{~data_vaddr[12]}}&Lo_0[27][25:6]|{20{data_vaddr[12]}}&Lo_1[27][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[28]}}&{({20{~data_vaddr[12]}}&Lo_0[28][25:6]|{20{data_vaddr[12]}}&Lo_1[28][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[29]}}&{({20{~data_vaddr[12]}}&Lo_0[29][25:6]|{20{data_vaddr[12]}}&Lo_1[29][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[30]}}&{({20{~data_vaddr[12]}}&Lo_0[30][25:6]|{20{data_vaddr[12]}}&Lo_1[30][25:6]),data_vaddr[11:0]}
                      |{32{data_entryhit[31]}}&{({20{~data_vaddr[12]}}&Lo_0[31][25:6]|{20{data_vaddr[12]}}&Lo_1[31][25:6]),data_vaddr[11:0]};
    wire [5:0] inst_flag;
    wire [5:0] data_flag;

    assign inst_flag = {6{inst_entryhit[0]}}&({6{~inst_vaddr[12]}}&Lo_0[0][5:0]|{6{inst_vaddr[12]}}&Lo_1[0][5:0])
                       |{6{inst_entryhit[1]}}&({6{~inst_vaddr[12]}}&Lo_0[1][5:0]|{6{inst_vaddr[12]}}&Lo_1[1][5:0])
                       |{6{inst_entryhit[2]}}&({6{~inst_vaddr[12]}}&Lo_0[2][5:0]|{6{inst_vaddr[12]}}&Lo_1[2][5:0])
                       |{6{inst_entryhit[3]}}&({6{~inst_vaddr[12]}}&Lo_0[3][5:0]|{6{inst_vaddr[12]}}&Lo_1[3][5:0])
                       |{6{inst_entryhit[4]}}&({6{~inst_vaddr[12]}}&Lo_0[4][5:0]|{6{inst_vaddr[12]}}&Lo_1[4][5:0])
                       |{6{inst_entryhit[5]}}&({6{~inst_vaddr[12]}}&Lo_0[5][5:0]|{6{inst_vaddr[12]}}&Lo_1[5][5:0])
                       |{6{inst_entryhit[6]}}&({6{~inst_vaddr[12]}}&Lo_0[6][5:0]|{6{inst_vaddr[12]}}&Lo_1[6][5:0])
                       |{6{inst_entryhit[7]}}&({6{~inst_vaddr[12]}}&Lo_0[7][5:0]|{6{inst_vaddr[12]}}&Lo_1[7][5:0])
                       |{6{inst_entryhit[8]}}&({6{~inst_vaddr[12]}}&Lo_0[8][5:0]|{6{inst_vaddr[12]}}&Lo_1[8][5:0])
                       |{6{inst_entryhit[9]}}&({6{~inst_vaddr[12]}}&Lo_0[9][5:0]|{6{inst_vaddr[12]}}&Lo_1[9][5:0])
                       |{6{inst_entryhit[10]}}&({6{~inst_vaddr[12]}}&Lo_0[10][5:0]|{6{inst_vaddr[12]}}&Lo_1[10][5:0])
                       |{6{inst_entryhit[11]}}&({6{~inst_vaddr[12]}}&Lo_0[11][5:0]|{6{inst_vaddr[12]}}&Lo_1[11][5:0])
                       |{6{inst_entryhit[12]}}&({6{~inst_vaddr[12]}}&Lo_0[12][5:0]|{6{inst_vaddr[12]}}&Lo_1[12][5:0])
                       |{6{inst_entryhit[13]}}&({6{~inst_vaddr[12]}}&Lo_0[13][5:0]|{6{inst_vaddr[12]}}&Lo_1[13][5:0])
                       |{6{inst_entryhit[14]}}&({6{~inst_vaddr[12]}}&Lo_0[14][5:0]|{6{inst_vaddr[12]}}&Lo_1[14][5:0])
                       |{6{inst_entryhit[15]}}&({6{~inst_vaddr[12]}}&Lo_0[15][5:0]|{6{inst_vaddr[12]}}&Lo_1[15][5:0])
                       |{6{inst_entryhit[16]}}&({6{~inst_vaddr[12]}}&Lo_0[16][5:0]|{6{inst_vaddr[12]}}&Lo_1[16][5:0])
                       |{6{inst_entryhit[17]}}&({6{~inst_vaddr[12]}}&Lo_0[17][5:0]|{6{inst_vaddr[12]}}&Lo_1[17][5:0])
                       |{6{inst_entryhit[18]}}&({6{~inst_vaddr[12]}}&Lo_0[18][5:0]|{6{inst_vaddr[12]}}&Lo_1[18][5:0])
                       |{6{inst_entryhit[19]}}&({6{~inst_vaddr[12]}}&Lo_0[19][5:0]|{6{inst_vaddr[12]}}&Lo_1[19][5:0])
                       |{6{inst_entryhit[20]}}&({6{~inst_vaddr[12]}}&Lo_0[20][5:0]|{6{inst_vaddr[12]}}&Lo_1[20][5:0])
                       |{6{inst_entryhit[21]}}&({6{~inst_vaddr[12]}}&Lo_0[21][5:0]|{6{inst_vaddr[12]}}&Lo_1[21][5:0])
                       |{6{inst_entryhit[22]}}&({6{~inst_vaddr[12]}}&Lo_0[22][5:0]|{6{inst_vaddr[12]}}&Lo_1[22][5:0])
                       |{6{inst_entryhit[23]}}&({6{~inst_vaddr[12]}}&Lo_0[23][5:0]|{6{inst_vaddr[12]}}&Lo_1[23][5:0])
                       |{6{inst_entryhit[24]}}&({6{~inst_vaddr[12]}}&Lo_0[24][5:0]|{6{inst_vaddr[12]}}&Lo_1[24][5:0])
                       |{6{inst_entryhit[25]}}&({6{~inst_vaddr[12]}}&Lo_0[25][5:0]|{6{inst_vaddr[12]}}&Lo_1[25][5:0])
                       |{6{inst_entryhit[26]}}&({6{~inst_vaddr[12]}}&Lo_0[26][5:0]|{6{inst_vaddr[12]}}&Lo_1[26][5:0])
                       |{6{inst_entryhit[27]}}&({6{~inst_vaddr[12]}}&Lo_0[27][5:0]|{6{inst_vaddr[12]}}&Lo_1[27][5:0])
                       |{6{inst_entryhit[28]}}&({6{~inst_vaddr[12]}}&Lo_0[28][5:0]|{6{inst_vaddr[12]}}&Lo_1[28][5:0])
                       |{6{inst_entryhit[29]}}&({6{~inst_vaddr[12]}}&Lo_0[29][5:0]|{6{inst_vaddr[12]}}&Lo_1[29][5:0])
                       |{6{inst_entryhit[30]}}&({6{~inst_vaddr[12]}}&Lo_0[30][5:0]|{6{inst_vaddr[12]}}&Lo_1[30][5:0])
                       |{6{inst_entryhit[31]}}&({6{~inst_vaddr[12]}}&Lo_0[31][5:0]|{6{inst_vaddr[12]}}&Lo_1[31][5:0]);
                       



    assign data_flag = {6{data_entryhit[0]}}&({6{~data_vaddr[12]}}&Lo_0[0][5:0]|{6{data_vaddr[12]}}&Lo_1[0][5:0])
                       |{6{data_entryhit[1]}}&({6{~data_vaddr[12]}}&Lo_0[1][5:0]|{6{data_vaddr[12]}}&Lo_1[1][5:0])
                       |{6{data_entryhit[2]}}&({6{~data_vaddr[12]}}&Lo_0[2][5:0]|{6{data_vaddr[12]}}&Lo_1[2][5:0])
                       |{6{data_entryhit[3]}}&({6{~data_vaddr[12]}}&Lo_0[3][5:0]|{6{data_vaddr[12]}}&Lo_1[3][5:0])
                       |{6{data_entryhit[4]}}&({6{~data_vaddr[12]}}&Lo_0[4][5:0]|{6{data_vaddr[12]}}&Lo_1[4][5:0])
                       |{6{data_entryhit[5]}}&({6{~data_vaddr[12]}}&Lo_0[5][5:0]|{6{data_vaddr[12]}}&Lo_1[5][5:0])
                       |{6{data_entryhit[6]}}&({6{~data_vaddr[12]}}&Lo_0[6][5:0]|{6{data_vaddr[12]}}&Lo_1[6][5:0])
                       |{6{data_entryhit[7]}}&({6{~data_vaddr[12]}}&Lo_0[7][5:0]|{6{data_vaddr[12]}}&Lo_1[7][5:0])
                       |{6{data_entryhit[8]}}&({6{~data_vaddr[12]}}&Lo_0[8][5:0]|{6{data_vaddr[12]}}&Lo_1[8][5:0])
                       |{6{data_entryhit[9]}}&({6{~data_vaddr[12]}}&Lo_0[9][5:0]|{6{data_vaddr[12]}}&Lo_1[9][5:0])
                       |{6{data_entryhit[10]}}&({6{~data_vaddr[12]}}&Lo_0[10][5:0]|{6{data_vaddr[12]}}&Lo_1[10][5:0])
                       |{6{data_entryhit[11]}}&({6{~data_vaddr[12]}}&Lo_0[11][5:0]|{6{data_vaddr[12]}}&Lo_1[11][5:0])
                       |{6{data_entryhit[12]}}&({6{~data_vaddr[12]}}&Lo_0[12][5:0]|{6{data_vaddr[12]}}&Lo_1[12][5:0])
                       |{6{data_entryhit[13]}}&({6{~data_vaddr[12]}}&Lo_0[13][5:0]|{6{data_vaddr[12]}}&Lo_1[13][5:0])
                       |{6{data_entryhit[14]}}&({6{~data_vaddr[12]}}&Lo_0[14][5:0]|{6{data_vaddr[12]}}&Lo_1[14][5:0])
                       |{6{data_entryhit[15]}}&({6{~data_vaddr[12]}}&Lo_0[15][5:0]|{6{data_vaddr[12]}}&Lo_1[15][5:0])
                       |{6{data_entryhit[16]}}&({6{~data_vaddr[12]}}&Lo_0[16][5:0]|{6{data_vaddr[12]}}&Lo_1[16][5:0])
                       |{6{data_entryhit[17]}}&({6{~data_vaddr[12]}}&Lo_0[17][5:0]|{6{data_vaddr[12]}}&Lo_1[17][5:0])
                       |{6{data_entryhit[18]}}&({6{~data_vaddr[12]}}&Lo_0[18][5:0]|{6{data_vaddr[12]}}&Lo_1[18][5:0])
                       |{6{data_entryhit[19]}}&({6{~data_vaddr[12]}}&Lo_0[19][5:0]|{6{data_vaddr[12]}}&Lo_1[19][5:0])
                       |{6{data_entryhit[20]}}&({6{~data_vaddr[12]}}&Lo_0[20][5:0]|{6{data_vaddr[12]}}&Lo_1[20][5:0])
                       |{6{data_entryhit[21]}}&({6{~data_vaddr[12]}}&Lo_0[21][5:0]|{6{data_vaddr[12]}}&Lo_1[21][5:0])
                       |{6{data_entryhit[22]}}&({6{~data_vaddr[12]}}&Lo_0[22][5:0]|{6{data_vaddr[12]}}&Lo_1[22][5:0])
                       |{6{data_entryhit[23]}}&({6{~data_vaddr[12]}}&Lo_0[23][5:0]|{6{data_vaddr[12]}}&Lo_1[23][5:0])
                       |{6{data_entryhit[24]}}&({6{~data_vaddr[12]}}&Lo_0[24][5:0]|{6{data_vaddr[12]}}&Lo_1[24][5:0])
                       |{6{data_entryhit[25]}}&({6{~data_vaddr[12]}}&Lo_0[25][5:0]|{6{data_vaddr[12]}}&Lo_1[25][5:0])
                       |{6{data_entryhit[26]}}&({6{~data_vaddr[12]}}&Lo_0[26][5:0]|{6{data_vaddr[12]}}&Lo_1[26][5:0])
                       |{6{data_entryhit[27]}}&({6{~data_vaddr[12]}}&Lo_0[27][5:0]|{6{data_vaddr[12]}}&Lo_1[27][5:0])
                       |{6{data_entryhit[28]}}&({6{~data_vaddr[12]}}&Lo_0[28][5:0]|{6{data_vaddr[12]}}&Lo_1[28][5:0])
                       |{6{data_entryhit[29]}}&({6{~data_vaddr[12]}}&Lo_0[29][5:0]|{6{data_vaddr[12]}}&Lo_1[29][5:0])
                       |{6{data_entryhit[30]}}&({6{~data_vaddr[12]}}&Lo_0[30][5:0]|{6{data_vaddr[12]}}&Lo_1[30][5:0])
                       |{6{data_entryhit[31]}}&({6{~data_vaddr[12]}}&Lo_0[31][5:0]|{6{data_vaddr[12]}}&Lo_1[31][5:0]);

assign inst_pfn = inst_paddr[31:12];
assign data_pfn = data_paddr[31:12];
assign inst_c = inst_flag[5:3];
assign inst_d = inst_flag[2];
assign inst_v = inst_flag[1];

assign data_c = data_flag[5:3];
assign data_d = data_flag[2];
assign data_v = data_flag[1];


assign read_EntryHi = {VPN2[Index],5'b0,ASID[Index]};
assign read_PageMask = {7'b0,PMask[Index],13'b0};
assign read_EntryLo0 = {Lo_0[Index][31:1],G[Index]};
assign read_EntryLo1 = {Lo_1[Index][31:1],G[Index]};

wire [`DATA_WIDTH-1:0] p_entryhit;

//assign p_entryhit[0]=((EntryHi[31:13]==VPN2[0])&&(ASID[0]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[0]=((EntryHi[31:13]==VPN2[0])&&(G[0]||ASID[0]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[1]=((EntryHi[31:13]==VPN2[1])&&(G[1]||ASID[1]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[2]=((EntryHi[31:13]==VPN2[2])&&(G[2]||ASID[2]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[3]=((EntryHi[31:13]==VPN2[3])&&(G[3]||ASID[3]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[4]=((EntryHi[31:13]==VPN2[4])&&(G[4]||ASID[4]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[5]=((EntryHi[31:13]==VPN2[5])&&(G[5]||ASID[5]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[6]=((EntryHi[31:13]==VPN2[6])&&(G[6]||ASID[6]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[7]=((EntryHi[31:13]==VPN2[7])&&(G[7]||ASID[7]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[8]=((EntryHi[31:13]==VPN2[8])&&(G[8]||ASID[8]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[9]=((EntryHi[31:13]==VPN2[9])&&(G[9]||ASID[9]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[10]=((EntryHi[31:13]==VPN2[10])&&(G[10]||ASID[10]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[11]=((EntryHi[31:13]==VPN2[11])&&(G[11]||ASID[11]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[12]=((EntryHi[31:13]==VPN2[12])&&(G[12]||ASID[12]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[13]=((EntryHi[31:13]==VPN2[13])&&(G[13]|ASID[13]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[14]=((EntryHi[31:13]==VPN2[14])&&(G[14]||ASID[14]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[15]=((EntryHi[31:13]==VPN2[15])&&(G[15]||ASID[15]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[16]=((EntryHi[31:13]==VPN2[16])&&(G[16]||ASID[16]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[17]=((EntryHi[31:13]==VPN2[17])&&(G[17]||ASID[17]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[18]=((EntryHi[31:13]==VPN2[18])&&(G[18]||ASID[18]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[19]=((EntryHi[31:13]==VPN2[19])&&(G[19]||ASID[19]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[20]=((EntryHi[31:13]==VPN2[20])&&(G[20]||ASID[20]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[21]=((EntryHi[31:13]==VPN2[21])&&(G[21]||ASID[21]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[22]=((EntryHi[31:13]==VPN2[22])&&(G[22]||ASID[22]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[23]=((EntryHi[31:13]==VPN2[23])&&(G[23]||ASID[23]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[24]=((EntryHi[31:13]==VPN2[24])&&(G[24]||ASID[24]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[25]=((EntryHi[31:13]==VPN2[25])&&(G[25]||ASID[25]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[26]=((EntryHi[31:13]==VPN2[26])&&(G[26]||ASID[26]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[27]=((EntryHi[31:13]==VPN2[27])&&(G[27]||ASID[27]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[28]=((EntryHi[31:13]==VPN2[28])&&(G[28]||ASID[28]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[29]=((EntryHi[31:13]==VPN2[29])&&(G[29]||ASID[29]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[30]=((EntryHi[31:13]==VPN2[30])&&(G[30]||ASID[30]==EntryHi[7:0]))?1'b1:1'b0;
assign p_entryhit[31]=((EntryHi[31:13]==VPN2[31])&&(G[31]||ASID[31]==EntryHi[7:0]))?1'b1:1'b0;

assign p_hit = |p_entryhit;

assign PIndex = {5{p_entryhit[0]}}&5'd0
                |{5{p_entryhit[1]}}&5'd1
                |{5{p_entryhit[2]}}&5'd2
                |{5{p_entryhit[3]}}&5'd3
                |{5{p_entryhit[4]}}&5'd4
                |{5{p_entryhit[5]}}&5'd5
                |{5{p_entryhit[6]}}&5'd6
                |{5{p_entryhit[7]}}&5'd7
                |{5{p_entryhit[8]}}&5'd8
                |{5{p_entryhit[9]}}&5'd9
                |{5{p_entryhit[10]}}&5'd10
                |{5{p_entryhit[11]}}&5'd11
                |{5{p_entryhit[12]}}&5'd12
                |{5{p_entryhit[13]}}&5'd13
                |{5{p_entryhit[14]}}&5'd14
                |{5{p_entryhit[15]}}&5'd15
                |{5{p_entryhit[16]}}&5'd16
                |{5{p_entryhit[17]}}&5'd17
                |{5{p_entryhit[18]}}&5'd18
                |{5{p_entryhit[19]}}&5'd19
                |{5{p_entryhit[20]}}&5'd20
                |{5{p_entryhit[21]}}&5'd21
                |{5{p_entryhit[22]}}&5'd22
                |{5{p_entryhit[23]}}&5'd23
                |{5{p_entryhit[24]}}&5'd24
                |{5{p_entryhit[25]}}&5'd25
                |{5{p_entryhit[26]}}&5'd26
                |{5{p_entryhit[27]}}&5'd27
                |{5{p_entryhit[28]}}&5'd28
                |{5{p_entryhit[29]}}&5'd29
                |{5{p_entryhit[30]}}&5'd30
                |{5{p_entryhit[31]}}&5'd31;


 
   assign inst_tlb_exception = (inst_hit==0)?2'b01:
                               (inst_v==0)?2'b10:
                               (inst_d==0)?2'b11:
                               2'b0;
   assign data_tlb_exception = (data_hit==0)?2'b01:
                               (data_v==0)?2'b10:
                               (data_d==0)?2'b11:
                               2'b0;               



always@(posedge clk)
begin
  if(wen)
  begin
    VPN2[Index[4:0]]<=EntryHi[31:13];
    ASID[Index[4:0]]<=EntryHi[7:0];
    PMask[Index[4:0]] <= PageMask;
    Lo_0[Index[4:0]]<=EntryLo0[25:0];
    Lo_1[Index[4:0]]<=EntryLo1[25:0];
    G[Index[4:0]]<=EntryLo0[0]&EntryLo1[0];
  end
end
endmodule



                      


    
    
