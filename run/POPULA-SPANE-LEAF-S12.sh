!
table_add ecmp_hash set_ecmp_hash_register 4 =>
table_add ecmp_hash set_ecmp_hash_register 3 => 
table_add ecmp_hash set_ecmp_hash_register 2 =>
table_add ecmp_hash set_ecmp_hash_register 1 =>
!

!
!table_add egress_port_link_state set_link_state 1 => 1 0 
!register_write port_state 1 0
!table_add egress_port_link_state set_link_state 2 => 2 0 
!register_write port_state 2 0
!table_add egress_port_link_state set_link_state 3 => 3 0 
!register_write port_state 3 0
!table_add egress_port_link_state set_link_state 4 => 4 0 
!register_write port_state 4 0
!table_add egress_port_link_state set_link_state 5 => 5 0 
!register_write port_state 5 0
!table_add egress_port_link_state set_link_state 6 => 6 0 
!register_write port_state 6 0
!table_add egress_port_link_state set_link_state 7 => 7 0 
!register_write port_state 7 0
!table_add egress_port_link_state set_link_state 8 => 8 0 
!register_write port_state 8 0
!table_add egress_port_link_state set_link_state 9 => 9 0 
!register_write port_state 9 0
!
!table_add fowarding_tag set_fowarding_tag_ecmp_register 1 1 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 1 2 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 1 3 =>        
!
!table_add fowarding_tag set_fowarding_tag_ecmp_register 2 1 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 2 2 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 2 3 =>        
!
!table_add fowarding_tag set_fowarding_tag_ecmp_register 3 1 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 3 2 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 3 3 =>        
!
!table_add fowarding_tag set_fowarding_tag_ecmp_register 4 1 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 4 2 =>
!table_add fowarding_tag set_fowarding_tag_ecmp_register 4 3 =>
!

!
table_clear fowarding_tag
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 1 => 0b11111100000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 2 => 0b01111110000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 3 => 0b00111111000 0b111111
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 1 => 0b11111100000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 2 => 0b01111110000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 3 => 0b00111111000 0b111111
!
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 3 1 => 0b11111100000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 3 2 => 0b01111110000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 3 3 => 0b00111111000 0b111111
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 1 => 0b11111100000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 2 => 0b01111110000 0b111111
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 3 => 0b00111111000 0b111111
!



table_clear fwd_pkt
!table_add fwd_pkt fwd 0b10000000000&&&0b10000000000 0b100000&&&0b100000 => 1 1
!table_add fwd_pkt fwd 0b01000000000&&&0b01000000000 0b010000&&&0b010000 => 2 2
!table_add fwd_pkt fwd 0b00100000000&&&0b00100000000 0b001000&&&0b001000 => 3 3
!table_add fwd_pkt fwd 0b00010000000&&&0b00010000000 0b000100&&&0b000100 => 4 4
!table_add fwd_pkt fwd 0b00001000000&&&0b00001000000 0b000010&&&0b000010 => 5 5
!table_add fwd_pkt fwd 0b00000100000&&&0b00000100000 0b000001&&&0b000001 => 6 6
!table_add fwd_pkt fwd 0b00000010000&&&0b00000010000 0b100000&&&0b100000 => 1 7
!table_add fwd_pkt fwd 0b00000001000&&&0b00000001000 0b010000&&&0b010000 => 2 8
!table_add fwd_pkt fwd 0b00000000100&&&0b00000000100 0b001000&&&0b001000 => 3 9
!table_add fwd_pkt fwd 0b00000000010&&&0b00000000010 0b000100&&&0b000100 => 4 10
!table_add fwd_pkt fwd 0b00000000001&&&0b00000000001 0b000010&&&0b000010 => 5 11     !              
!
!
register_write fowarding_tag_ecmp_register_path 11 1
register_write fowarding_tag_ecmp_register_path 12 2
register_write fowarding_tag_ecmp_register_path 13 3
!
register_write fowarding_tag_ecmp_register_path 21 4
register_write fowarding_tag_ecmp_register_path 22 5
register_write fowarding_tag_ecmp_register_path 23 6
!        
register_write fowarding_tag_ecmp_register_path 31 7
register_write fowarding_tag_ecmp_register_path 32 8
register_write fowarding_tag_ecmp_register_path 33 9
!        
register_write fowarding_tag_ecmp_register_path 41 1
register_write fowarding_tag_ecmp_register_path 42 2
register_write fowarding_tag_ecmp_register_path 43 3
!
!
register_write port_register_down 0 0 
register_write port_register_down 1 0
register_write port_register_down 2 0 
register_write port_register_down 3 0 
register_write port_register_down 4 0 
register_write port_register_down 5 0 
register_write port_register_down 6 0 
register_write port_register_down 7 0
register_write port_register_down 8 0
register_write port_register_down 9 0  
!
register_write fowarding_tag_register_num_path_down 4 0
register_write fowarding_tag_register_num_path_count 4 0
!
register_write fowarding_tag_register_num_path_down 3 0
register_write fowarding_tag_register_num_path_count 3 0
!
register_write fowarding_tag_register_num_path_down 2 0
register_write fowarding_tag_register_num_path_count 2 0  
!
register_write fowarding_tag_register_num_path_down 1 0
register_write fowarding_tag_register_num_path_count 1 0
!    
register_write ecmp_hash_register_begin_path 4 1
register_write ecmp_hash_register_num_path 4 3
!
register_write ecmp_hash_register_begin_path 3 1
register_write ecmp_hash_register_num_path 3 3
!
register_write ecmp_hash_register_begin_path 2 1
register_write ecmp_hash_register_num_path 2 3
!                                                          
register_write ecmp_hash_register_begin_path 1 1
register_write ecmp_hash_register_num_path 1 3   
!
!register_read fowarding_tag_ecmp_register_path 
!register_read count_port_register
!register_read fowarding_tag_ecmp_register_path_down
!register_read ecmp_hash_register_num_path 3
!register_read ecmp_hash_register_begin_path 3
!register_read port_state
!register_read bit_loop
!register_read port_register_down
!register_read aux1_return_register
!register_read aux2_return_register
!

