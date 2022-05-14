
module full_hash_des_box(
   input clk,
   input M_valid,
   input rst_n,
   input message [7:0],
   input counter [63:0],
   output reg digest [31:0],
   output reg hash_ready,
);

localparam h_0 = 4'h4;
localparam h_1 = 4'hB;
localparam h_2 = 4'h7;
localparam h_3 = 4'h1;
localparam h_4 = 4'hD;
localparam h_5 = 4'hF;
localparam h_6 = 4'h0;
localparam h_7 = 4'h3;

module S_Box(
   input in [5:0],
   output reg out [3:0]
);
   //The first and last bit of the input identify the row of the S-box
   reg row [1:0];
   //The 4 central bits identify the column of the S-box
   reg column [3:0];
   
   
   always @(*) begin
   
    row = {in[5],in[0]};
    column = in[4:1];
	
    case(row)
	
	   2'b00: case(column)
	   
	    4'b0000: out = 4'b0010;
		4'b0001: out = 4'b1100;
		4'b0010: out = 4'b0100;
		4'b0011: out = 4'b0001;
		4'b0100: out = 4'b0111;
		4'b0101: out = 4'b1010;
		4'b0110: out = 4'b1011;
		4'b0111: out = 4'b0110;
		4'b1000: out = 4'b1000;
		4'b1001: out = 4'b0101;
		4'b1010: out = 4'b0011;
		4'b1011: out = 4'b1111;
		4'b1100: out = 4'b1101;
		4'b1101: out = 4'b0000;
		4'b1110: out = 4'b1110;
		4'b1111: out = 4'b1001;
		
		endcase
	  
	   2'b01: case(column)
	   
	    4'b0000: out = 4'b1110;
		4'b0001: out = 4'b1011;
		4'b0010: out = 4'b0010;
		4'b0011: out = 4'b1100;
		4'b0100: out = 4'b0100;
		4'b0101: out = 4'b0111;
		4'b0110: out = 4'b1101;
		4'b0111: out = 4'b0001;
		4'b1000: out = 4'b0101;
		4'b1001: out = 4'b0000;
		4'b1010: out = 4'b1111;
		4'b1011: out = 4'b1100;
		4'b1100: out = 4'b0011;
		4'b1101: out = 4'b1001;
		4'b1110: out = 4'b1000;
		4'b1111: out = 4'b0110;
	    
		endcase
		
	   2'b10: case(column)
	   
	    4'b0000: out = 4'b0100;
		4'b0001: out = 4'b0010;
		4'b0010: out = 4'b0001;
		4'b0011: out = 4'b1011;
		4'b0100: out = 4'b1100;
		4'b0101: out = 4'b1101;
		4'b0110: out = 4'b0111;
		4'b0111: out = 4'b1000;
		4'b1000: out = 4'b1111;
		4'b1001: out = 4'b1001;
		4'b1010: out = 4'b1100;
		4'b1011: out = 4'b0101;
		4'b1100: out = 4'b0110;
		4'b1101: out = 4'b0011;
		4'b1110: out = 4'b0000;
		4'b1111: out = 4'b1110;
		
		endcase
		
	   2'b11: case(column)
	    
		4'b0000: out = 4'b1011;
		4'b0001: out = 4'b1000;
		4'b0010: out = 4'b1100;
		4'b0011: out = 4'b0111;
		4'b0100: out = 4'b0001;
		4'b0101: out = 4'b1110;
		4'b0110: out = 4'b0010;
		4'b0111: out = 4'b1101;
		4'b1000: out = 4'b0110;
		4'b1001: out = 4'b1111;
		4'b1010: out = 4'b0000;
		4'b1011: out = 4'b1001;
		4'b1100: out = 4'b1100;
		4'b1101: out = 4'b0100;
		4'b1110: out = 4'b0101;
		4'b1111: out = 4'b0011;
		
		endcase
		
	endcase
	
   end

endmodule



   

