module booth_2bit(
    input y_2,
    input y_1,
    input y_0,
    input [33:0] x,

    output [67:0] P,
    output c 
    
    );


wire [67:0] x_extend;
wire [67:0] x_bu;
wire [67:0] double_x_bu;
wire [67:0]nega_x_bu;
wire [67:0] nega_2_x_bu;

assign x_extend={{34{x[33]}},x};

assign x_bu=x_extend;
assign double_x_bu=x_extend<<1;
assign nega_x_bu=~x_extend+1;//末位未加1
//assign nega_2_x_bu={(~x_extend),1'b1};//末位未加1
assign nega_2_x_bu=(~x_extend+1)<<1;

assign P=({68{(~y_2&~y_1&~y_0)}}&68'b0
        |{68{(~y_2&~y_1&y_0)}}&x_bu
        |{68{(~y_2&y_1&~y_0)}}&x_bu
        |{68{(~y_2&y_1&y_0)}}&double_x_bu
        |{68{(y_2&~y_1&~y_0)}}&nega_2_x_bu
        |{68{(y_2&~y_1&y_0)}}&nega_x_bu
        |{68{(y_2&y_1&~y_0)}}&nega_x_bu
        |{68{(y_2&y_1&y_0)}}&68'b0);

//assign c=(((~y_2&~y_1&~y_0)&1'b0)
  //      |((~y_2&~y_1&y_0)&1'b0)
    //    |((~y_2&y_1&~y_0)&1'b0)
      //  |((~y_2&y_1&y_0)&1'b0)
      //  |((y_2&~y_1&~y_0)&1'b1)
      //  |((y_2&~y_1&y_0)&1'b1)
      //  |((y_2&y_1&~y_0)&1'b1)
      //  |((y_2&y_1&y_0)&1'b0));
      
      assign c=1'b0;

endmodule