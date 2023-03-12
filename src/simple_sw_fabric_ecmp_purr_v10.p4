#include <core.p4>
#include <v1model.p4>


const bit<16> TYPE_IPV4 = 0x800;
const bit<16> TYPE_FOWARDING_TAG = 0x010;


typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<16> dst_id_t;
typedef bit<16> src_id_t;
typedef bit<16> protocol_type_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16> etherType;
}


header fowarding_tag_t {
    dst_id_t dst_id;
    protocol_type_t protocol_type;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<6>    dscp;
    bit<2>    ecn;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

header tcp_t{
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<4>  res;
    bit<1>  cwr;
    bit<1>  ece;
    bit<1>  urg;
    bit<1>  ack;
    bit<1>  psh;
    bit<1>  rst;
    bit<1>  syn;
    bit<1>  fin;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

struct metadata {
    bit<32> ecmp_hash;
    bit<32> ecmp_group_id;
    bit<9> count;
    bit<1> link_state;
    bit<1> link_local;
    bit<1> link_network;
    bit<32> hash1;
    bit<32> ecmp_path_selector;
    bit<16> dst_id;
    bit<32> r_begin_path;
    bit<32> r_num_paths;
    bit<32> id_move;    
    bit<9> egress_spec_port;
    bit<32> port_counter;
    bit<32> dst_id_ecmp_path_selector;
    bit<32> dst_id_port_down;
    bit<32> dst_id_r_num_paths;
    bit<32> starting_port_purr;
    bit<32> all_ports_purr; 
}


struct headers {
    ethernet_t   ethernet;
    ipv4_t       ipv4;
    tcp_t        tcp;
    fowarding_tag_t fowarding_tag;
}




/*************************************************************************
*********************** P A R S E R  *******************************
*************************************************************************/

parser MyParser(packet_in packet, out headers hdr, inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {

        transition parse_ethernet;
    }

state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType){
            TYPE_IPV4: parse_ipv4;
            TYPE_FOWARDING_TAG: parse_fowarding_tag; 
            default: accept;
        }
    }

  state parse_fowarding_tag {
          packet.extract(hdr.fowarding_tag);
// No parser o meta.dst recebe o DST_ID do next hop, usado no fowarding_tag para encaminhar pacotes;
          meta.dst_id = hdr.fowarding_tag.dst_id;
          transition select(hdr.fowarding_tag.protocol_type) {
          TYPE_IPV4: parse_ipv4;
          default: accept; 
         }
     }

state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol){
            6 : parse_tcp;
            default: accept;
        }
    }

   state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {

        //parsed headers have to be added again into the packet.
        packet.emit(hdr.ethernet);
        packet.emit(hdr.fowarding_tag);
        packet.emit(hdr.ipv4);
        //Only emited if valid
        packet.emit(hdr.tcp);
    }
}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply { 

    //  update_checksum
          verify_checksum_with_payload(
            hdr.ipv4.isValid(),
            { hdr.ipv4.version,
              hdr.ipv4.ihl,
              hdr.ipv4.dscp,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);

     }
}
/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

 action drop_act() {
       standard_metadata.egress_spec = 511;
     }

 action nop() {

    }

 action compute_hash() {
         hash(meta.hash1, HashAlgorithm.crc32,
              (bit<16>) 0,
              {hdr.ipv4.srcAddr,
               hdr.ipv4.dstAddr,
               hdr.ipv4.protocol,
               hdr.tcp.srcPort,
               hdr.tcp.dstPort},
               (bit<32>) 65536); 
          
           }  
            

 action set_nhop_local(macAddr_t dstAddr, egressSpec_t port) { 
     hdr.ethernet.etherType = 0x800; 
     hdr.ethernet.dstAddr = dstAddr;
     hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
     hdr.fowarding_tag.setInvalid(); 
     standard_metadata.egress_spec = port;  
     meta.dst_id = 0; 
   }

 action set_nhop_network(dst_id_t dst_id) {
     meta.dst_id = dst_id;
   }   


