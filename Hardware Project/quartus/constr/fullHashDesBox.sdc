create_clock -name clk -period 10 [get_ports clk]
set_false_path -from [get_ports rst_n] -to [get_clocks clk]
set_input_delay -min 1 -clock [get_clocks clk] [get_ports {rst_n M_valid counter[*] message[*]}]
set_input_delay -max 2 -clock [get_clocks clk] [get_ports {rst_n M_valid counter[*] message[*]}]
set_output_delay -min 1 -clock [get_clocks clk] [get_ports {digest_out[*] hash_ready}]
set_output_delay -max 2 -clock [get_clocks clk] [get_ports {digest_out[*] hash_ready}]