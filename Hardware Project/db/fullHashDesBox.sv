// This file contains the full_hash_des_sbox SystemVerilog description
// for the project ofthe course Hardware and Embedded Security at
// the University of Pisa
// Students: Venturini Francesco, Bigliazzi Pierfrancesco
// Professors: Saponara Sergio, Crocetti Luca


// This module implements a LUT version of the DES S-box
module S_Box(input [5:0] in, output reg [3:0] out);

   //The first and last bit of the input identify the row of the S-box
   reg [1:0] row;

   //The 4 central bits identify the column of the S-box
   reg [3:0] column;
   
   always @(*) begin
	   
    	row = {in[5],in[0]};
    	column = in[4:1];
	
    	case(row)
			2'b00: 
				case(column)
					4'b0000: out = 4'b0010; 4'b0001: out = 4'b1100;
					4'b0010: out = 4'b0100; 4'b0011: out = 4'b0001;
					4'b0100: out = 4'b0111; 4'b0101: out = 4'b1010;
					4'b0110: out = 4'b1011; 4'b0111: out = 4'b0110;
					4'b1000: out = 4'b1000; 4'b1001: out = 4'b0101;
					4'b1010: out = 4'b0011; 4'b1011: out = 4'b1111;
					4'b1100: out = 4'b1101; 4'b1101: out = 4'b0000;
					4'b1110: out = 4'b1110; 4'b1111: out = 4'b1001;
				endcase
			2'b01: 
				case(column)
					4'b0000: out = 4'b1110; 4'b0001: out = 4'b1011;
					4'b0010: out = 4'b0010; 4'b0011: out = 4'b1100;
					4'b0100: out = 4'b0100; 4'b0101: out = 4'b0111;
					4'b0110: out = 4'b1101; 4'b0111: out = 4'b0001;
					4'b1000: out = 4'b0101; 4'b1001: out = 4'b0000;
					4'b1010: out = 4'b1111; 4'b1011: out = 4'b1100;
					4'b1100: out = 4'b0011; 4'b1101: out = 4'b1001;
					4'b1110: out = 4'b1000; 4'b1111: out = 4'b0110;
				endcase
			2'b10: 
				case(column)
					4'b0000: out = 4'b0100; 4'b0001: out = 4'b0010;
					4'b0010: out = 4'b0001; 4'b0011: out = 4'b1011;
					4'b0100: out = 4'b1100; 4'b0101: out = 4'b1101;
					4'b0110: out = 4'b0111; 4'b0111: out = 4'b1000;
					4'b1000: out = 4'b1111; 4'b1001: out = 4'b1001;
					4'b1010: out = 4'b1100; 4'b1011: out = 4'b0101;
					4'b1100: out = 4'b0110; 4'b1101: out = 4'b0011;
					4'b1110: out = 4'b0000; 4'b1111: out = 4'b1110;
				endcase	
			2'b11: 
				case(column)
					4'b0000: out = 4'b1011; 4'b0001: out = 4'b1000;
					4'b0010: out = 4'b1100; 4'b0011: out = 4'b0111;
					4'b0100: out = 4'b0001; 4'b0101: out = 4'b1110;
					4'b0110: out = 4'b0010; 4'b0111: out = 4'b1101;
					4'b1000: out = 4'b0110; 4'b1001: out = 4'b1111;
					4'b1010: out = 4'b0000; 4'b1011: out = 4'b1001;
					4'b1100: out = 4'b1100; 4'b1101: out = 4'b0100;
					4'b1110: out = 4'b0101; 4'b1111: out = 4'b0011;
				endcase
		endcase
   	end
endmodule


//Transform an 8-bit character into a 6-bit character
module Message_To_M_6(input [7:0] in, output [5:0] out);
	assign out = {in[3]^in[2], in[1], in[0], in[7], in[6], in[5]^in[4]};
endmodule

