!
table_set_default  egress_port_link_state drop_act
!
table_add ipv4_lpm set_nhop_local 30.0.0.0/8 => 00:00:00:00:00:03 7
!
table_add ipv4_lpm set_nhop_network 40.0.0.0/8 =>  4
!
table_add ipv4_lpm set_nhop_network 20.0.0.0/8 =>  2
!
table_add ipv4_lpm set_nhop_network 10.0.0.0/8 =>  1 
!
table_add ipv4_lpm set_nhop_network 0.0.0.0/0 =>  111
!
!
table_add ecmp_hash set_ecmp_hash_register 1 => 
table_add ecmp_hash set_ecmp_hash_register 2 =>
table_add ecmp_hash set_ecmp_hash_register 4 =>
!
!
!
table_add egress_port_link_state set_link_state 1 => 1 0 
register_write port_state 1 0
table_add egress_port_link_state set_link_state 2 => 2 0 
register_write port_state 2 0
table_add egress_port_link_state set_link_state 3 => 3 0 
register_write port_state 3 0
table_add egress_port_link_state set_link_state 4 => 4 0 
register_write port_state 4 0
table_add egress_port_link_state set_link_state 5 => 5 0 
register_write port_state 5 0
table_add egress_port_link_state set_link_state 6 => 6 0 
register_write port_state 6 0
!
table_add egress_port_link_state set_link_state 7 => 7 0 
register_write port_state 7 0
! 
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 1 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 2 => 
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 3 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 4 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 5 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 1 6 => 
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 1 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 2 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 3 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 4 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 5 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 2 6 => 
!
!
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 1 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 2 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 3 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 4 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 5 =>
table_add fowarding_tag set_fowarding_tag_ecmp_register 4 6 =>
!
register_write fowarding_tag_ecmp_register_path 11 1
register_write fowarding_tag_ecmp_register_path 12 2
register_write fowarding_tag_ecmp_register_path 13 3
register_write fowarding_tag_ecmp_register_path 14 4
register_write fowarding_tag_ecmp_register_path 15 5
register_write fowarding_tag_ecmp_register_path 16 6    
!
register_write fowarding_tag_ecmp_register_path 21 1
register_write fowarding_tag_ecmp_register_path 22 2
register_write fowarding_tag_ecmp_register_path 23 3
register_write fowarding_tag_ecmp_register_path 24 4
register_write fowarding_tag_ecmp_register_path 25 5
register_write fowarding_tag_ecmp_register_path 26 6  
!
register_write fowarding_tag_ecmp_register_path 41 1
register_write fowarding_tag_ecmp_register_path 42 2
register_write fowarding_tag_ecmp_register_path 43 3
register_write fowarding_tag_ecmp_register_path 44 4
register_write fowarding_tag_ecmp_register_path 45 5
register_write fowarding_tag_ecmp_register_path 46 6
!
register_write port_register_down 0 0 
register_write port_register_down 1 0
register_write port_register_down 2 0 
register_write port_register_down 3 0 
register_write port_register_down 4 0 
register_write port_register_down 5 0 
register_write port_register_down 6 0 
register_write port_register_down 7 0
!
!
register_write fowarding_tag_register_num_path_down 1 0
register_write fowarding_tag_register_num_path_count 1 0
!
register_write fowarding_tag_register_num_path_down 2 0
register_write fowarding_tag_register_num_path_count 2 0  
!
register_write fowarding_tag_register_num_path_down 4 0
register_write fowarding_tag_register_num_path_count 4 0
!
register_write ecmp_hash_register_begin_path 1 1
register_write ecmp_hash_register_num_path 1 6
!
register_write ecmp_hash_register_begin_path 2 1
register_write ecmp_hash_register_num_path 2 6
!                                                          
register_write ecmp_hash_register_begin_path 4 1
register_write ecmp_hash_register_num_path 4 6
!
register_read fowarding_tag_ecmp_register_path 
register_read count_port_register
register_read fowarding_tag_ecmp_register_path_down
register_read ecmp_hash_register_num_path 3
register_read ecmp_hash_register_begin_path 3
register_read port_state
register_read bit_loop
register_read port_register_down
register_read aux1_return_register
register_read aux2_return_register
!