table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            set_nhop_local;
            set_nhop_network;
            drop_act;
        }
        size = 1024;
     
    }



// HASH1 Tuple 5 TEST

 register<bit<16>>(100) ecmp_hash_register_begin_path;
 register<bit<32>>(100) ecmp_hash_register_num_path;

 action set_ecmp_hash_register() {
         bit<16> r_begin_path;
         bit<32> r_num_paths;
         bit<16> total_begin_path;
         bit<32> total_num_paths;
         ecmp_hash_register_begin_path.read(r_begin_path,(bit<32>)meta.dst_id);
         ecmp_hash_register_num_path.read(r_num_paths, (bit<32>)meta.dst_id);
         meta.r_num_paths = r_num_paths;
         hash(meta.ecmp_path_selector, HashAlgorithm.crc32,
                 r_begin_path,     
                 {hdr.ipv4.srcAddr,
                 hdr.ipv4.dstAddr,
                 hdr.ipv4.protocol,
                 hdr.tcp.srcPort,
                 hdr.tcp.dstPort},
                 r_num_paths);  
       }       


table ecmp_hash {
        key = {
                       
            meta.dst_id: exact;
        }
        actions = {
            drop_act;
            set_ecmp_hash_register;
         }
        size = 1024;
    }

 register<bit<9>>(100) fowarding_tag_ecmp_register_path;        

// Purr - Register - Port UP/DOWN
//register<bit<64>>(32w1) all_ports_status_purr; 
//register<bit<32>>(32w0b01) all_ports_status_purr;
//

 action set_fowarding_tag_ecmp_register(bit<32> port_state_purr, bit<32> all_port_status_purr) {
         bit<9> port;               
         hdr.ethernet.etherType = 0x010;
         hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
         hdr.fowarding_tag.setValid();
         hdr.fowarding_tag.dst_id =  meta.dst_id;
         hdr.fowarding_tag.protocol_type = 0x800;
         meta.dst_id_ecmp_path_selector = (bit<32>)meta.dst_id * 10 + meta.ecmp_path_selector;  
         fowarding_tag_ecmp_register_path.read(port, meta.dst_id_ecmp_path_selector);
         standard_metadata.egress_spec = port;
//Purr Map egress port
         meta.starting_port_purr = port_state_purr;
         meta.all_ports_purr = all_port_status_purr;     
       } 

table  fowarding_tag {
        actions = {
            set_fowarding_tag_ecmp_register;
            drop_act;
            nop; 
       }          
         key = {
             meta.dst_id : exact;  
             meta.ecmp_path_selector : exact;
  
         }
         size = 512;
         default_action = nop;
    } 

// Purr match action table - FRR
action fwd(bit<9> _port) {
        standard_metadata.egress_spec = _port;
    }


table fwd_pkt {
        actions = {
            fwd;
        }
        key = {
            meta.starting_port_purr: ternary;
            meta.all_ports_purr    : ternary;
        }
 }



/* DISABLE - Purr

 register<bit<1>>(100) port_state;

  action set_link_state(bit<32> port, bit<1> link_state) {
        meta.link_state = link_state;
        port_state.write(port, link_state);
      }
   
    table egress_port_link_state {
         actions = {
            set_link_state;
            drop_act;
            nop; 
         }
         key = {
             standard_metadata.egress_spec : exact;
         }
         size = 512;
         default_action = drop_act;
    }
*/

 
apply {

       ipv4_lpm.apply();   
       ecmp_hash.apply();
       fowarding_tag.apply();
//       egress_port_link_state.apply();
//       all_ports_status_purr.read(meta.all_ports_purr,0);
       fwd_pkt.apply(); 


}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
}

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {


        

    apply {

       

    }

}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
     apply {
	update_checksum(
	    hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	      hdr.ipv4.ihl,
              hdr.ipv4.dscp,
              hdr.ipv4.ecn,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}




/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

//switch architecture
V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;