//Perform one round of the main hash algorithm
module Hash_Round(
	input [3:0] SBox_value, // output of the DES S-Box LUT table
	input h_main [7:0] [3:0], // previous hash values
    output reg h_out [7:0] [3:0] // new hash values
);

reg [3:0] tmp;

always(*) begin
	
	tmp = h_main[1] ^ SBox_value;
	h_out[0] = tmp;
	
	tmp = h_main[2] ^ SBox_value;
	h_out[1] = tmp;
	
	tmp = h_main[3] ^ SBox_value;
	h_out[2] = {tmp[2:0],tmp[3]};
	
	tmp = h_main[4] ^ SBox_value;
	h_out[3] = {tmp[2:0],tmp[3]};
	
	tmp = h_main[5] ^ SBox_value;
	h_out[4] = {tmp[1:0],tmp[3:2]};
	
	tmp = h_main[6] ^ SBox_value;
	h_out[5] = {tmp[1:0],tmp[3:2]};
	
	tmp = h_main[7] ^ SBox_value;
	h_out[6] = {tmp[0],tmp[3:1]};
	
	tmp = h_main[0] ^ SBox_value;
	h_out[7] = {tmp[0],tmp[3:1]};

end

endmodule

//Main hash algorithm
//4 rounds
module H_main_computation(
	input M[7:0],
	input h_main[7:0] [3:0],
	output reg h_main_final[7:0] [3:0]
);

wire M6[5:0];

Message_To_M_6 M_to_M6(
	.in(M),
	.out(M6)
);

reg S_value[3:0];

S_Box SBox(
	.in(M6),
	.out(S_value)
);

reg H_main_1[7:0] [3:0];



Hash_Round Round_1(
	.S_box_value(S_value),
	.h_main(h_main),
	.h_out(H_main_1)
);

reg H_main_2[7:0] [3:0];

Hash_Round Round_2(
	.S_box_value(S_value),
	.h_main(H_main_1),
	.h_out(H_main_2)
);

reg H_main_3[7:0] [3:0];

Hash_Round Round_3(
	.S_box_value(S_value),
	.h_main(H_main_2),
	.h_out(H_main_3)
);


Hash_Round Round_4(
	.S_box_value(S_value),
	.h_main(H_main_3),
	.h_out(H_main_final)
);

endmodule

//Transform one byte of the message length into a 6-bit value 
module Counter_to_C_6(
	input in_c[7:0],
	output reg out_c[5:0]
);

always(*) begin

	out_c = {in_c[7] ^ in_c[1],in_c[3],in_c[2],in_c[5] ^ in_c[0],in_c[4],in_c[6]};

end

endmodule

//Perform the last part of the hash algorithm
module H_last_computation(
	input H_main[7:0] [3:0],
	input counter[63:0],
	output reg H_last[7:0] [3:0]
);

reg idx[7:0][5:0];

reg S_value[7:0][3:0];

Counter_to_C_6 C6_0(
	.in_c(counter[63:56]),
	.out_c(idx[0])
);

S_Box Sbox0(
	.in(idx[0]),
	.out(S_value[0]),
);

Counter_to_C_6 C6_1(
	.in_c(counter[55:48]),
	.out_c(idx[1])
);

S_Box Sbox1(
	.in(idx[1]),
	.out(S_value[1]),
);

Counter_to_C_6 C6_2(
	.in_c(counter[47:40]),
	.out_c(idx[2])
);

S_Box Sbox2(
	.in(idx[2]),
	.out(S_value[2]),
);

Counter_to_C_6 C6_3(
	.in_c(counter[39:32]),
	.out_c(idx[3])
);

S_Box Sbox3(
	.in(idx[3]),
	.out(S_value[3]),
);

Counter_to_C_6 C6_4(
	.in_c(counter[31:24]),
	.out_c(idx[4])
);

S_Box Sbox4(
	.in(idx[4]),
	.out(S_value[4]),
);

