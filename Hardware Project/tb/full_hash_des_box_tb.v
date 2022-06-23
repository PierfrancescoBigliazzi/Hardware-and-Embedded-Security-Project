// This file contains the testbenches for the full_hash_des_box

// The timescale values are the default ones



module full_hash_des_box_testbench();
    
	reg clk = 1'b0; 
	always #10 clk = !clk; // 50 Mhz clock
	
	reg rst_n = 1'b0;
	event reset_deassertion;
	
	initial begin
		#12.8 rst_n = 1'b1;
		-> reset_deassertion;
	end
	
	reg DUT_M_valid;
	reg [7:0] DUT_message;
	reg [63:0] DUT_counter;
	
	wire [31:0] DUT_digest_out;
	wire DUT_hash_ready;
	
	full_hash_des_box HASH_DUT(
		.clk (clk),
		.rst_n (rst_n),
		.M_valid (DUT_M_valid),
		.message (DUT_message),
		.counter (DUT_counter),
		.digest_out(DUT_digest_out),
		.hash_ready (DUT_hash_ready)
	);
	
	initial begin
		
		begin: TEST_ZERO_LENGTH
			
			localparam expected_digest_empty = 32'h83656fd2;

			@(reset_deassertion);
			DUT_M_valid = 0;

			$display("TEST_ZERO_LENGTH");
			@ (posedge clk);
			DUT_counter = 0;
			DUT_M_valid = 1;
			
			@ (posedge clk);
			DUT_M_valid = 0;
			
			@ (posedge clk);
			@ (posedge clk);
			@ (posedge clk);
			$display("Digest of empty sequence : %h", DUT_digest_out);
			$display("Test result [ %s ] ", expected_digest_empty == DUT_digest_out ? "Successful" : "Failure" );
			$display("TEST_ZERO_LENGTH finished\n");
			@ (posedge clk);

		end: TEST_ZERO_LENGTH

		

		begin: TEST_UPPERCASE_A
			
			localparam expected_digest_A = 32'hc087233c;


			$display("TEST_CHAR_A");
			@ (posedge clk);
			DUT_message = "A";
			DUT_counter = 1;
			DUT_M_valid = 1;
			
			@ (posedge clk);
			DUT_M_valid = 0;
			
			@ (posedge clk);
			@ (posedge clk);
			@ (posedge clk);
			$display("Digest A character : %h", DUT_digest_out);
			$display("Test result [ %s ] ", expected_digest_A == DUT_digest_out ? "Successful" : "Failure" );
			$display("TEST_CHAR_A finished\n");
			@ (posedge clk);

		end: TEST_UPPERCASE_A
		
		begin: TEST_SEQUENCE_AB
			// expected output
			localparam expected_digest_AB = 32'h83656fd4;

			$display("TEST_SEQUENCE_AB");

			// setting inputs
			@ (posedge clk);
			DUT_message = "A";
			DUT_counter = 2;
			DUT_M_valid = 1;

			@ (posedge clk);
			DUT_message = "B";
			
			// deasserting the handshake variable
			@ (posedge clk);
			DUT_M_valid = 0;
			DUT_counter = 1'bx;
			DUT_message = "E";
			
			@ (posedge clk);
			@ (posedge clk);
			@ (posedge clk);

			// compare the result
			$display("Digest AB sequence : %h", DUT_digest_out);
			$display("Test result [ %s ] ", expected_digest_AB == DUT_digest_out ? "Successful" : "Failure" );
			
			$display("TEST_SEQUENCE_AB finished\n");
			@ (posedge clk);

		end: TEST_SEQUENCE_AB
		
		begin: TEST_SAME_MESSAGE_SAME_HASH
		
			reg[31:0] first_Hash;
			// expected output
			localparam expected_digest_AB = 32'h83656fd4;

			$display("TEST_SAME_MESSAGE_SAME_HASH");

			// setting inputs
			@ (posedge clk);
			DUT_message = "A";
			DUT_counter = 2;
			DUT_M_valid = 1;

			@ (posedge clk);
			DUT_message = "B";
			
			// deasserting the handshake variable
			@ (posedge clk);
			DUT_M_valid = 0;
			DUT_counter = 1'bx;
			DUT_message = "E";
			
			@ (posedge clk);
			@ (posedge clk);
			@ (posedge clk);

			// compare the result
			$display("First digest AB sequence : %h", DUT_digest_out);
			first_Hash = DUT_digest_out;
			
			@ (posedge clk);
			@ (posedge clk);
			DUT_message = "A";
			DUT_counter = 2;
			DUT_M_valid = 1;

			@ (posedge clk);
			DUT_message = "B";
			
			// deasserting the handshake variable
			@ (posedge clk);
			DUT_M_valid = 0;
			DUT_counter = 1'bx;
			DUT_message = "E";
			
			@ (posedge clk);
			@ (posedge clk);
			@ (posedge clk);

			// compare the result
			$display("Second digest AB sequence : %h", DUT_digest_out);
			$display("Test result [ %s ] ", first_Hash == DUT_digest_out ? "Successful" : "Failure" );
			$display("TEST_SAME_MESSAGE_SAME_HASH finished\n");
			
		end: TEST_SAME_MESSAGE_SAME_HASH
			
			
		
		begin: TEST_SEQUENCE_A_CLK_B
			// expected output
			localparam expected_digest_AB = 32'h83656fd4;

			$display("TEST_SEQUENCE_AB");

			// setting inputs
			@ (posedge clk);
			DUT_message = "A";
			DUT_counter = 2;
			DUT_M_valid = 1;
			@ (posedge clk);
			DUT_M_valid = 0;
			@ (posedge clk);

			DUT_message = "B";
			DUT_M_valid = 1;
			
			// deasserting the handshake variable
			@ (posedge clk);
			DUT_M_valid = 0;
			
			@ (posedge clk);
			@ (posedge clk);
			@ (posedge clk);

			// compare the result
			$display("Digest A_CLK_B sequence : %h", DUT_digest_out);
			$display("Test result [ %s ] ", expected_digest_AB == DUT_digest_out ? "Successful" : "Failure" );
			
			$display("TEST_SEQUENCE_A_CLK_BS finished\n");
			@ (posedge clk);

		end: TEST_SEQUENCE_A_CLK_B
		
		


	
		$stop;
		
	end

endmodule
					
				
		
	
	

