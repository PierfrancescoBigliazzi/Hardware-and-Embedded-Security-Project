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
				
	
		
		@(reset_deassertion);
		DUT_M_valid = 0;

		
		
		@(posedge clk);
		
		fork
		
			begin: TEST_UPPERCASE_A
			    localparam expected_digest_A = 32'h4dd99065;
				$display("TEST_CHAR_A");
				@ (posedge clk);
				DUT_message = "A";
				DUT_counter = 1;
				DUT_M_valid = 1;
				
				@ (posedge clk);
				DUT_M_valid = 0;
				DUT_message = "B";
				DUT_counter = 0;
				
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				$display(DUT_hash_ready);
				$display("Digest A character : %h", DUT_digest_out);
				$display("Test result [ %s ] ", expected_digest_A == DUT_digest_out ? "Successful" : "Failure" );
				$display("Test finished");
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);
				@ (posedge clk);

			end: TEST_UPPERCASE_A
			
		join
		
		$stop;
		
	end

endmodule
					
				
		
	
	