Counter_to_C_6 C6_5(
	.in_c(counter[23:16]),
	.out_c(idx[5])
);

S_Box Sbox5(
	.in(idx[5]),
	.out(S_value[5]),
);

Counter_to_C_6 C6_6(
	.in_c(counter[15:8]),
	.out_c(idx[6])
);

S_Box Sbox6(
	.in(idx[6]),
	.out(S_value[6]),
);

Counter_to_C_6 C6_7(
	.in_c(counter[7:0]),
	.out_c(idx[7])
);

S_Box Sbox7(
	.in(idx[7]),
	.out(S_value[7]),
);


module full_hash_des_box(
   input clk,
   input m_valid,
   input rst_n,
   input message [7:0],
   input counter [63:0],
   output reg digest_out [31:0],
   output reg hash_ready
);

localparam h_0 = 4'h4;
localparam h_1 = 4'hB;
localparam h_2 = 4'h7;
localparam h_3 = 4'h1;
localparam h_4 = 4'hD;
localparam h_5 = 4'hF;
localparam h_6 = 4'h0;
localparam h_7 = 4'h3;

localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;



//Wire which contains the result of computation on the message M
reg [5:0] M_6;

reg [5:0] C_TMP [7:0];
reg [5:0] C_6 [7:0];

reg [7:0] MSG;

reg [63:0] C_COUNT;

reg [3:0] S_M_6;

reg [3:0] S_C_6;
//Reg used for the main computation
reg [3:0] H_MAIN [7:0];
//Reg used for the last computation
reg [3:0] H_LAST [7:0];
//Reg used to store the value of hash_ready
reg HASH_READY;
//Reg which will contain the final digest
reg [31:0] DIGEST;

reg [2:0] STAR;


// assign M_6 = {M[3]^M[2],M[1],M[0],M[7],M[6],M[5]^M[4]};

//S_Box S_Box_Table(
//   in(M_6),
//   out(S_M_6)
//   )
   
always @(m_valid) begin
	M_6 = {M[3]^M[2],M[1],M[0],M[7],M[6],M[5]^M[4]};
	C_TMP[0] = {counter[7] ^ counter[1], counter[3], counter[2], counter[5] ^ counter[0], counter[4], counter[6]};
	C_TMP[1] = {counter[15] ^ counter[9], counter[11], counter[10], counter[13] ^ counter[8], counter[12], counter[14]};
	C_TMP[2] = {counter[23] ^ counter[17], counter[19], counter[18], counter[21] ^ counter[16], counter[20], counter[22]};
	C_TMP[3] = {counter[31] ^ counter[25], counter[28], counter[26], counter[29] ^ counter[24], counter[28], counter[30]};
	C_TMP[4] = {counter[39] ^ counter[33], counter[36], counter[34], counter[37] ^ counter[32], counter[36], counter[38]};
	C_TMP[5] = {counter[47] ^ counter[41], counter[44], counter[42], counter[45] ^ counter[40], counter[44], counter[46]};
	C_TMP[6] = {counter[55] ^ counter[49], counter[52], counter[50], counter[53] ^ counter[48], counter[52], counter[54]};
	C_TMP[7] = {counter[63] ^ counter[57], counter[60], counter[58], counter[61] ^ counter[56], counter[60], counter[62]};
end
 
 
 always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
		STAR <= S0;
	else
		case(STAR):
			S0: begin 
				MSG <= M_6; C_COUNT <= (C_COUNT != 0) ? C_COUNT : counter; STAR <= (m_valid == b'1) ? S1 : S0; C_6 <= C_TMP; 
				H_MAIN <= {h_0,h_1,h_2,h_3,h_4,h_5,h_6,h_7}; R_COUNT <= 2'b11; HASH_READY <= 0;
			end 
			S1: begin 
				S_M_6 <= ; S_C_6 <= ;  
			end
   

endmodule



   

